require('dotenv').config();
const express = require('express'), mysql = require('mysql2/promise'), path = require('path'), fs = require('fs'), crypto = require('crypto');
const { AsyncLocalStorage } = require('async_hooks'), { escape } = require('mysql2'), { analyze, LOGS } = require('./sqlsafe');
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost', port: +process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root', password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'db_ansarah', dateStrings: true, connectionLimit: 8
});
const USER = +process.env.DASH_USER_ID || 1, DB = process.env.DB_NAME || 'db_ansarah';
// Backups ficam em storage/ (fora de public/): nenhum arquivo é servido como estático.
const STORAGE = path.resolve(__dirname, 'storage'), BK = path.join(STORAGE, 'backups'), UP = path.join(STORAGE, 'uploads');
fs.mkdirSync(BK, { recursive: true }); fs.mkdirSync(UP, { recursive: true });
// Restaurar só é liberado em banco de teste (nome com teste/test/homolog) ou com ALLOW_RESTORE_ANY=true
const RESTORE_OK = /(teste|test|homolog)/i.test(DB) || process.env.ALLOW_RESTORE_ANY === 'true';
const inside = p => { const f = path.resolve(String(p || '')); return f.startsWith(STORAGE + path.sep) && /\.sql$/i.test(f) ? f : null; };
const Q = (sql, p) => pool.query(sql, p).then(r => r[0]);
const app = express(); app.use(express.json()); app.use(express.static(path.join(__dirname, 'public')));
const wrap = fn => async (req, res) => { try { res.json(await fn(req.body ?? {}, req)); } catch (e) { res.status(400).json({ erro: e.sqlMessage || e.message }); } };

// ---------- OPERADOR: quem está fazendo a operação (só perfis de gerência/administração) ----------
const als = new AsyncLocalStorage();
const AUTH = (process.env.PERFIS_AUTORIZADOS || 'gerente,administrador,diretor,coordenador').toLowerCase().split(',').map(s => s.trim()).filter(Boolean);
const autorizado = perfil => AUTH.some(a => String(perfil || '').toLowerCase().includes(a));
const cur = () => als.getStore()?.user ?? USER;      // responsável gravado em BACKUP_SISTEMA, REGISTRO_RESTAURACAO e LOG_AUDITORIA
app.use('/api', async (req, res, next) => {          // toda operação que grava exige um operador autorizado
  if (req.method === 'GET') return next();
  let u;
  try {
    const id = +req.get('x-operador');
    if (!id) throw new Error('Selecione o operador responsável (campo "Operador" no topo da página).');
    [u] = await Q('SELECT id_usuario, perfil_acesso, status_usuario FROM usuario_sistema WHERE id_usuario=?', [id]);
    if (!u || String(u.status_usuario).toLowerCase() !== 'ativo') throw new Error('Operador inválido ou inativo.');
    if (!autorizado(u.perfil_acesso)) throw new Error(`O perfil "${u.perfil_acesso}" não tem permissão. Permitidos: ${AUTH.join(', ')}.`);
  } catch (e) { return res.status(403).json({ erro: e.message }); }
  als.run({ user: u.id_usuario }, next);
});
app.get('/api/operadores', wrap(async () => {
  const rows = await Q(`SELECT u.id_usuario, u.login_usuario, u.perfil_acesso, f.nome_funcionario, f.cargo_funcionario
    FROM usuario_sistema u JOIN Funcionario f ON f.id_funcionario=u.id_funcionario WHERE u.status_usuario='Ativo' ORDER BY f.nome_funcionario`);
  const perfis = (await Q('SELECT DISTINCT perfil_acesso FROM usuario_sistema ORDER BY perfil_acesso')).map(r => r.perfil_acesso);
  return { operadores: rows.filter(r => autorizado(r.perfil_acesso)), perfis };
}));

