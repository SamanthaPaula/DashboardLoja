# ANSARAH | Dashboard Gerencial com MySQL

Painel ligado ao banco `db_ansarah` com sincronização nos dois sentidos (consulta o MySQL a cada 4 s; formulários gravam no MySQL e geram registro em `LOG_AUDITORIA`).

## Como rodar
1. Execute o `ScriptSQLCompleto-ANSARAH.sql` no MySQL Workbench.
2. Node.js 18+. Copie `.env.example` para `.env` e ajuste `DB_USER` e `DB_PASSWORD`.
3. `npm install` e `npm start` → http://localhost:3000

## Produtos (menu Produtos)
Cadastrar, **Editar** e **Excluir**. Produto que já tem SKU não pode ser excluído (o painel avisa). Tudo é gravado em `Produto` e registrado na auditoria.

## Backups e restaurações (menu Auditoria)
- **Exportar banco de dados:** gera um `.sql` real (estrutura + dados de todas as tabelas) em `storage/backups/` (pasta fora de `public`, sem acesso por URL), baixa o arquivo e registra em `BACKUP_SISTEMA`. O status só vira "Concluido" se o arquivo foi gravado e está íntegro; caso contrário fica "Falhou".
- **Restaurar backup:** escolher `.sql` → **Validar** (só aceita DROP/CREATE TABLE e INSERT das 25 tabelas do projeto; rejeita DROP DATABASE, USE, GRANT, SELECT, LOAD_FILE etc.) → informar o motivo → digitar o nome do banco → confirmar.
  Antes de executar, o sistema gera um **backup de segurança**. Se a restauração falhar, o banco é **revertido automaticamente** a esse backup. Tudo fica em `REGISTRO_RESTAURACAO` e `LOG_AUDITORIA`.
- As tabelas `BACKUP_SISTEMA`, `REGISTRO_RESTAURACAO` e `LOG_AUDITORIA` **não são sobrescritas** na restauração, então o histórico não se perde (era o problema P1).
- Use arquivos gerados pelo botão de exportação. O script original (`ScriptSQLCompleto`) é rejeitado de propósito, pois tem `CREATE DATABASE`/`USE`/`SELECT`.

## Testando em banco de teste (preserva o original)
1. No Workbench, abra o script, troque `db_ansarah` por `db_ansarah_teste` (Ctrl+H) e execute.
2. No `.env`: `DB_NAME=db_ansarah_teste`, reinicie com `npm start`.
3. A restauração **só é liberada** quando o nome do banco contém "teste", "test" ou "homolog" (ou `ALLOW_RESTORE_ANY=true`).
4. Roteiro de validação: Exportar → alterar/excluir dados → Restaurar o arquivo exportado → conferir que os dados voltaram e que o histórico continua.

## Segurança
O servidor escuta só em `127.0.0.1`; usuário/senha do MySQL ficam só no `.env`; o upload nunca é executado por shell (cada comando validado vai ao driver, um por vez, sem multi-statement). **Não há login:** não exponha o servidor na rede.

## Premissas
Categoria = `grupo_produto`; `desconto_venda` em R$; cadastro incompleto = sem descrição/referência/NCM (produto) ou sem cor/tamanho/peso (SKU). Arquivo enviado na restauração é registrado em `BACKUP_SISTEMA` (tipo "Completo", local em `storage/uploads/`).
