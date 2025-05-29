create table diretor(
id_diretor int primary key,
nome varchar(100),
cargo_militar varchar(50),
telefone varchar(50)
);

create table professor(
id_professor int primary key,
nome varchar(100),
id_turma int,
id_diretor int,
foreign key (id_turma) references turma(id_turma),
foreign key (id_diretor) references diretor(id_diretor)



);

create table turma(
id_turma int primary key,
ano_escolar varchar(20)
);

create table responsavel(
id_responsavel int primary key,
parentesco varchar(20),
telefone varchar(50),
nome varchar(100)

);

create table nota(
id_nota int primary key,
valor int
);


create table clube(
nome varchar(20)
);

create table disciplina(
id_disciplina int primary key,
id_nota int,
nome varchar(20),
foreign key (id_nota) references nota(id_nota)
);
use colegiomilitar
-- 1. adicionar colunas de auditoria e status em todas as tabelas atuais
ALTER TABLE diretor
  ADD COLUMN email VARCHAR(100),
  ADD COLUMN criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ADD COLUMN ativo BOOLEAN DEFAULT TRUE;




ALTER TABLE clube
 
  ADD COLUMN descricao TEXT,
  ADD COLUMN criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE disciplina
  ADD COLUMN carga_horaria INT,
  ADD COLUMN descricao TEXT,
  ADD COLUMN criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 2. novas entidades essenciais

-- ALUNO

-- MATRÍCULA (histórico / status de aluno por ano)
CREATE TABLE matricula (
  id_matricula INT PRIMARY KEY AUTO_INCREMENT,
  id_aluno     INT NOT NULL,
  id_turma     INT NOT NULL,
  ano          VARCHAR(9) NOT NULL,
  data_mat     DATE NOT NULL,
  status       VARCHAR(20) DEFAULT 'Ativo',
  criado_em    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
  FOREIGN KEY (id_turma) REFERENCES turma(id_turma)
);

-- LANÇAMENTO DE NOTA

-- PRESENÇA


-- FARDAMENTO
CREATE TABLE fardamento (
  id_farda    INT PRIMARY KEY AUTO_INCREMENT,
  tipo        VARCHAR(20) NOT NULL,
  tamanho     VARCHAR(5)  NOT NULL,
  criado_em   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ENTREGA DE FARDAS
CREATE TABLE farda_aluno (
  id_farda_aluno INT PRIMARY KEY AUTO_INCREMENT,
  id_aluno       INT NOT NULL,
  id_farda       INT NOT NULL,
  data_entrega   DATE NOT NULL,
  criado_em      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
  FOREIGN KEY (id_farda) REFERENCES fardamento(id_farda)
);

-- ASSOCIAÇÃO ALUNO-CLUBE
CREATE TABLE clube_aluno (
  id_clube_aluno INT PRIMARY KEY AUTO_INCREMENT,
  id_aluno       INT NOT NULL,
  id_clube       INT NOT NULL,
  data_ingresso  DATE NOT NULL,
  data_saida     DATE,
  criado_em      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
  FOREIGN KEY (id_clube) REFERENCES clube(id_clube)
);


-- 1) remover coluna que você não quer mais
ALTER TABLE aluno
  DROP COLUMN tfardamento;

-- 2) adicionar sexo
ALTER TABLE aluno
  ADD COLUMN sexo CHAR(1) 
    CHECK (sexo IN ('M','F')) AFTER data_nasc;

-- 3) colunas de auditoria
ALTER TABLE aluno
  ADD COLUMN criado_em   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN atualizado_em TIMESTAMP 
    DEFAULT CURRENT_TIMESTAMP 
    ON UPDATE CURRENT_TIMESTAMP,
  ADD COLUMN ativo       BOOLEAN DEFAULT TRUE;

-- 1) Ajustar FARDAMENTO (já existe)
ALTER TABLE fardamento
  -- remover coluna errada
  DROP COLUMN id_aluno,
  -- mudar tamanho pra 5 chars
  CHANGE COLUMN tamanho tamanho VARCHAR(5) NOT NULL,
  -- adicionar PK auto-increment
  ADD COLUMN id_farda INT NOT NULL AUTO_INCREMENT FIRST,
  -- definir tipo da peça
  ADD COLUMN tipo VARCHAR(20) NOT NULL AFTER id_farda,
  -- coluna de auditoria
  ADD COLUMN criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER tamanho,
  -- recriar PK
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (id_farda);

-- 2) Criar Farda_Aluno (se ainda não existir)
CREATE TABLE IF NOT EXISTS farda_aluno (
  id_farda_aluno INT PRIMARY KEY AUTO_INCREMENT,
  id_aluno       INT NOT NULL,
  id_farda       INT NOT NULL,
  data_entrega   DATE NOT NULL,
  criado_em      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_fardaaluno_aluno FOREIGN KEY (id_aluno)
    REFERENCES aluno(id_aluno),
  CONSTRAINT fk_fardaaluno_farda FOREIGN KEY (id_farda)
    REFERENCES fardamento(id_farda)
);


-- 0) (Opcional) confirme o nome da FK  
SHOW CREATE TABLE fardamento\G

-- 1) derrube a FK existente
ALTER TABLE fardamento
  DROP FOREIGN KEY fardamento_ibfk_1;

-- 2) agora remova a coluna indesejada
ALTER TABLE fardamento
  DROP COLUMN id_aluno;

-- 3) adicione o id_farda como PK auto-increment
ALTER TABLE fardamento
  ADD COLUMN id_farda INT NOT NULL AUTO_INCREMENT FIRST,
  ADD PRIMARY KEY (id_farda);

-- 4) ajuste os demais campos
ALTER TABLE fardamento
  MODIFY COLUMN tamanho VARCHAR(5) NOT NULL,
  ADD COLUMN tipo VARCHAR(20) NOT NULL AFTER tamanho,
  ADD COLUMN criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER tipo;
  
-- 5) então crie a tabela de associação
CREATE TABLE IF NOT EXISTS farda_aluno (
  id_farda_aluno INT PRIMARY KEY AUTO_INCREMENT,
  id_aluno       INT NOT NULL,
  id_farda       INT NOT NULL,
  data_entrega   DATE NOT NULL,
  criado_em      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_fardaaluno_aluno FOREIGN KEY (id_aluno)
    REFERENCES aluno(id_aluno),
  CONSTRAINT fk_fardaaluno_fardamento FOREIGN KEY (id_farda)
    REFERENCES fardamento(id_farda)
);