// ---------- LEITURA: tudo que o dashboard precisa em uma chamada ----------
app.get('/api/data', wrap(async () => {
  const [skus, produtos, vendas, repos, audit, backups, restores, fornec, cores, tams, marcas] = await Promise.all([
    Q(`SELECT s.id_sku, s.codigo_sku, s.quantidade_estoque AS est, s.peso, s.id_cor, s.id_tamanho, s.id_produto,
         p.nome_produto, p.grupo_produto, m.nome_marca, c.nome_cor, t.sigla_tamanho
       FROM Produto_SKU s JOIN Produto p ON p.id_produto=s.id_produto JOIN Marca m ON m.id_marca=p.id_marca
       LEFT JOIN Cor c ON c.id_cor=s.id_cor LEFT JOIN Tamanho t ON t.id_tamanho=s.id_tamanho ORDER BY s.id_sku`),
    Q(`SELECT p.id_produto, p.nome_produto, p.codigo_produto, p.descricao_produto, p.referencia_produto, p.codigo_ncm,
         p.grupo_produto, p.categoria_produto, p.tipo_produto, p.unidade_tributacao_produto, p.id_marca, m.nome_marca FROM Produto p JOIN Marca m ON m.id_marca=p.id_marca ORDER BY p.id_produto`),
    Q(`SELECT v.id_venda, v.data_venda, v.canal_venda, v.desconto_venda, v.status_venda,
         i.id_sku, i.quantidade_item_venda AS q, i.preco_unitario_venda AS pr
       FROM Venda v LEFT JOIN Item_venda i ON i.id_venda=v.id_venda ORDER BY v.data_venda DESC, v.id_venda DESC`),
    Q(`SELECT r.id_reposicao, r.data_reposicao, r.status_reposicao, f.nome_fornecedor, i.id_item_reposicao, i.id_sku,
         i.quantidade_solicitada AS sol, i.quantidade_recebida AS rec
       FROM pedido_reposicao r JOIN Fornecedor f ON f.id_fornecedor=r.id_fornecedor
       JOIN Item_reposicao i ON i.id_reposicao=r.id_reposicao ORDER BY r.id_reposicao DESC, i.id_item_reposicao`),
    Q(`SELECT l.id_log, l.data_hora_log, l.tipo_operacao, l.entidade_afetada, l.descricao_operacao, l.justificativa_operacao,
         u.login_usuario FROM LOG_AUDITORIA l LEFT JOIN usuario_sistema u ON u.id_usuario=l.id_usuario
       ORDER BY l.data_hora_log DESC, l.id_log DESC LIMIT 40`),
    Q('SELECT b.*, u.login_usuario FROM BACKUP_SISTEMA b LEFT JOIN usuario_sistema u ON u.id_usuario=b.id_usuario ORDER BY b.data_inicio_backup DESC, b.id_backup DESC LIMIT 200'),
    Q('SELECT r.*, u.login_usuario, b.tipo_backup, b.data_inicio_backup AS backup_data FROM REGISTRO_RESTAURACAO r LEFT JOIN usuario_sistema u ON u.id_usuario=r.id_usuario LEFT JOIN BACKUP_SISTEMA b ON b.id_backup=r.id_backup ORDER BY r.data_inicio_restauracao DESC, r.id_restauracao DESC LIMIT 200'),
    Q("SELECT id_fornecedor, nome_fornecedor FROM Fornecedor ORDER BY nome_fornecedor"),
    Q('SELECT id_cor, nome_cor FROM Cor ORDER BY nome_cor'), Q('SELECT id_tamanho, sigla_tamanho FROM Tamanho ORDER BY id_tamanho'), Q('SELECT id_marca, nome_marca FROM Marca ORDER BY nome_marca')
  ]);
  backups.forEach(b => { const f = inside(b.local_armazenamento); b.disponivel = !!(f && fs.existsSync(f)); });
  return { skus, produtos, vendas, repos, audit, backups, restores, fornec, cores, tams, marcas, meta: { banco: DB, restauracaoPermitida: RESTORE_OK } };
}));

// ---------- ESCRITA: o que for feito no dashboard vai para o MySQL (e para a LOG_AUDITORIA) ----------
async function tx(fn) {
  const c = await pool.getConnection();
  try { await c.beginTransaction(); const r = await fn(c); await c.commit(); return r; }
  catch (e) { await c.rollback(); throw e; } finally { c.release(); }
}
const audit = (c, tipo, ent, desc, just, id, ant, novo) => c.query(
  `INSERT INTO LOG_AUDITORIA (data_hora_log,tipo_operacao,entidade_afetada,descricao_operacao,justificativa_operacao,
   id_registro_afetado,valor_anterior,valor_novo,id_usuario) VALUES (NOW(),?,?,?,?,?,?,?,?)`,
  [tipo, ent, desc, just || null, String(id), ant || null, novo || null, cur()]);
