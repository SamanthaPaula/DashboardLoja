// Validação de arquivos .sql antes de qualquer restauração.
// Só aceita comandos de dump (DROP/CREATE TABLE e INSERT ... VALUES) das 25 tabelas do db_ansarah.
// Nada é executado por shell: os comandos vão um a um pelo driver mysql2.
const TABLES = ['fornecedor','departamento','funcionario','cliente','marca','cor','tamanho','produto','produto_sku','venda','item_venda','pagamento','pedido_online','troca_devolucao','pedido_reposicao','item_reposicao','movimentacao_estoque','tabela_preco','item_tabela_preco','historico_preco','conta_a_pagar','usuario_sistema','log_auditoria','backup_sistema','registro_restauracao'];
// Tabelas de histórico: NUNCA são sobrescritas por uma restauração (preserva o registro de backups, restaurações e auditoria).
const LOGS = ['log_auditoria', 'backup_sistema', 'registro_restauracao'];

function splitSql(t) {
  const out = []; let cur = '', i = 0, q = null; const n = t.length;
  while (i < n) {
    const c = t[i], d = t[i + 1];
    if (q) {
      cur += c;
      if (c === '\\' && q !== '`') { cur += d ?? ''; i += 2; continue; }
      if (c === q) { if (d === q) { cur += d; i += 2; continue; } q = null; }
      i++; continue;
    }
    if (c === "'" || c === '"' || c === '`') { q = c; cur += c; i++; continue; }
    if ((c === '-' && d === '-' && /\s/.test(t[i + 2] || ' ')) || c === '#') { while (i < n && t[i] !== '\n') i++; continue; }
    if (c === '/' && d === '*') { const e = t.indexOf('*/', i + 2); if (e < 0) throw new Error('Comentário /* */ não finalizado'); i = e + 2; continue; }
    if (c === ';') { if (cur.trim()) out.push(cur.trim()); cur = ''; i++; continue; }
    cur += c; i++;
  }
  if (q) throw new Error('Texto entre aspas não finalizado');
  if (cur.trim()) out.push(cur.trim());
  return out;
}
const bare = s => s.replace(/'(?:[^'\\]|\\[\s\S]|'')*'/g, "''").replace(/"(?:[^"\\]|\\[\s\S])*"/g, '""');
const BAD = /\b(SELECT|LOAD_FILE|OUTFILE|DUMPFILE|SLEEP|BENCHMARK|LOAD\s+DATA)\b/i;

function classify(s) {
  const st = s.replace(/\s+/g, ' '); let m;
  const tbl = (k, name) => {
    const t = name.toLowerCase();
    if (!TABLES.includes(t)) throw new Error('Tabela não reconhecida no db_ansarah: ' + name);
    if ((k === 'insert' || k === 'create') && BAD.test(bare(s))) throw new Error('Comando não permitido dentro de ' + k.toUpperCase() + ' (' + name + ')');
    return { k, t, skip: LOGS.includes(t), s };
  };
  if (/^SET (FOREIGN_KEY_CHECKS|UNIQUE_CHECKS|SQL_MODE|NAMES|TIME_ZONE|CHARACTER_SET_CLIENT)\b/i.test(st) && !/select/i.test(st)) return { k: 'ignorar', s };
  if (/^(LOCK TABLES|UNLOCK TABLES)\b/i.test(st)) return { k: 'ignorar', s };
  if ((m = st.match(/^DROP TABLE IF EXISTS `?(\w+)`?$/i))) return tbl('drop', m[1]);
  if ((m = st.match(/^CREATE TABLE (?:IF NOT EXISTS )?`?(\w+)`? ?\(/i))) return tbl('create', m[1]);
  if ((m = st.match(/^INSERT INTO `?(\w+)`? ?(\([^)]*\))? ?VALUES\b/i))) return tbl('insert', m[1]);
  throw new Error('Comando não permitido: "' + st.slice(0, 70) + '"');
}
function analyze(text) {
  if (typeof text !== 'string' || !text.trim()) throw new Error('Arquivo vazio');
  if (text.includes('\u0000')) throw new Error('O arquivo contém bytes binários, não é um .sql de texto');
  const stmts = splitSql(text).map(classify), r = { criar: 0, inserir: 0, descartar: 0, preservadas: new Set(), tabelas: new Set() };
  stmts.forEach(x => { if (x.k === 'ignorar') return; r.tabelas.add(x.t); if (x.skip) { r.preservadas.add(x.t); return; } if (x.k === 'create') r.criar++; if (x.k === 'insert') r.inserir++; if (x.k === 'drop') r.descartar++; });
  if (!r.criar && !r.inserir) throw new Error('Nenhuma tabela do db_ansarah encontrada para restaurar');
  return { stmts, resumo: { criar: r.criar, inserir: r.inserir, descartar: r.descartar, tabelas: r.tabelas.size, preservadas: [...r.preservadas] } };
}
module.exports = { splitSql, classify, analyze, TABLES, LOGS };
