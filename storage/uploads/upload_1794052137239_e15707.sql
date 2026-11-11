-- ANSARAH | dump do banco db_ansarah_teste
-- Gerado em: 2026-11-07 08:48:44
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `backup_sistema`;
CREATE TABLE `backup_sistema` (
  `id_backup` int NOT NULL AUTO_INCREMENT,
  `tipo_backup` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_inicio_backup` datetime NOT NULL,
  `data_fim_backup` datetime DEFAULT NULL,
  `local_armazenamento` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_backup` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tamanho_backup_bytes` bigint unsigned DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_backup`),
  KEY `fk_backup_usuario` (`id_usuario`),
  CONSTRAINT `fk_backup_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario_sistema` (`id_usuario`),
  CONSTRAINT `chk_backup_periodo` CHECK (((`data_fim_backup` is null) or (`data_fim_backup` >= `data_inicio_backup`)))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `backup_sistema` (`id_backup`,`tipo_backup`,`data_inicio_backup`,`data_fim_backup`,`local_armazenamento`,`status_backup`,`tamanho_backup_bytes`,`id_usuario`) VALUES
(1,'Completo','2026-11-01 23:00:00','2026-11-01 23:04:00','D:/Backups/Ansarah/backup_2026-11-01.sql','Concluido',52428800,NULL),
(2,'Completo','2026-11-02 23:00:00','2026-11-02 23:03:00','D:/Backups/Ansarah/backup_2026-11-02.sql','Concluido',52971520,1),
(3,'Completo','2026-11-03 23:00:00',NULL,'D:/Backups/Ansarah/backup_2026-11-03.sql','Falhou',NULL,NULL),
(4,'Incremental','2026-11-04 23:00:00','2026-11-04 23:01:30','D:/Backups/Ansarah/backup_2026-11-04_incremental.sql','Concluido',10485760,2),
(5,'Completo','2026-11-05 23:00:00','2026-11-05 23:05:00','D:/Backups/Ansarah/backup_2026-11-05.sql','Concluido',54525952,1),
(6,'Incremental','2026-11-06 23:00:00','2026-11-06 23:02:00','D:/Backups/Ansarah/backup_2026-11-06_incremental.sql','Concluido',12582912,3),
(7,'Completo','2026-11-07 23:00:00',NULL,'D:/Backups/Ansarah/backup_2026-11-07.sql','Falhou',NULL,2),
(8,'Completo','2026-11-08 23:00:00','2026-11-08 23:06:00','D:/Backups/Ansarah/backup_2026-11-08.sql','Concluido',57671680,4),
(9,'Incremental','2026-11-09 23:00:00','2026-11-09 23:02:00','D:/Backups/Ansarah/backup_2026-11-09_incremental.sql','Concluido',15728640,6),
(10,'Completo','2026-11-10 23:00:00','2026-11-10 23:07:00','D:/Backups/Ansarah/backup_2026-11-10.sql','Concluido',62914560,7),
(11,'Completo','2026-11-07 02:36:28','2026-11-07 02:36:28','C:/Users/saman/Downloads/ansarah-dashboard-mysql/storage/backups/backup_completo_db_ansarah_teste_20261107023628.sql','Concluido',50092,1),
(12,'Completo','2026-11-07 02:40:05','2026-11-07 02:40:05','C:/Users/saman/Downloads/ansarah-dashboard-mysql/storage/backups/backup_seguranca_db_ansarah_teste_20261107024005.sql','Concluido',50520,1),
(13,'Completo','2026-11-07 02:40:05','2026-11-07 02:40:05','C:/Users/saman/Downloads/ansarah-dashboard-mysql/storage/uploads/upload_1794029985703_6a268f.sql','Concluido',50092,1);

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome_completo` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_cliente` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpf_cliente` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cnpj_cliente` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_cliente` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefone_cliente` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endereco_cliente` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uq_cliente_cpf` (`cpf_cliente`),
  UNIQUE KEY `uq_cliente_cnpj` (`cnpj_cliente`),
  CONSTRAINT `chk_cliente_tipo` CHECK ((`tipo_cliente` in (_utf8mb4'B2C',_utf8mb4'B2B')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `cliente` (`id_cliente`,`nome_completo`,`tipo_cliente`,`cpf_cliente`,`cnpj_cliente`,`email_cliente`,`telefone_cliente`,`endereco_cliente`) VALUES
(1,'Mariana Oliveira Costa','B2C','48392017605',NULL,'mariana.costa@example.com','11987654321','Rua Harmonia, 215, Vila Madalena, São Paulo - SP'),
(2,'Rafael Mendes Ferreira','B2C','52718493062',NULL,'rafael.ferreira@example.com','11976543210','Rua dos Pinheiros, 840, Pinheiros, São Paulo - SP'),
(3,'Camila Rodrigues Alves','B2C','61483920571',NULL,'camila.alves@example.com','11965432109','Av. Jabaquara, 1420, Saúde, São Paulo - SP'),
(4,'Estilo Urbano Comércio de Roupas Ltda.','B2B',NULL,'48372615000190','compras@estilourbano.example','1132456789','Rua Silva Teles, 380, Brás, São Paulo - SP'),
(5,'Bella Forma Moda Fitness Ltda.','B2B',NULL,'57294163000108','pedidos@bellaforma.example','1134567890','Rua Oriente, 615, Brás, São Paulo - SP'),
(6,'Juliana Martins Ribeiro','B2C','39581726409',NULL,'juliana.ribeiro@example.com','11954321098','Rua Vergueiro, 2210, Vila Mariana, São Paulo - SP'),
(7,'Beatriz Almeida Santos','B2C','72849163520',NULL,'beatriz.santos@example.com','11981234567','Rua Augusta, 520, Consolação, São Paulo - SP'),
(8,'Gabriel Henrique Lima','B2C','83915274601',NULL,'gabriel.lima@example.com','11982345678','Rua Tuiuti, 780, Tatuapé, São Paulo - SP'),
(9,'Moda Ativa Comércio Ltda.','B2B',NULL,'68429173000156','compras@modaativa.example','1134567891','Rua Maria Marcolina, 420, Brás, São Paulo - SP'),
(10,'Corpo em Movimento Fitness Ltda.','B2B',NULL,'79531284000197','pedidos@corpoemmovimento.example','1135678902','Rua Miller, 390, Brás, São Paulo - SP');

DROP TABLE IF EXISTS `conta_a_pagar`;
CREATE TABLE `conta_a_pagar` (
  `id_conta_pagar` int NOT NULL AUTO_INCREMENT,
  `numero_documento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_emissao` date NOT NULL,
  `data_vencimento` date NOT NULL,
  `data_pagamento` date DEFAULT NULL,
  `valor_total` float NOT NULL,
  `status_conta` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_cadastro` date NOT NULL,
  `id_reposicao` int NOT NULL,
  PRIMARY KEY (`id_conta_pagar`),
  KEY `fk_conta_reposicao` (`id_reposicao`),
  CONSTRAINT `fk_conta_reposicao` FOREIGN KEY (`id_reposicao`) REFERENCES `pedido_reposicao` (`id_reposicao`),
  CONSTRAINT `chk_conta_valor` CHECK ((`valor_total` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `conta_a_pagar` (`id_conta_pagar`,`numero_documento`,`data_emissao`,`data_vencimento`,`data_pagamento`,`valor_total`,`status_conta`,`data_cadastro`,`id_reposicao`) VALUES
(1,'NF-HT-2026-1048','2026-10-15','2026-10-25','2026-10-24',1860,'Paga','2026-10-15',1),
(2,'NF-ES-2026-2281','2026-10-24','2026-11-10',NULL,1420,'Em aberto','2026-10-24',2),
(3,'PED-VS-2026-0917','2026-10-30','2026-11-15',NULL,980,'Em aberto','2026-10-30',3),
(4,'NF-PR-2026-004','2026-11-01','2026-11-15','2026-11-14',960,'Paga','2026-11-01',4),
(5,'NF-PR-2026-005','2026-11-02','2026-11-16','2026-11-15',720,'Paga','2026-11-02',5),
(6,'NF-PR-2026-006','2026-11-03','2026-11-17','2026-11-16',660,'Paga','2026-11-03',6),
(7,'NF-PR-2026-007','2026-11-04','2026-11-18','2026-11-17',840,'Paga','2026-11-04',7),
(8,'NF-PR-2026-008','2026-11-05','2026-11-19',NULL,1150,'Em aberto','2026-11-05',8),
(9,'NF-PR-2026-009','2026-11-06','2026-11-20',NULL,920,'Em aberto','2026-11-06',9),
(10,'NF-PR-2026-010','2026-11-07','2026-11-21',NULL,480,'Em aberto','2026-11-07',10);

DROP TABLE IF EXISTS `cor`;
CREATE TABLE `cor` (
  `id_cor` int NOT NULL AUTO_INCREMENT,
  `nome_cor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hexadecimal` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_cor`),
  UNIQUE KEY `uq_cor_nome` (`nome_cor`),
  CONSTRAINT `chk_cor_hex` CHECK (regexp_like(`hexadecimal`,_utf8mb4'^#[0-9A-Fa-f]{6}$'))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `cor` (`id_cor`,`nome_cor`,`hexadecimal`) VALUES
(1,'Preto','#000000'),
(2,'Branco','#FFFFFF'),
(3,'Azul-marinho','#172A4A'),
(4,'Rosa-claro','#F2B8C6'),
(5,'Vinho','#722F37'),
(6,'Verde-oliva','#708238'),
(7,'Cinza-mescla','#B8B8B8'),
(8,'Bege','#D8C3A5'),
(9,'Lilás','#C8A2C8'),
(10,'Vermelho','#FF0000');

DROP TABLE IF EXISTS `departamento`;
CREATE TABLE `departamento` (
  `id_departamento` int NOT NULL AUTO_INCREMENT,
  `nome_departamento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_departamento`),
  UNIQUE KEY `uq_departamento_nome` (`nome_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `departamento` (`id_departamento`,`nome_departamento`) VALUES
(5,'Compras'),
(9,'Controle de Qualidade'),
(8,'E-commerce'),
(2,'Estoque e Logística'),
(10,'Expedição'),
(3,'Financeiro'),
(6,'Marketing'),
(7,'Recursos Humanos'),
(4,'Tecnologia da Informação'),
(1,'Vendas e Atendimento');

DROP TABLE IF EXISTS `fornecedor`;
CREATE TABLE `fornecedor` (
  `id_fornecedor` int NOT NULL AUTO_INCREMENT,
  `nome_fornecedor` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `razao_social_fornecedor` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cnpj_fornecedor` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `inscricao_estadual_fornecedor` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefone_fornecedor` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_fornecedor` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endereco_fornecedor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_fornecedor` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_cadastro_fornecedor` date NOT NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE KEY `uq_fornecedor_cnpj` (`cnpj_fornecedor`),
  CONSTRAINT `chk_fornecedor_status` CHECK ((`status_fornecedor` in (_utf8mb4'Ativo',_utf8mb4'Inativo',_utf8mb4'Bloqueado')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `fornecedor` (`id_fornecedor`,`nome_fornecedor`,`razao_social_fornecedor`,`cnpj_fornecedor`,`inscricao_estadual_fornecedor`,`telefone_fornecedor`,`email_fornecedor`,`endereco_fornecedor`,`status_fornecedor`,`data_cadastro_fornecedor`) VALUES
(1,'Malharia Horizonte','Horizonte Indústria Têxtil Ltda.','28471635000142','114.829.330.118','1133224455','vendas@horizonte.example','Rua da Mooca, 1250, Mooca, São Paulo - SP','Ativo','2024-02-15'),
(2,'Tecidos Vale Sul','Vale Sul Tecidos e Aviamentos Ltda.','39625184000176','208.551.420.110','1932345678','comercial@valesul.example','Av. das Indústrias, 420, Americana - SP','Ativo','2023-11-08'),
(3,'Confecções Estrela do Sul','Estrela do Sul Confecções Ltda.','51739462000105','908.173.622.114','4733456789','pedidos@estreladosul.example','Rua Blumenau, 770, Joinville - SC','Ativo','2024-06-20'),
(4,'Embalagens Nova Era','Nova Era Embalagens Ltda.','16283745000163','147.258.369.110','1144556677','atendimento@novaera.example','Rua do Gasômetro, 510, Brás, São Paulo - SP','Ativo','2025-01-10'),
(5,'Malhas Primavera','Primavera Indústria de Malhas Ltda.','62847135000120','123.456.789.110','1133556677','vendas@primavera.example','Rua Miller, 250, Brás, São Paulo - SP','Ativo','2024-08-12'),
(6,'Têxtil Santa Catarina','Santa Catarina Têxtil Ltda.','73915284000161','234.567.890.121','4733221100','comercial@santacatarina.example','Rua das Fábricas, 180, Blumenau - SC','Ativo','2024-09-20'),
(7,'Confecções Bela Vista','Bela Vista Confecções Ltda.','84126395000102','345.678.901.132','1133445566','pedidos@belavista.example','Rua Bresser, 640, Brás, São Paulo - SP','Ativo','2025-02-14'),
(8,'Aviamentos Central','Central de Aviamentos Ltda.','95237416000143','456.789.012.143','1133667788','atendimento@aviamentoscentral.example','Rua Joli, 320, Brás, São Paulo - SP','Ativo','2025-03-05'),
(9,'Malharia Dois Irmãos','Dois Irmãos Malharia Ltda.','16348527000184','567.890.123.154','1933557799','vendas@doisirmaos.example','Av. Brasil, 900, Americana - SP','Ativo','2025-04-18'),
(10,'Têxtil Nova Estação','Nova Estação Têxtil Ltda.','27459638000125','678.901.234.165','1133778899','comercial@novaestacao.example','Rua Oriente, 880, Brás, São Paulo - SP','Ativo','2025-05-22');

DROP TABLE IF EXISTS `funcionario`;
CREATE TABLE `funcionario` (
  `id_funcionario` int NOT NULL AUTO_INCREMENT,
  `nome_funcionario` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cargo_funcionario` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_departamento` int NOT NULL,
  PRIMARY KEY (`id_funcionario`),
  KEY `fk_funcionario_departamento` (`id_departamento`),
  CONSTRAINT `fk_funcionario_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `funcionario` (`id_funcionario`,`nome_funcionario`,`cargo_funcionario`,`id_departamento`) VALUES
(1,'Fernanda Lima Carvalho','Supervisora de Vendas',1),
(2,'Diego Almeida Santos','Assistente de Estoque',2),
(3,'Patrícia Nunes Ribeiro','Analista Financeira',3),
(4,'Lucas Barros Mendes','Analista de Sistemas',4),
(5,'Renata Souza Martins','Analista de Compras',5),
(6,'Bruno Teixeira Costa','Vendedor',1),
(7,'Gabriela Ferreira Lopes','Analista de Marketing',6),
(8,'André Luiz Moreira','Assistente de Recursos Humanos',7),
(9,'Isabela Costa Almeida','Assistente de E-commerce',8),
(10,'Marcelo Ribeiro Santos','Conferente de Qualidade',9);

DROP TABLE IF EXISTS `historico_preco`;
CREATE TABLE `historico_preco` (
  `id_historico_preco` int NOT NULL AUTO_INCREMENT,
  `preco_anterior` float NOT NULL,
  `preco_novo` float NOT NULL,
  `preco_compra_reposicao` float NOT NULL,
  `data_inicio_preco` date NOT NULL,
  `data_alteracao_preco` datetime NOT NULL,
  `data_fim_preco` date DEFAULT NULL,
  `id_sku` int NOT NULL,
  `id_tabela_preco` int NOT NULL,
  PRIMARY KEY (`id_historico_preco`),
  KEY `fk_historico_preco_sku` (`id_sku`),
  KEY `fk_historico_preco_tabela` (`id_tabela_preco`),
  CONSTRAINT `fk_historico_preco_sku` FOREIGN KEY (`id_sku`) REFERENCES `produto_sku` (`id_sku`),
  CONSTRAINT `fk_historico_preco_tabela` FOREIGN KEY (`id_tabela_preco`) REFERENCES `tabela_preco` (`id_tabela_preco`),
  CONSTRAINT `chk_historico_preco` CHECK (((`preco_anterior` >= 0) and (`preco_novo` >= 0) and (`preco_compra_reposicao` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `historico_preco` (`id_historico_preco`,`preco_anterior`,`preco_novo`,`preco_compra_reposicao`,`data_inicio_preco`,`data_alteracao_preco`,`data_fim_preco`,`id_sku`,`id_tabela_preco`) VALUES
(1,119.9,129.9,48,'2026-01-01','2026-08-15 00:00:00','2026-08-14',2,1),
(2,74.9,84.9,31.5,'2026-01-01','2026-09-01 00:00:00','2026-08-31',4,1),
(3,84.9,89.9,36,'2026-01-01','2026-09-01 00:00:00','2026-08-31',10,2),
(4,109.9,119.9,44,'2026-01-01','2026-07-10 00:00:00','2026-07-09',12,1),
(5,54.9,59.9,23,'2026-01-01','2026-06-01 00:00:00','2026-05-31',10,1),
(6,129.9,134.9,48,'2026-11-01','2026-11-05 00:00:00','2026-10-31',2,1),
(7,84.9,89.9,36,'2026-11-01','2026-11-05 00:00:00','2026-10-31',4,1),
(8,59.9,64.9,23,'2026-11-01','2026-11-05 00:00:00','2026-10-31',10,1),
(9,69.9,74.9,28,'2026-11-01','2026-11-05 00:00:00','2026-10-31',14,1),
(10,32.9,34.9,16.5,'2026-11-01','2026-11-05 00:00:00','2026-10-31',8,3);

DROP TABLE IF EXISTS `item_reposicao`;
CREATE TABLE `item_reposicao` (
  `id_item_reposicao` int NOT NULL AUTO_INCREMENT,
  `quantidade_solicitada` int NOT NULL,
  `quantidade_recebida` int NOT NULL DEFAULT '0',
  `preco_item_reposicao` float NOT NULL,
  `status_item_reposicao` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `desconto_item` float NOT NULL DEFAULT '0',
  `id_reposicao` int NOT NULL,
  `id_sku` int NOT NULL,
  PRIMARY KEY (`id_item_reposicao`),
  KEY `fk_item_reposicao_pedido` (`id_reposicao`),
  KEY `fk_item_reposicao_sku` (`id_sku`),
  CONSTRAINT `fk_item_reposicao_pedido` FOREIGN KEY (`id_reposicao`) REFERENCES `pedido_reposicao` (`id_reposicao`),
  CONSTRAINT `fk_item_reposicao_sku` FOREIGN KEY (`id_sku`) REFERENCES `produto_sku` (`id_sku`),
  CONSTRAINT `chk_item_reposicao_desconto` CHECK ((`desconto_item` >= 0)),
  CONSTRAINT `chk_item_reposicao_preco` CHECK ((`preco_item_reposicao` >= 0)),
  CONSTRAINT `chk_item_reposicao_qtd` CHECK (((`quantidade_solicitada` > 0) and (`quantidade_recebida` >= 0) and (`quantidade_recebida` <= `quantidade_solicitada`)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `item_reposicao` (`id_item_reposicao`,`quantidade_solicitada`,`quantidade_recebida`,`preco_item_reposicao`,`status_item_reposicao`,`desconto_item`,`id_reposicao`,`id_sku`) VALUES
(1,20,20,48,'Recebido',0,1,1),
(2,15,15,36,'Recebido',0,1,4),
(3,30,0,23,'Em trânsito',0,2,10),
(4,20,0,28,'Em trânsito',0,2,14),
(5,40,0,16.5,'Aguardando confirmação',0,3,8),
(6,20,0,29,'Aguardando confirmação',0,3,6),
(7,20,20,48,'Recebido',0,4,1),
(8,15,15,36,'Recebido',0,5,4),
(9,40,40,16.5,'Recebido',0,6,8),
(10,30,30,23,'Recebido',0,7,10);

DROP TABLE IF EXISTS `item_tabela_preco`;
CREATE TABLE `item_tabela_preco` (
  `id_item_tabela_preco` int NOT NULL AUTO_INCREMENT,
  `preco_unitario_venda` float NOT NULL,
  `data_inicio_vigencia` date NOT NULL,
  `data_fim_vigencia` date DEFAULT NULL,
  `id_tabela_preco` int NOT NULL,
  `id_sku` int NOT NULL,
  PRIMARY KEY (`id_item_tabela_preco`),
  KEY `fk_item_tabela_preco_tabela` (`id_tabela_preco`),
  KEY `fk_item_tabela_preco_sku` (`id_sku`),
  CONSTRAINT `fk_item_tabela_preco_sku` FOREIGN KEY (`id_sku`) REFERENCES `produto_sku` (`id_sku`),
  CONSTRAINT `fk_item_tabela_preco_tabela` FOREIGN KEY (`id_tabela_preco`) REFERENCES `tabela_preco` (`id_tabela_preco`),
  CONSTRAINT `chk_item_tabela_preco_valor` CHECK ((`preco_unitario_venda` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `item_tabela_preco` (`id_item_tabela_preco`,`preco_unitario_venda`,`data_inicio_vigencia`,`data_fim_vigencia`,`id_tabela_preco`,`id_sku`) VALUES
(1,139.9,'2026-01-01',NULL,1,1),
(2,129.9,'2026-01-01',NULL,1,2),
(3,84.9,'2026-01-01',NULL,1,4),
(4,89.9,'2026-09-01','2026-12-31',2,10),
(5,119.9,'2026-09-01','2026-12-31',2,12),
(6,64.9,'2026-01-01',NULL,3,1),
(7,39.9,'2026-01-01',NULL,3,4),
(8,27.9,'2026-01-01',NULL,3,8),
(9,59.9,'2026-01-01',NULL,1,10),
(10,69.9,'2026-01-01',NULL,1,14);

DROP TABLE IF EXISTS `item_venda`;
CREATE TABLE `item_venda` (
  `id_item_venda` int NOT NULL AUTO_INCREMENT,
  `quantidade_item_venda` int NOT NULL,
  `preco_unitario_venda` float NOT NULL,
  `id_sku` int NOT NULL,
  `id_venda` int NOT NULL,
  PRIMARY KEY (`id_item_venda`),
  KEY `fk_item_venda_sku` (`id_sku`),
  KEY `fk_item_venda_venda` (`id_venda`),
  CONSTRAINT `fk_item_venda_sku` FOREIGN KEY (`id_sku`) REFERENCES `produto_sku` (`id_sku`),
  CONSTRAINT `fk_item_venda_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`),
  CONSTRAINT `chk_item_venda_preco` CHECK ((`preco_unitario_venda` >= 0)),
  CONSTRAINT `chk_item_venda_qtd` CHECK ((`quantidade_item_venda` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `item_venda` (`id_item_venda`,`quantidade_item_venda`,`preco_unitario_venda`,`id_sku`,`id_venda`) VALUES
(1,1,129.9,2,1),
(2,1,79.9,4,1),
(3,2,89.9,10,2),
(4,1,119.9,12,2),
(5,12,64.9,1,3),
(6,12,39.9,4,3),
(7,1,54.9,6,4),
(8,2,32.9,8,5),
(9,1,69.9,14,5),
(10,20,59.9,10,6),
(11,15,29.9,8,6);

DROP TABLE IF EXISTS `log_auditoria`;
CREATE TABLE `log_auditoria` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `data_hora_log` datetime NOT NULL,
  `tipo_operacao` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidade_afetada` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao_operacao` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `justificativa_operacao` text COLLATE utf8mb4_unicode_ci,
  `id_registro_afetado` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_anterior` text COLLATE utf8mb4_unicode_ci,
  `valor_novo` text COLLATE utf8mb4_unicode_ci,
  `id_usuario` int NOT NULL,
  PRIMARY KEY (`id_log`),
  KEY `fk_log_usuario` (`id_usuario`),
  CONSTRAINT `fk_log_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario_sistema` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `log_auditoria` (`id_log`,`data_hora_log`,`tipo_operacao`,`entidade_afetada`,`descricao_operacao`,`justificativa_operacao`,`id_registro_afetado`,`valor_anterior`,`valor_novo`,`id_usuario`) VALUES
(1,'2026-10-28 10:25:10','INSERT','Venda','Registro de venda concluída no caixa.','Registrar a venda realizada para manter o histórico das operações comerciais.','1',NULL,'status_venda=Concluída; canal_venda=Loja física',1),
(2,'2026-10-29 09:20:12','UPDATE','Produto_SKU','Atualização da quantidade após recebimento de mercadoria.','Atualizar o saldo de estoque após a conferência e o recebimento dos produtos do fornecedor.','1','quantidade_estoque=22','quantidade_estoque=42',2),
(3,'2026-10-30 08:45:30','UPDATE','Produto_SKU','Ajuste de estoque após identificação de peças avariadas.','Corrigir a quantidade disponível após a identificação de peças danificadas durante a conferência do estoque.','13','quantidade_estoque=13','quantidade_estoque=11',2),
(4,'2026-11-01 17:22:05','INSERT','troca_devolucao','Abertura de solicitação de devolução de pedido online.','Registrar a solicitação de devolução realizada pelo cliente para iniciar o processo de análise e atendimento.','2',NULL,'status_ocorrencia=Aguardando postagem',1),
(5,'2026-11-02 09:14:40','UPDATE','tabela_preco','Revisão do preço de venda da legging preta tamanho M.','Atualizar o preço de venda conforme a revisão comercial dos valores praticados pela empresa.','2','preco_unitario_venda=119.90','preco_unitario_venda=129.90',4),
(6,'2026-11-03 10:00:00','INSERT','Cliente','Cadastro de novo cliente.','Registrar cliente para realizar compras na loja.','7',NULL,'nome_completo=Beatriz Almeida Santos',6),
(7,'2026-11-03 11:00:00','UPDATE','Produto_SKU','Atualização da quantidade em estoque.','Registrar movimentação de mercadorias recebidas.','1','quantidade_estoque=22','quantidade_estoque=42',7),
(8,'2026-11-04 09:00:00','INSERT','pedido_reposicao','Cadastro de pedido de reposição.','Registrar nova solicitação de mercadorias ao fornecedor.','8',NULL,'status_reposicao=Em trânsito',8),
(9,'2026-11-04 14:00:00','UPDATE','tabela_preco','Alteração de tabela comercial.','Atualizar os preços para a campanha promocional.','5','nome_tabela_preco=E-commerce Primavera 2026','nome_tabela_preco=E-commerce Black Friday 2026',9),
(10,'2026-11-05 10:00:00','INSERT','troca_devolucao','Registro de solicitação de troca.','Registrar solicitação para análise do setor responsável.','10',NULL,'status_ocorrencia=Em análise',10),
(11,'2026-11-07 02:36:28','BACKUP','BACKUP_SISTEMA','Exportação do banco de dados pelo painel.','Gerar cópia de segurança do banco.','11',NULL,'arquivo=backup_completo_db_ansarah_teste_20261107023628.sql; tamanho=50092',1),
(12,'2026-11-07 02:40:05','BACKUP','BACKUP_SISTEMA','Exportação do banco de dados pelo painel.','Gerar cópia de segurança do banco.','12',NULL,'arquivo=backup_seguranca_db_ansarah_teste_20261107024005.sql; tamanho=50520',1),
(13,'2026-11-07 02:40:07','RESTORE','REGISTRO_RESTAURACAO','Restauração do banco pelo painel.','TESTE','11',NULL,'status_restauracao=Concluida',1);

DROP TABLE IF EXISTS `marca`;
CREATE TABLE `marca` (
  `id_marca` int NOT NULL AUTO_INCREMENT,
  `nome_marca` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_marca`),
  UNIQUE KEY `uq_marca_nome` (`nome_marca`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `marca` (`id_marca`,`nome_marca`) VALUES
(9,'Adidas'),
(1,'Farm'),
(4,'Hering'),
(10,'Hope'),
(5,'Live!'),
(6,'Lupo'),
(2,'Nike'),
(8,'Puma'),
(7,'Track & Field'),
(3,'Vitta Move');

DROP TABLE IF EXISTS `movimentacao_estoque`;
CREATE TABLE `movimentacao_estoque` (
  `id_movimentacao` int NOT NULL AUTO_INCREMENT,
  `tipo_movimentacao` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantidade_movimentada` int NOT NULL,
  `data_movimentacao` datetime NOT NULL,
  `motivo_movimentacao` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `documento_referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observacao_movimentacao` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_atualizacao_estoque` datetime DEFAULT NULL,
  `id_sku` int NOT NULL,
  `id_item_reposicao` int DEFAULT NULL,
  `id_funcionario` int NOT NULL,
  PRIMARY KEY (`id_movimentacao`),
  KEY `fk_movimentacao_sku` (`id_sku`),
  KEY `fk_movimentacao_item_reposicao` (`id_item_reposicao`),
  KEY `fk_movimentacao_funcionario` (`id_funcionario`),
  CONSTRAINT `fk_movimentacao_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `fk_movimentacao_item_reposicao` FOREIGN KEY (`id_item_reposicao`) REFERENCES `item_reposicao` (`id_item_reposicao`),
  CONSTRAINT `fk_movimentacao_sku` FOREIGN KEY (`id_sku`) REFERENCES `produto_sku` (`id_sku`),
  CONSTRAINT `chk_movimentacao_qtd` CHECK ((`quantidade_movimentada` <> 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `movimentacao_estoque` (`id_movimentacao`,`tipo_movimentacao`,`quantidade_movimentada`,`data_movimentacao`,`motivo_movimentacao`,`documento_referencia`,`observacao_movimentacao`,`data_atualizacao_estoque`,`id_sku`,`id_item_reposicao`,`id_funcionario`) VALUES
(1,'Entrada',20,'2026-10-22 09:15:00','Recebimento de reposição do fornecedor','NF-HT-2026-1048','Conferência concluída sem divergências.','2026-10-22 09:20:00',1,1,2),
(2,'Entrada',15,'2026-10-22 09:30:00','Recebimento de reposição do fornecedor','NF-HT-2026-1048','Lote etiquetado e armazenado.','2026-10-22 09:35:00',4,2,2),
(3,'Saída',1,'2026-10-28 10:24:00','Venda realizada no caixa','VENDA-0001','Separação concluída no atendimento.','2026-10-28 10:25:00',2,NULL,1),
(4,'Saída',2,'2026-10-28 14:45:00','Venda online faturada','PEDIDO-0001','Itens embalados para expedição.','2026-10-28 14:50:00',10,NULL,2),
(5,'Ajuste',-2,'2026-10-30 08:40:00','Ajuste após inventário cíclico','INV-2026-1030','Duas unidades com avaria identificadas.','2026-10-30 08:45:00',13,NULL,2),
(6,'Saída',12,'2026-10-29 11:16:00','Venda para cliente atacadista','VENDA-0003','Separação em lote para cliente empresarial.','2026-10-29 11:25:00',1,NULL,2),
(7,'Entrada',20,'2026-11-08 09:00:00','Recebimento de reposição do fornecedor','NF-PR-2026-004','Mercadorias conferidas e armazenadas.','2026-11-08 09:10:00',1,7,2),
(8,'Entrada',15,'2026-11-09 09:30:00','Recebimento de reposição do fornecedor','NF-PR-2026-005','Lote recebido sem divergências.','2026-11-09 09:40:00',4,8,2),
(9,'Entrada',40,'2026-11-10 10:00:00','Recebimento de reposição do fornecedor','NF-PR-2026-006','Peças conferidas e encaminhadas ao estoque.','2026-11-10 10:15:00',8,9,7),
(10,'Entrada',30,'2026-11-11 08:45:00','Recebimento de reposição do fornecedor','NF-PR-2026-007','Entrada registrada após conferência.','2026-11-11 09:00:00',10,10,7);

DROP TABLE IF EXISTS `pagamento`;
CREATE TABLE `pagamento` (
  `id_pagamento` int NOT NULL AUTO_INCREMENT,
  `forma_pagamento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_pagamento` float NOT NULL,
  `status_pagamento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_pagamento` datetime DEFAULT NULL,
  `codigo_transacao` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_confirmacao` datetime DEFAULT NULL,
  `id_venda` int NOT NULL,
  PRIMARY KEY (`id_pagamento`),
  KEY `fk_pagamento_venda` (`id_venda`),
  CONSTRAINT `fk_pagamento_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`),
  CONSTRAINT `chk_pagamento_valor` CHECK ((`valor_pagamento` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `pagamento` (`id_pagamento`,`forma_pagamento`,`valor_pagamento`,`status_pagamento`,`data_pagamento`,`codigo_transacao`,`data_confirmacao`,`id_venda`) VALUES
(1,'Cartão de crédito',209.8,'Aprovado','2026-10-28 10:25:00','TXN-ANS-20261028-001','2026-10-28 10:25:05',1),
(2,'Pix',289.7,'Aprovado','2026-10-28 14:43:00','PIX-ANS-20261028-002','2026-10-28 14:43:08',2),
(3,'Transferência bancária',1257.6,'Aprovado','2026-10-29 11:20:00','TED-ANS-20261029-003','2026-10-29 11:24:30',3),
(4,'Pix',120.7,'Pendente',NULL,'PIX-ANS-20261030-004',NULL,4),
(5,'Cartão de débito',97.8,'Aprovado','2026-10-31 09:38:00','POS-ANS-20261031-005','2026-10-31 09:38:03',5),
(6,'Boleto bancário',1643.5,'Pendente',NULL,'BOL-ANS-20261101-006',NULL,6),
(7,'Pix',159.9,'Aprovado','2026-11-01 15:21:00','PIX-ANS-20261101-007','2026-11-01 15:21:05',7),
(8,'Cartão de crédito',219.9,'Aprovado','2026-11-02 10:13:00','CC-ANS-20261102-008','2026-11-02 10:13:08',8),
(9,'Pix',89.9,'Aprovado','2026-11-03 09:46:00','PIX-ANS-20261103-009','2026-11-03 09:46:04',9),
(10,'Transferência bancária',1240,'Aprovado','2026-11-02 14:52:00','TED-ANS-20261102-010','2026-11-02 14:55:00',10),
(11,'Cartão de crédito',189.9,'Pendente',NULL,'CC-ANS-20261104-011',NULL,11);

DROP TABLE IF EXISTS `pedido_online`;
CREATE TABLE `pedido_online` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `codigo_rastreamento_pedido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_envio_pedido` datetime DEFAULT NULL,
  `data_pedido` datetime NOT NULL,
  `status_pedido` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_pagamento_pedido` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_entrega_pedido` datetime DEFAULT NULL,
  `data_confirmacao` datetime DEFAULT NULL,
  `id_cliente` int NOT NULL,
  `id_venda` int NOT NULL,
  PRIMARY KEY (`id_pedido`),
  UNIQUE KEY `uq_pedido_venda` (`id_venda`),
  KEY `fk_pedido_cliente` (`id_cliente`),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_pedido_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `pedido_online` (`id_pedido`,`codigo_rastreamento_pedido`,`data_envio_pedido`,`data_pedido`,`status_pedido`,`status_pagamento_pedido`,`data_entrega_pedido`,`data_confirmacao`,`id_cliente`,`id_venda`) VALUES
(1,'BR549218736SP','2026-10-29 09:10:00','2026-10-28 14:42:00','Entregue','Aprovado','2026-10-31 15:32:00','2026-10-31 16:00:00',2,2),
(2,'BR628173945SP',NULL,'2026-10-30 16:08:00','Aguardando pagamento','Pendente',NULL,NULL,3,4),
(3,'BR731925846SP','2026-11-01 10:30:00','2026-10-30 11:25:00','Enviado','Aprovado',NULL,NULL,1,3),
(4,'BR846219573SP',NULL,'2026-10-31 15:40:00','Em separação','Aprovado',NULL,NULL,4,5),
(5,'BR925731684SP','2026-11-02 08:15:00','2026-11-01 13:20:00','Enviado','Aprovado',NULL,NULL,5,6),
(6,'BR193847562SP','2026-11-02 14:00:00','2026-11-01 17:35:00','Enviado','Aprovado',NULL,NULL,6,7),
(7,'BR284619375SP',NULL,'2026-11-02 10:12:00','Aguardando pagamento','Pendente',NULL,NULL,7,8),
(8,'BR375821946SP',NULL,'2026-11-03 09:45:00','Em separação','Aprovado',NULL,NULL,8,9),
(9,'BR461928357SP','2026-11-03 16:20:00','2026-11-02 14:50:00','Enviado','Aprovado',NULL,NULL,9,10),
(10,'BR572839164SP',NULL,'2026-11-04 11:30:00','Em separação','Aprovado',NULL,NULL,10,11);

DROP TABLE IF EXISTS `pedido_reposicao`;
CREATE TABLE `pedido_reposicao` (
  `id_reposicao` int NOT NULL AUTO_INCREMENT,
  `data_reposicao` date NOT NULL,
  `data_prevista_entrega` date DEFAULT NULL,
  `data_entrega_real` date DEFAULT NULL,
  `status_reposicao` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacao_reposicao` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_total_reposicao` float NOT NULL,
  `id_fornecedor` int NOT NULL,
  PRIMARY KEY (`id_reposicao`),
  KEY `fk_reposicao_fornecedor` (`id_fornecedor`),
  CONSTRAINT `fk_reposicao_fornecedor` FOREIGN KEY (`id_fornecedor`) REFERENCES `fornecedor` (`id_fornecedor`),
  CONSTRAINT `chk_reposicao_valor` CHECK ((`valor_total_reposicao` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `pedido_reposicao` (`id_reposicao`,`data_reposicao`,`data_prevista_entrega`,`data_entrega_real`,`status_reposicao`,`observacao_reposicao`,`valor_total_reposicao`,`id_fornecedor`) VALUES
(1,'2026-10-15','2026-10-22','2026-10-22','Recebido','Reposição de leggings e tops para coleção Performance.',1860,1),
(2,'2026-10-24','2026-11-05',NULL,'Em trânsito','Lote de camisetas básicas e blusas caneladas.',1420,3),
(3,'2026-10-30','2026-11-08',NULL,'Aguardando confirmação','Reposição de peças íntimas em microfibra e algodão.',980,2),
(4,'2026-11-01','2026-11-08','2026-11-08','Recebido','Reposição de leggings para o estoque de varejo.',960,5),
(5,'2026-11-02','2026-11-09','2026-11-09','Recebido','Compra de tops esportivos para a coleção Performance.',720,6),
(6,'2026-11-03','2026-11-10','2026-11-10','Recebido','Reposição de peças de moda íntima.',660,7),
(7,'2026-11-04','2026-11-11','2026-11-11','Recebido','Reposição de camisetas básicas.',840,8),
(8,'2026-11-05','2026-11-12',NULL,'Em trânsito','Compra de tecidos para novas peças.',1150,9),
(9,'2026-11-06','2026-11-13',NULL,'Aguardando confirmação','Reposição de blusas e calças.',920,10),
(10,'2026-11-07','2026-11-14',NULL,'Aguardando confirmação','Compra de aviamentos para produção.',480,4);

DROP TABLE IF EXISTS `produto`;
CREATE TABLE `produto` (
  `id_produto` int NOT NULL AUTO_INCREMENT,
  `nome_produto` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_produto` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao_produto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia_produto` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_fiscal_produto` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_ncm` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `classificacao_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `colecao_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subcolecao_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grupo_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_produto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pais_origem_produto` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unidade_tributacao_produto` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_marca` int NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `uq_produto_codigo` (`codigo_produto`),
  KEY `fk_produto_marca` (`id_marca`),
  CONSTRAINT `fk_produto_marca` FOREIGN KEY (`id_marca`) REFERENCES `marca` (`id_marca`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `produto` (`id_produto`,`nome_produto`,`codigo_produto`,`descricao_produto`,`referencia_produto`,`codigo_fiscal_produto`,`codigo_ncm`,`classificacao_produto`,`colecao_produto`,`subcolecao_produto`,`grupo_produto`,`categoria_produto`,`tipo_produto`,`pais_origem_produto`,`unidade_tributacao_produto`,`id_marca`) VALUES
(1,'Legging Cintura Alta','LEG-001','Legging fitness de cintura alta','LA-001','789100000001','61046300','Vestuário feminino','Essencial 2026','Performance','Roupas fitness','Calças','Legging','Brasil','UN',1),
(2,'Top Esportivo','TOP-014','Top esportivo de sustentação média','TA-014','789100000014','62121000','Vestuário feminino','Essencial 2026','Performance','Roupas fitness','Tops','Top esportivo','Brasil','UN',1),
(3,'Sutiã Microfibra','SUT-022','Sutiã sem aro em microfibra','LI-022','789100000022','62121000','Moda íntima','Conforto Diário','Microfibra','Moda íntima','Sutiãs','Sutiã','Brasil','UN',2),
(4,'Calcinha Biquíni','CAL-008','Calcinha biquíni em algodão','LI-008','789100000008','61082100','Moda íntima','Conforto Diário','Algodão','Moda íntima','Calcinhas','Biquíni','Brasil','UN',2),
(5,'Camiseta Básica','CAM-031','Camiseta básica de algodão','VB-031','789100000031','61091000','Vestuário básico','Básicos Atemporais','Algodão','Roupas casuais','Camisetas','Camiseta','Brasil','UN',4),
(6,'Short Fitness','SHO-005','Short fitness com bolso lateral','VM-005','789100000005','61046300','Vestuário feminino','Movimento 2026','Treino','Roupas fitness','Shorts','Short esportivo','Brasil','UN',3),
(7,'Blusa Canelada','BLU-012','Blusa canelada de manga curta','VB-012','789100000012','61061000','Vestuário feminino','Básicos Atemporais','Canelados','Roupas casuais','Blusas','Blusa','Brasil','UN',4),
(8,'Jaqueta Fitness','JAQ-018','Jaqueta esportiva leve para atividades físicas.','JF-018','789100000018','61023000','Vestuário feminino','Movimento 2026','Academia','Roupas fitness','Jaquetas','Jaqueta esportiva','Brasil','UN',5),
(9,'Body Microfibra','BOD-025','Body feminino confeccionado em microfibra.','BM-025','789100000025','62121000','Moda íntima','Conforto Diário','Microfibra','Moda íntima','Bodies','Body','Brasil','UN',6),
(10,'Calça Jogger','CAL-042','Calça jogger feminina com cós elástico.','CJ-042','789100000042','61046300','Vestuário feminino','Essencial 2026','Casual','Roupas casuais','Calças','Jogger','Brasil','UN',7),
(11,'Regata Fitness','REG-011','','RF-011','789100000011','61099000','Vestuário feminino','Movimento 2026','Treino','Roupas fitness','Regatas','Regata','Brasil','UN',3);

DROP TABLE IF EXISTS `produto_sku`;
CREATE TABLE `produto_sku` (
  `id_sku` int NOT NULL AUTO_INCREMENT,
  `codigo_sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `altura` float DEFAULT NULL,
  `peso` float DEFAULT NULL,
  `comprimento` float DEFAULT NULL,
  `quantidade_estoque` int DEFAULT NULL,
  `id_cor` int DEFAULT NULL,
  `id_tamanho` int DEFAULT NULL,
  `id_produto` int NOT NULL,
  PRIMARY KEY (`id_sku`),
  UNIQUE KEY `codigo_sku` (`codigo_sku`),
  KEY `fk_sku_cor` (`id_cor`),
  KEY `fk_sku_tamanho` (`id_tamanho`),
  KEY `fk_sku_produto` (`id_produto`),
  CONSTRAINT `fk_sku_cor` FOREIGN KEY (`id_cor`) REFERENCES `cor` (`id_cor`),
  CONSTRAINT `fk_sku_produto` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  CONSTRAINT `fk_sku_tamanho` FOREIGN KEY (`id_tamanho`) REFERENCES `tamanho` (`id_tamanho`),
  CONSTRAINT `chk_sku_dimensoes` CHECK ((((`altura` is null) or (`altura` >= 0)) and ((`peso` is null) or (`peso` >= 0)) and ((`comprimento` is null) or (`comprimento` >= 0)))),
  CONSTRAINT `chk_sku_estoque` CHECK (((`quantidade_estoque` is null) or (`quantidade_estoque` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `produto_sku` (`id_sku`,`codigo_sku`,`altura`,`peso`,`comprimento`,`quantidade_estoque`,`id_cor`,`id_tamanho`,`id_produto`) VALUES
(1,'LEG001-PRE-P',2,0.24,28,42,1,2,1),
(2,'LEG001-PRE-M',2,0.255,30,35,1,3,1),
(3,'LEG001-VIN-G',2,0.27,32,18,5,4,1),
(4,'TOP014-PRE-M',2,0.12,20,27,1,3,2),
(5,'TOP014-RCL-P',2,0.115,19,16,4,2,2),
(6,'SUT022-BRA-M',2,0.09,18,31,2,3,3),
(7,'SUT022-PRE-G',2,0.095,20,14,1,4,3),
(8,'CAL008-BRA-M',1.5,0.055,15,60,2,3,4),
(9,'CAL008-PRE-G',1.5,0.06,16,44,1,4,4),
(10,'CAM031-BRA-M',2.5,0.18,27,50,2,3,5),
(11,'CAM031-CNZ-G',2.5,0.19,29,22,7,4,5),
(12,'SHO005-OLI-M',2,0.21,25,19,6,3,6),
(13,'SHO005-PRE-G',2,0.225,27,11,1,4,6),
(14,'BLU012-BEG-P',2,0.16,24,25,8,2,7),
(15,'BLU012-AZM-M',2,0.17,26,17,3,3,7),
(16,'ANS-001-AZ-P',2,0.2,20,15,1,1,1),
(17,'ANS-001-PT-M',2,0.2,20,0,2,2,1);

DROP TABLE IF EXISTS `registro_restauracao`;
CREATE TABLE `registro_restauracao` (
  `id_restauracao` int NOT NULL AUTO_INCREMENT,
  `data_inicio_restauracao` datetime NOT NULL,
  `data_fim_restauracao` datetime DEFAULT NULL,
  `status_restauracao` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `motivo_restauracao` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacao_restauracao` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_backup` int NOT NULL,
  `id_usuario` int NOT NULL,
  PRIMARY KEY (`id_restauracao`),
  KEY `fk_restauracao_backup` (`id_backup`),
  KEY `fk_restauracao_usuario` (`id_usuario`),
  CONSTRAINT `fk_restauracao_backup` FOREIGN KEY (`id_backup`) REFERENCES `backup_sistema` (`id_backup`),
  CONSTRAINT `fk_restauracao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario_sistema` (`id_usuario`),
  CONSTRAINT `chk_restauracao_periodo` CHECK (((`data_fim_restauracao` is null) or (`data_fim_restauracao` >= `data_inicio_restauracao`)))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `registro_restauracao` (`id_restauracao`,`data_inicio_restauracao`,`data_fim_restauracao`,`status_restauracao`,`motivo_restauracao`,`observacao_restauracao`,`id_backup`,`id_usuario`) VALUES
(1,'2026-11-04 08:00:00','2026-11-04 08:15:00','Concluida','Teste de recuperacao do banco de dados','Restauracao simulada para demonstracao academica.',2,4),
(2,'2026-11-05 09:30:00','2026-11-05 09:45:00','Concluida','Recuperacao de dados de produtos','Recuperacao realizada para verificar a integridade dos registros de produtos.',1,1),
(3,'2026-11-06 14:00:00',NULL,'Falhou','Falha durante a recuperacao do banco','O arquivo de backup apresentou problemas durante a leitura.',3,2),
(4,'2026-11-07 10:00:00','2026-11-07 10:12:00','Concluida','Teste periodico de restauracao','Teste realizado para validar a disponibilidade e integridade do backup.',4,3),
(5,'2026-11-08 16:30:00','2026-11-08 16:50:00','Concluida','Recuperacao apos exclusao acidental','Dados recuperados utilizando uma copia de seguranca anterior.',5,4),
(6,'2026-11-09 08:00:00','2026-11-09 08:12:00','Concluida','Teste de recuperação de estoque','Restauração simulada para validar os dados de estoque.',6,6),
(7,'2026-11-09 14:00:00','2026-11-09 14:18:00','Concluida','Recuperação de informações comerciais','Dados comerciais recuperados para conferência.',7,7),
(8,'2026-11-10 09:00:00',NULL,'Falhou','Falha na leitura do arquivo','O processo foi interrompido durante a leitura do backup.',8,8),
(9,'2026-11-10 13:00:00','2026-11-10 13:15:00','Concluida','Teste de integridade do banco','Restauração concluída e dados conferidos.',9,9),
(10,'2026-11-10 16:00:00','2026-11-10 16:20:00','Concluida','Recuperação de dados de vendas','Dados de vendas recuperados com sucesso.',10,10),
(11,'2026-11-07 02:40:05','2026-11-07 02:40:07','Concluida','TESTE','66 comandos executados; histórico de backups/restaurações/auditoria preservado. Backup de segurança #12.',13,1);

DROP TABLE IF EXISTS `tabela_preco`;
CREATE TABLE `tabela_preco` (
  `id_tabela_preco` int NOT NULL AUTO_INCREMENT,
  `nome_tabela_preco` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_cliente_tabela_preco` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_inicio_tabela_preco` datetime NOT NULL,
  `data_fim_tabela_preco` datetime DEFAULT NULL,
  `canal_venda_tabela_preco` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tabela_preco`),
  CONSTRAINT `chk_tabela_preco_periodo` CHECK (((`data_fim_tabela_preco` is null) or (`data_fim_tabela_preco` >= `data_inicio_tabela_preco`)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `tabela_preco` (`id_tabela_preco`,`nome_tabela_preco`,`tipo_cliente_tabela_preco`,`data_inicio_tabela_preco`,`data_fim_tabela_preco`,`canal_venda_tabela_preco`) VALUES
(1,'Varejo Loja 2026','Pessoa Física','2026-01-01 00:00:00',NULL,'Loja física'),
(2,'E-commerce Primavera 2026','Pessoa Física','2026-09-01 00:00:00','2026-12-31 23:59:59','E-commerce'),
(3,'Atacado Parceiros 2026','Pessoa Jurídica','2026-01-01 00:00:00',NULL,'Atacado'),
(4,'Varejo Verão 2026','Pessoa Física','2026-11-01 00:00:00','2027-02-28 23:59:59','Loja física'),
(5,'E-commerce Black Friday 2026','Pessoa Física','2026-11-01 00:00:00','2026-11-30 23:59:59','E-commerce'),
(6,'Atacado Verão 2026','Pessoa Jurídica','2026-11-01 00:00:00','2027-02-28 23:59:59','Atacado'),
(7,'Varejo Básicos 2027','Pessoa Física','2027-01-01 00:00:00',NULL,'Loja física'),
(8,'E-commerce Básicos 2027','Pessoa Física','2027-01-01 00:00:00',NULL,'E-commerce'),
(9,'Atacado Parceiros 2027','Pessoa Jurídica','2027-01-01 00:00:00',NULL,'Atacado'),
(10,'Promoção Fitness 2026','Pessoa Física','2026-11-05 00:00:00','2026-12-31 23:59:59','E-commerce');

DROP TABLE IF EXISTS `tamanho`;
CREATE TABLE `tamanho` (
  `id_tamanho` int NOT NULL AUTO_INCREMENT,
  `sigla_tamanho` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tamanho`),
  UNIQUE KEY `uq_tamanho_sigla` (`sigla_tamanho`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `tamanho` (`id_tamanho`,`sigla_tamanho`) VALUES
(6,'36'),
(7,'38'),
(8,'40'),
(9,'42'),
(10,'44'),
(4,'G'),
(5,'GG'),
(3,'M'),
(2,'P'),
(1,'PP'),
(11,'Único');

DROP TABLE IF EXISTS `troca_devolucao`;
CREATE TABLE `troca_devolucao` (
  `id_ocorrencia` int NOT NULL AUTO_INCREMENT,
  `tipo_ocorrencia` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `motivo_ocorrencia` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_ocorrencia` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_solicitacao_ocorrencia` datetime NOT NULL,
  `valor_estorno_ocorrencia` float DEFAULT NULL,
  `id_pedido` int NOT NULL,
  PRIMARY KEY (`id_ocorrencia`),
  KEY `fk_troca_pedido` (`id_pedido`),
  CONSTRAINT `fk_troca_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedido_online` (`id_pedido`),
  CONSTRAINT `chk_estorno` CHECK (((`valor_estorno_ocorrencia` is null) or (`valor_estorno_ocorrencia` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `troca_devolucao` (`id_ocorrencia`,`tipo_ocorrencia`,`motivo_ocorrencia`,`status_ocorrencia`,`data_solicitacao_ocorrencia`,`valor_estorno_ocorrencia`,`id_pedido`) VALUES
(1,'Troca','Cliente solicitou tamanho maior; peça sem sinais de uso.','Em análise','2026-11-01 10:15:00',0,1),
(2,'Devolução','Pedido duplicado pelo cliente antes da confirmação do pagamento.','Aguardando postagem','2026-11-01 17:20:00',54.9,2),
(3,'Troca','Cliente desistiu da solicitação antes do envio do produto.','Cancelada','2026-11-05 14:30:00',0,1),
(4,'Troca','Cliente solicitou a troca por uma cor diferente.','Em análise','2026-11-02 10:00:00',0,3),
(5,'Devolução','Produto recebido com embalagem danificada.','Aguardando postagem','2026-11-02 14:30:00',89.9,4),
(6,'Troca','Cliente solicitou tamanho menor.','Concluída','2026-11-03 09:00:00',0,5),
(7,'Devolução','Cliente desistiu da compra dentro do prazo.','Em análise','2026-11-03 11:20:00',119.9,6),
(8,'Troca','Peça apresentou divergência de tamanho.','Em análise','2026-11-03 15:40:00',0,7),
(9,'Devolução','Cliente solicitou devolução por arrependimento.','Aguardando postagem','2026-11-04 10:15:00',69.9,8),
(10,'Troca','Cliente deseja substituir o produto por outro modelo.','Em análise','2026-11-04 13:30:00',0,9);

DROP TABLE IF EXISTS `usuario_sistema`;
CREATE TABLE `usuario_sistema` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `login_usuario` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `senha_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `perfil_acesso` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_usuario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_criacao` datetime NOT NULL,
  `ultimo_acesso` datetime DEFAULT NULL,
  `id_funcionario` int NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_login` (`login_usuario`),
  KEY `fk_usuario_funcionario` (`id_funcionario`),
  CONSTRAINT `fk_usuario_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `usuario_sistema` (`id_usuario`,`login_usuario`,`senha_hash`,`perfil_acesso`,`status_usuario`,`data_criacao`,`ultimo_acesso`,`id_funcionario`) VALUES
(1,'fernanda.carvalho','$2y$10$hashFicticioApenasParaTeste000000000000000000000','Gerente de vendas','Ativo','2025-03-10 09:00:00','2026-11-02 09:12:00',1),
(2,'diego.santos','$2y$10$hashFicticioApenasParaTeste111111111111111111111','Estoque','Ativo','2025-05-18 10:30:00','2026-11-02 08:45:00',2),
(3,'patricia.ribeiro','$2y$10$hashFicticioApenasParaTeste222222222222222222222','Financeiro','Ativo','2025-04-02 08:15:00','2026-11-01 16:20:00',3),
(4,'lucas.mendes','$2y$10$hashFicticioApenasParaTeste333333333333333333333','Administrador de TI','Ativo','2025-02-11 11:00:00','2026-11-02 10:05:00',4),
(5,'renata.martins','$2y$10$hashFicticioApenasParaTeste444444444444444444444','Compras','Ativo','2025-06-25 13:00:00','2026-10-31 14:30:00',5),
(6,'bruno.costa','$2y$10$hashFicticioTeste555555555555555555555','Vendas','Ativo','2025-07-10 09:00:00','2026-11-04 10:00:00',6),
(7,'gabriela.lopes','$2y$10$hashFicticioTeste666666666666666666666','Marketing','Ativo','2025-08-12 09:00:00','2026-11-04 11:00:00',7),
(8,'andre.moreira','$2y$10$hashFicticioTeste777777777777777777777','Recursos Humanos','Ativo','2025-09-15 09:00:00','2026-11-04 12:00:00',8),
(9,'isabela.almeida','$2y$10$hashFicticioTeste888888888888888888888','E-commerce','Ativo','2025-10-20 09:00:00','2026-11-04 13:00:00',9),
(10,'marcelo.santos','$2y$10$hashFicticioTeste999999999999999999999','Qualidade','Ativo','2025-11-25 09:00:00','2026-11-04 14:00:00',10);

DROP TABLE IF EXISTS `venda`;
CREATE TABLE `venda` (
  `id_venda` int NOT NULL AUTO_INCREMENT,
  `data_venda` datetime NOT NULL,
  `canal_venda` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `desconto_venda` float NOT NULL DEFAULT '0',
  `status_venda` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_cliente` int DEFAULT NULL,
  `id_funcionario` int DEFAULT NULL,
  PRIMARY KEY (`id_venda`),
  KEY `fk_venda_cliente` (`id_cliente`),
  KEY `fk_venda_funcionario` (`id_funcionario`),
  CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_venda_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `chk_venda_desconto` CHECK ((`desconto_venda` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `venda` (`id_venda`,`data_venda`,`canal_venda`,`desconto_venda`,`status_venda`,`id_cliente`,`id_funcionario`) VALUES
(1,'2026-10-28 10:24:00','Loja física',0,'Concluída',1,1),
(2,'2026-10-28 14:42:00','E-commerce',10,'Concluída',2,NULL),
(3,'2026-10-29 11:16:00','Atacado',35,'Concluída',4,6),
(4,'2026-10-30 16:08:00','E-commerce',0,'Aguardando pagamento',3,NULL),
(5,'2026-10-31 09:37:00','Loja física',5,'Concluída',6,1),
(6,'2026-11-01 13:51:00','Atacado',50,'Em separação',5,6),
(7,'2026-11-01 15:20:00','E-commerce',0,'Concluída',6,NULL),
(8,'2026-11-02 10:12:00','Loja física',5,'Concluída',7,7),
(9,'2026-11-03 09:45:00','E-commerce',0,'Em separação',8,NULL),
(10,'2026-11-02 14:50:00','Atacado',25,'Concluída',9,6),
(11,'2026-11-04 11:30:00','E-commerce',10,'Em separação',10,NULL),
(12,'2026-11-02 00:00:00','Loja Física',10,'Cancelada',2,1);

SET FOREIGN_KEY_CHECKS=1;
-- FIM DO DUMP