const need = (b, ...k) => k.forEach(x => { if (b[x] === undefined || b[x] === '') throw new Error('Campo obrigatório: ' + x); });

app.post('/api/sku', wrap(b => tx(async c => {
  need(b, 'codigo_sku', 'id_produto', 'quantidade_estoque');
  const [r] = await c.query('INSERT INTO Produto_SKU (codigo_sku,quantidade_estoque,id_cor,id_tamanho,id_produto) VALUES (?,?,?,?,?)',
    [b.codigo_sku, +b.quantidade_estoque, b.id_cor || null, b.id_tamanho || null, +b.id_produto]);
  await audit(c, 'INSERT', 'Produto_SKU', 'Cadastro de novo SKU pelo dashboard.', b.justificativa || 'Novo SKU', r.insertId, null, `codigo_sku=${b.codigo_sku}; quantidade_estoque=${b.quantidade_estoque}`);
  return { ok: true };
})));

app.post('/api/estoque', wrap(b => tx(async c => {
  need(b, 'id_sku', 'quantidade', 'justificativa');
  const [[s]] = await c.query('SELECT quantidade_estoque q FROM Produto_SKU WHERE id_sku=? FOR UPDATE', [b.id_sku]);
  if (!s) throw new Error('SKU não encontrado');
  await c.query('UPDATE Produto_SKU SET quantidade_estoque=? WHERE id_sku=?', [+b.quantidade, b.id_sku]);
  await audit(c, 'UPDATE', 'Produto_SKU', 'Ajuste de estoque pelo dashboard.', b.justificativa, b.id_sku, 'quantidade_estoque=' + s.q, 'quantidade_estoque=' + b.quantidade);
  return { ok: true };
})));

app.post('/api/venda', wrap(b => tx(async c => {
  need(b, 'canal', 'status'); if (!b.itens?.length) throw new Error('Informe ao menos um item');
  const [r] = await c.query('INSERT INTO Venda (data_venda,canal_venda,desconto_venda,status_venda) VALUES (NOW(),?,?,?)', [b.canal, +b.desconto || 0, b.status]);
  for (const i of b.itens) {
    await c.query('INSERT INTO Item_venda (quantidade_item_venda,preco_unitario_venda,id_sku,id_venda) VALUES (?,?,?,?)', [+i.qtd, +i.preco, i.id_sku, r.insertId]);
    if (/^conclu/i.test(b.status.normalize('NFD').replace(/[\u0300-\u036f]/g, ''))) {
      const [u] = await c.query('UPDATE Produto_SKU SET quantidade_estoque=quantidade_estoque-? WHERE id_sku=? AND quantidade_estoque>=?', [+i.qtd, i.id_sku, +i.qtd]);
      if (!u.affectedRows) throw new Error('Estoque insuficiente para o SKU ' + i.id_sku);
    }
  }
  await audit(c, 'INSERT', 'Venda', 'Registro de venda pelo dashboard.', 'Registrar a venda realizada.', r.insertId, null, `status_venda=${b.status}; canal_venda=${b.canal}`);
  return { ok: true, id_venda: r.insertId };
})));

app.post('/api/reposicao', wrap(b => tx(async c => {
  need(b, 'id_fornecedor'); if (!b.itens?.length) throw new Error('Informe ao menos um item');
  const total = b.itens.reduce((a, i) => a + i.qtd * i.preco, 0), st = 'Aguardando confirmação';
  const [r] = await c.query('INSERT INTO pedido_reposicao (data_reposicao,data_prevista_entrega,status_reposicao,observacao_reposicao,valor_total_reposicao,id_fornecedor) VALUES (CURDATE(),?,?,?,?,?)',
    [b.previsao || null, st, 'Criado pelo dashboard', total, b.id_fornecedor]);
  for (const i of b.itens) await c.query('INSERT INTO Item_reposicao (quantidade_solicitada,quantidade_recebida,preco_item_reposicao,status_item_reposicao,id_reposicao,id_sku) VALUES (?,0,?,?,?,?)', [+i.qtd, +i.preco, st, r.insertId, i.id_sku]);
  await audit(c, 'INSERT', 'pedido_reposicao', 'Cadastro de pedido de reposição pelo dashboard.', 'Registrar nova solicitação ao fornecedor.', r.insertId, null, 'status_reposicao=' + st);
  return { ok: true };
})));

app.post('/api/receber', wrap(b => tx(async c => {
  need(b, 'id_item_reposicao', 'qtd');
  const [[it]] = await c.query('SELECT * FROM Item_reposicao WHERE id_item_reposicao=? FOR UPDATE', [b.id_item_reposicao]);
  if (!it) throw new Error('Item não encontrado');
  const q = Math.min(+b.qtd, it.quantidade_solicitada - it.quantidade_recebida); if (q <= 0) throw new Error('Nada pendente neste item');
  const rec = it.quantidade_recebida + q, st = rec >= it.quantidade_solicitada ? 'Recebido' : 'Parcialmente recebido';
  await c.query('UPDATE Item_reposicao SET quantidade_recebida=?, status_item_reposicao=? WHERE id_item_reposicao=?', [rec, st, it.id_item_reposicao]);
  await c.query('UPDATE Produto_SKU SET quantidade_estoque=quantidade_estoque+? WHERE id_sku=?', [q, it.id_sku]);
  const [[o]] = await c.query("SELECT COUNT(*) n FROM Item_reposicao WHERE id_reposicao=? AND status_item_reposicao<>'Recebido'", [it.id_reposicao]);
  if (!o.n) await c.query("UPDATE pedido_reposicao SET status_reposicao='Recebido', data_entrega_real=CURDATE() WHERE id_reposicao=?", [it.id_reposicao]);
  await audit(c, 'UPDATE', 'Item_reposicao', 'Recebimento de mercadoria pelo dashboard.', 'Atualizar saldo após conferência do recebimento.', it.id_item_reposicao, 'quantidade_recebida=' + it.quantidade_recebida, 'quantidade_recebida=' + rec);
  return { ok: true };
})));

// ---------- PRODUTOS: cadastrar / editar / excluir ----------
const PF = ['nome_produto','codigo_produto','descricao_produto','referencia_produto','codigo_ncm','grupo_produto','categoria_produto','tipo_produto','unidade_tributacao_produto','id_marca'];
const NN = ['nome_produto','codigo_produto','grupo_produto','categoria_produto','tipo_produto','unidade_tributacao_produto','id_marca'];
const pv = (b, k) => (b[k] === undefined || b[k] === '') ? (k === 'descricao_produto' ? '' : null) : b[k];
app.post('/api/produto', wrap(b => tx(async c => {
  need(b, ...NN);
  const [r] = await c.query(`INSERT INTO Produto (${PF.join(',')}) VALUES (${PF.map(() => '?').join(',')})`, PF.map(k => pv(b, k)));
  await audit(c, 'INSERT', 'Produto', 'Cadastro de produto pelo dashboard.', 'Novo produto no catálogo.', r.insertId, null, `codigo_produto=${b.codigo_produto}; nome_produto=${b.nome_produto}`);
  return { ok: true };
})));
app.put('/api/produto/:id', wrap((b, req) => tx(async c => {
  need(b, ...NN);
  const [[o]] = await c.query('SELECT * FROM Produto WHERE id_produto=? FOR UPDATE', [req.params.id]);
  if (!o) throw new Error('Produto não encontrado');
  await c.query(`UPDATE Produto SET ${PF.map(k => k + '=?').join(',')} WHERE id_produto=?`, [...PF.map(k => pv(b, k)), req.params.id]);
  const ch = PF.filter(k => String(o[k] ?? '') !== String(pv(b, k) ?? ''));
  await audit(c, 'UPDATE', 'Produto', 'Edição de produto pelo dashboard.', 'Correção de cadastro.', req.params.id, ch.map(k => `${k}=${o[k]}`).join('; ') || null, ch.map(k => `${k}=${pv(b, k)}`).join('; ') || null);
  return { ok: true };
})));
app.delete('/api/produto/:id', wrap((b, req) => tx(async c => {
  const [[o]] = await c.query('SELECT nome_produto, codigo_produto FROM Produto WHERE id_produto=?', [req.params.id]);
  if (!o) throw new Error('Produto não encontrado');
  const [[n]] = await c.query('SELECT COUNT(*) n FROM Produto_SKU WHERE id_produto=?', [req.params.id]);
  if (n.n) throw new Error(`Não é possível excluir: o produto tem ${n.n} SKU(s) vinculado(s).`);
  await c.query('DELETE FROM Produto WHERE id_produto=?', [req.params.id]);
  await audit(c, 'DELETE', 'Produto', 'Exclusão de produto pelo dashboard.', 'Remoção de cadastro.', req.params.id, `codigo_produto=${o.codigo_produto}; nome_produto=${o.nome_produto}`, null);
  return { ok: true };
})));

// ---------- BACKUP: gera o arquivo .sql de verdade (estrutura + dados), sem depender do mysqldump ----------
const bt = n => '`' + String(n).replace(/`/g, '``') + '`';
const dtf = d => { const p = n => String(n).padStart(2, '0'); return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`; };
async function dumpTo(file) {
  const out = fs.createWriteStream(file, { encoding: 'utf8' });
  const w = s => new Promise((res, rej) => out.write(s, e => e ? rej(e) : res()));
  await w(`-- ANSARAH | dump do banco ${DB}\n-- Gerado em: ${dtf(new Date())}\nSET NAMES utf8mb4;\nSET FOREIGN_KEY_CHECKS=0;\n\n`);
  const tabs = (await Q("SHOW FULL TABLES WHERE Table_type='BASE TABLE'")).map(r => Object.values(r)[0]);
  for (const t of tabs) {
    const [[c]] = await pool.query('SHOW CREATE TABLE ' + bt(t));
    await w(`DROP TABLE IF EXISTS ${bt(t)};\n${c['Create Table']};\n\n`);
    const rows = await Q('SELECT * FROM ' + bt(t));
    for (let i = 0; i < rows.length; i += 200) {
      const part = rows.slice(i, i + 200), cols = Object.keys(part[0]);
      await w(`INSERT INTO ${bt(t)} (${cols.map(bt).join(',')}) VALUES\n${part.map(r => '(' + cols.map(k => escape(r[k])).join(',') + ')').join(',\n')};\n`);
    }
    await w('\n');
  }
  await w('SET FOREIGN_KEY_CHECKS=1;\n-- FIM DO DUMP\n');
  await new Promise((res, rej) => out.end(e => e ? rej(e) : res()));
}
async function makeBackup(tag) {
  const ini = new Date(), nome = `backup_${tag}_${DB}_${dtf(ini).replace(/[-: ]/g, '')}.sql`, file = path.join(BK, nome);
  let size = null, erro = null;
  try {
    await dumpTo(file);
    size = fs.statSync(file).size;
    const fd = fs.openSync(file, 'r'), len = Math.min(200, size), buf = Buffer.alloc(len);
    fs.readSync(fd, buf, 0, len, size - len); fs.closeSync(fd);
    if (!size || !buf.toString('utf8').includes('FIM DO DUMP')) throw new Error('o arquivo gerado está incompleto');
  } catch (e) { erro = e.message; size = null; fs.rmSync(file, { force: true }); }   // só vira "Concluido" se o arquivo existe e está íntegro
  const [r] = await pool.query('INSERT INTO BACKUP_SISTEMA (tipo_backup,data_inicio_backup,data_fim_backup,local_armazenamento,status_backup,tamanho_backup_bytes,id_usuario) VALUES (?,?,?,?,?,?,?)',
    ['Completo', dtf(ini), dtf(new Date()), file.replace(/\\/g, '/'), erro ? 'Falhou' : 'Concluido', size, cur()]);
  try { await audit(pool, 'BACKUP', 'BACKUP_SISTEMA', erro ? 'Falha ao exportar o banco pelo painel.' : 'Exportação do banco de dados pelo painel.', 'Gerar cópia de segurança do banco.', r.insertId, null, erro ? 'status_backup=Falhou' : `arquivo=${nome}; tamanho=${size}`); } catch (_) {}
  if (erro) throw new Error('Falha ao gerar o backup: ' + erro);
  return { id: r.insertId, file, nome, size };
}
app.post('/api/backup/exportar', wrap(async () => { const b = await makeBackup('completo'); return { id_backup: b.id, arquivo: b.nome, tamanho: b.size }; }));
app.get('/api/backup/:id/download', async (req, res) => {   // só serve arquivos registrados no BD e dentro de storage/
  try {
    const [b] = await Q('SELECT local_armazenamento FROM BACKUP_SISTEMA WHERE id_backup=?', [+req.params.id]);
    const f = b && inside(b.local_armazenamento);
    if (!f || !fs.existsSync(f)) return res.status(404).json({ erro: 'Arquivo não encontrado no servidor' });
    res.download(f);
  } catch (e) { res.status(500).json({ erro: e.message }); }
});

// ---------- RESTAURAÇÃO: valida → confirma → backup de segurança → executa → registra ----------
const pending = new Map();
app.post('/api/restore/validar', express.text({ type: '*/*', limit: '60mb' }), wrap((b, req) => {
  if (!RESTORE_OK) throw new Error(`Restauração bloqueada: o banco "${DB}" não é de teste. Use um banco com "teste" no nome.`);
  const nome = String(req.query.nome || '');
  if (!/\.sql$/i.test(nome)) throw new Error('O arquivo precisa ter extensão .sql');
  const { resumo } = analyze(b);                       // lança erro se houver qualquer comando fora da lista permitida
  const token = crypto.randomBytes(16).toString('hex'), file = path.join(UP, `upload_${Date.now()}_${token.slice(0, 6)}.sql`);
  fs.writeFileSync(file, b, 'utf8');
  pending.set(token, { file, nome, size: fs.statSync(file).size, exp: Date.now() + 30 * 60e3 });
  return { token, nome, tamanho: pending.get(token).size, resumo };
}));
async function applyFile(file) {
  const { stmts } = analyze(fs.readFileSync(file, 'utf8')), c = await pool.getConnection();
  let exec = 0, ign = 0;
  try {
    await c.query('SET NAMES utf8mb4'); await c.query('SET FOREIGN_KEY_CHECKS=0');
    for (const x of stmts) { if (x.k === 'ignorar' || x.skip) { if (x.skip) ign++; continue; } await c.query(x.s); exec++; }
  } finally { try { await c.query('SET FOREIGN_KEY_CHECKS=1'); } catch (_) {} c.release(); }
  return { exec, ign };
}
app.post('/api/restore', wrap(async b => {
  if (!RESTORE_OK) throw new Error('Restauração bloqueada neste banco.');
  const p = pending.get(b.token); pending.delete(b.token);
  if (!p || p.exp < Date.now()) throw new Error('Valide o arquivo novamente antes de restaurar.');
  const motivo = String(b.motivo || '').trim();
  if (motivo.length < 5) throw new Error('Informe o motivo da restauração.');
  if (b.confirmacao !== DB) throw new Error(`Confirmação incorreta: digite exatamente o nome do banco (${DB}).`);
  const ini = new Date();
  let seg;   // proteção: sem backup de segurança íntegro, a restauração NÃO acontece
  try { seg = await makeBackup('seguranca'); } catch (e) { throw new Error('Restauração cancelada: não foi possível gerar o backup de segurança. ' + e.message); }
  const [ub] = await pool.query('INSERT INTO BACKUP_SISTEMA (tipo_backup,data_inicio_backup,data_fim_backup,local_armazenamento,status_backup,tamanho_backup_bytes,id_usuario) VALUES (?,?,?,?,?,?,?)',
    ['Completo', dtf(ini), dtf(ini), p.file.replace(/\\/g, '/'), 'Concluido', p.size, cur()]);   // arquivo enviado, guardado em storage/uploads
  const [rr] = await pool.query('INSERT INTO REGISTRO_RESTAURACAO (data_inicio_restauracao,status_restauracao,motivo_restauracao,observacao_restauracao,id_backup,id_usuario) VALUES (?,?,?,?,?,?)',
    [dtf(ini), 'Em andamento', motivo.slice(0, 255), `Backup de segurança #${seg.id} gerado antes.`, ub.insertId, cur()]);
  let status = 'Concluida', obs;
  try { const r = await applyFile(p.file); obs = `${r.exec} comandos executados; histórico de backups/restaurações/auditoria preservado. Backup de segurança #${seg.id}.`; }
  catch (e) {
    status = 'Falhou'; obs = `Falha: ${e.sqlMessage || e.message}. `;
    try { await applyFile(seg.file); obs += `Banco revertido ao backup de segurança #${seg.id}.`; } catch (e2) { obs += `Reversão automática falhou; restaure manualmente o backup #${seg.id}.`; }
  }
  await pool.query('UPDATE REGISTRO_RESTAURACAO SET data_fim_restauracao=?, status_restauracao=?, observacao_restauracao=? WHERE id_restauracao=?', [dtf(new Date()), status, obs.slice(0, 255), rr.insertId]);
  try { await audit(pool, 'RESTORE', 'REGISTRO_RESTAURACAO', 'Restauração do banco pelo painel.', motivo, rr.insertId, null, 'status_restauracao=' + status); } catch (_) {}
  if (status !== 'Concluida') throw new Error(obs);
  return { ok: true, observacao: obs };
}));

// Cadastro de funcionário + usuário (para que uma pessoa passe a aparecer como responsável). Exige operador autorizado.
app.post('/api/operador', wrap(b => tx(async c => {
  need(b, 'nome_funcionario', 'cargo_funcionario', 'id_departamento', 'login_usuario', 'perfil_acesso');
  const login = String(b.login_usuario).trim().toLowerCase();
  if (!/^[a-z0-9._-]{3,80}$/.test(login)) throw new Error('Login inválido (use letras, números, ponto; mínimo 3 caracteres).');
  const [[ex]] = await c.query('SELECT COUNT(*) n FROM usuario_sistema WHERE login_usuario=?', [login]);
  if (ex.n) throw new Error('Esse login já existe.');
  const [f] = await c.query('INSERT INTO Funcionario (nome_funcionario,cargo_funcionario,id_departamento) VALUES (?,?,?)', [String(b.nome_funcionario).trim(), String(b.cargo_funcionario).trim(), +b.id_departamento]);
  // senha_hash é obrigatória no banco; o painel não usa senha, então grava um valor aleatório que ninguém conhece
  const [u] = await c.query("INSERT INTO usuario_sistema (login_usuario,senha_hash,perfil_acesso,status_usuario,data_criacao,id_funcionario) VALUES (?,?,?,'Ativo',NOW(),?)", [login, '$sem-senha$' + crypto.randomBytes(24).toString('hex'), String(b.perfil_acesso).trim(), f.insertId]);
  await audit(c, 'INSERT', 'usuario_sistema', 'Cadastro de funcionário e usuário pelo dashboard.', 'Registrar responsável pelas operações.', u.insertId, null, `login_usuario=${login}; perfil_acesso=${b.perfil_acesso}`);
  return { ok: true, id_usuario: u.insertId };
})));

// ---------- FUNCIONÁRIOS (somente leitura: Funcionario, Departamento e usuario_sistema) ----------
app.get('/api/funcionarios', wrap(async () => {
  const [funcionarios, departamentos] = await Promise.all([
    Q(`SELECT f.id_funcionario, f.nome_funcionario, f.cargo_funcionario, f.id_departamento, d.nome_departamento,
         u.login_usuario, u.status_usuario
       FROM Funcionario f JOIN Departamento d ON d.id_departamento=f.id_departamento
       LEFT JOIN usuario_sistema u ON u.id_funcionario=f.id_funcionario ORDER BY f.nome_funcionario`),
    Q(`SELECT d.id_departamento, d.nome_departamento, COUNT(f.id_funcionario) AS total
       FROM Departamento d LEFT JOIN Funcionario f ON f.id_departamento=d.id_departamento
       GROUP BY d.id_departamento, d.nome_departamento ORDER BY d.nome_departamento`)
  ]);
  return { funcionarios, departamentos };
}));

const port = +process.env.PORT || 3000, host = process.env.HOST || '127.0.0.1';   // só acessível desta máquina por padrão
app.listen(port, host, () => console.log(`ANSARAH Dashboard: http://localhost:${port}  |  banco: ${DB}  |  restauração ${RESTORE_OK ? 'LIBERADA (banco de teste)' : 'bloqueada'}`));
