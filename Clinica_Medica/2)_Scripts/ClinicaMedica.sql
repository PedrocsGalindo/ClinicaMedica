CREATE SCHEMA ClinicaMedica;
USE ClinicaMedica;
CREATE TABLE PESSOA (
cpf VARCHAR(11) UNIQUE NOT NULL,
rg VARCHAR(9) UNIQUE NOT NULL,
nome VARCHAR(255) NOT NULL,
data_nasc DATE NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
sexo VARCHAR(10) NOT NULL,
tipo_sang VARCHAR(3) NOT NULL,
num_rua INT NOT NULL,
apto INT NOT NULL,
cep VARCHAR(8) NOT NULL,
PRIMARY KEY (cpf),
CONSTRAINT chk_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
CONSTRAINT chk_rg CHECK (rg REGEXP '^[0-9]{9}$'),
CONSTRAINT chk_cep CHECK (cep REGEXP '^[0-9]{8}$')
);
CREATE TABLE PACIENTE (
cpf_paciente VARCHAR(11) NOT NULL UNIQUE,
idade INT NOT NULL,
em_tratamento BOOLEAN NOT NULL,
PRIMARY KEY (cpf_paciente),
FOREIGN KEY (cpf_paciente) REFERENCES PESSOA(cpf)
);
CREATE TABLE SECRETARIA (
cpf_sec VARCHAR(11) NOT NULL UNIQUE,
num_carteira_trab VARCHAR(11) NOT NULL UNIQUE,
dt_admissao DATE NOT NULL,
PRIMARY KEY (cpf_sec),
FOREIGN KEY (cpf_sec) REFERENCES PESSOA(cpf)
);
CREATE TABLE TEC_SAUDE_BUCAL(
cpf_tec VARCHAR(11) NOT NULL UNIQUE,
num_carteira_trab VARCHAR(11) NOT NULL UNIQUE,
dt_admissao DATE NOT NULL,
diploma_ens_medio INT NOT NULL,
dt_diploma DATE NOT NULL,
PRIMARY KEY (cpf_tec),
FOREIGN KEY (cpf_tec) REFERENCES PESSOA(cpf)
);
CREATE TABLE MEDICO_DENTISTA (
cpf_dentista VARCHAR(11) NOT NULL UNIQUE,
num_carteira_trab VARCHAR(11) NOT NULL UNIQUE,
dt_admissao DATE NOT NULL,
cfo VARCHAR(20) NOT NULL UNIQUE,
especialidade VARCHAR(20) NOT NULL,
PRIMARY KEY (cpf_dentista),
FOREIGN KEY (cpf_dentista) REFERENCES PESSOA(cpf)
);
CREATE TABLE FILIAL(
cnpj_filial VARCHAR(14) NOT NULL UNIQUE,
edificio VARCHAR(40) NOT NULL,
numero INT NOT NULL,
data_abertura DATE NOT NULL,
cep VARCHAR(8) NOT NULL,
telefone VARCHAR(14) NOT NULL UNIQUE,
email VARCHAR(50) UNIQUE NOT NULL,
PRIMARY KEY (cnpj_filial)
);
CREATE TABLE TIPO_TRATAMENTO (
cod_tipo_tratamento INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(255) NOT NULL
); 
CREATE TABLE TRATAMENTO (
id_tratamento INT AUTO_INCREMENT PRIMARY KEY,
status_tratamento VARCHAR(50) NOT NULL,
obs TEXT,
motivo TEXT,
data_inicio DATE NOT NULL,
data_fim DATE,
cpf_paciente VARCHAR(11) NOT NULL,
cpf_dentista VARCHAR(11) NOT NULL,
cod_tipo_trat INT NOT NULL,
FOREIGN KEY (cpf_paciente) REFERENCES PACIENTE(cpf_paciente),
FOREIGN KEY (cpf_dentista) REFERENCES MEDICO_DENTISTA(cpf_dentista),
FOREIGN KEY (cod_tipo_trat) REFERENCES
TIPO_TRATAMENTO(cod_tipo_tratamento)
);
CREATE TABLE PROCEDIMENTO (
codigo INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(255) NOT NULL,
tipo VARCHAR(50) NOT NULL,
data_procedimento DATE NOT NULL,
status_procedimento VARCHAR(20) NOT NULL,
id_tratamento INT NOT NULL,
cpf_dentista VARCHAR(11) NOT NULL,
FOREIGN KEY (id_tratamento) REFERENCES TRATAMENTO(id_tratamento),
FOREIGN KEY (cpf_dentista) REFERENCES MEDICO_DENTISTA(cpf_dentista)
);
CREATE TABLE ORDEM_DE_COMPRA (
cod_compra INT AUTO_INCREMENT UNIQUE,
descricao VARCHAR(100) NOT NULL,
vl_total DOUBLE NOT NULL,
total_consolidado DOUBLE DEFAULT 0,
foi_cancelada BOOLEAN NOT NULL,
cnpj_filial VARCHAR(14) NOT NULL,
dt_realiza DATE NOT NULL,
PRIMARY KEY (cod_compra),
FOREIGN KEY (cnpj_filial) REFERENCES FILIAL(cnpj_filial)
);
CREATE TABLE PRODUTO(
cod_produto INT AUTO_INCREMENT UNIQUE,
descricao VARCHAR(100) NOT NULL,
fabricante VARCHAR(30) NOT NULL,
valor_unitario DOUBLE NOT NULL,
tipo_unidade VARCHAR(30) NOT NULL,
qtd_minima INT NOT NULL,
dt_validade DATE NOT NULL,
dt_fabricacao DATE NOT NULL,
quant_atual INT DEFAULT 0,
PRIMARY KEY (cod_produto)
);
CREATE TABLE ITEM_PRODUTO(
cod_produto INT NOT NULL,
cod_ord_compra INT NOT NULL,
num_lote INT AUTO_INCREMENT UNIQUE,
qtd_solicitada INT NOT NULL,
PRIMARY KEY(num_lote),
FOREIGN KEY(cod_produto) REFERENCES PRODUTO(cod_produto),
FOREIGN KEY(cod_ord_compra) REFERENCES
ORDEM_DE_COMPRA(cod_compra)
);
CREATE TABLE FATURA(
cod_fatura INT AUTO_INCREMENT UNIQUE,
valor_total DOUBLE NOT NULL,
data_pag DATE,
status VARCHAR(9) NOT NULL,
dt_venc DATE NOT NULL,
dt_geracao DATE NOT NULL,
cod_ordem INT NOT NULL,
PRIMARY KEY (cod_fatura),
FOREIGN KEY (cod_ordem) REFERENCES ORDEM_DE_COMPRA(cod_compra)
);
CREATE TABLE PEDIDO_MATERIAL_CIR (
codigo INT AUTO_INCREMENT PRIMARY KEY,
status_pedido VARCHAR(20) NOT NULL,
data_pedido DATE NOT NULL,
cod_procedimento INT NOT NULL,
FOREIGN KEY (cod_procedimento) REFERENCES PROCEDIMENTO(codigo)
);
CREATE TABLE ITEM_SOLICITADO (
cod_produto INT NOT NULL,
cod_pedido_material_cir INT NOT NULL,
quant INT NOT NULL,
 data_sol DATE NOT NULL,
FOREIGN KEY (cod_produto) REFERENCES PRODUTO(cod_produto),
FOREIGN KEY (cod_pedido_material_cir) REFERENCES
PEDIDO_MATERIAL_CIR(codigo)
);
CREATE TABLE HORARIO (
codigo_horario INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(10) NOT NULL,
hora_inicio TIME NOT NULL,
hora_fim TIME NOT NULL,
dia DATE NOT NULL,
UNIQUE(hora_inicio, hora_fim)
);
CREATE TABLE ASSISTIDO_POR (
cpf_tec VARCHAR(11) NOT NULL,
cod_procedimento INT NOT NULL,
PRIMARY KEY(cpf_tec, cod_procedimento),
FOREIGN KEY (cpf_tec) REFERENCES TEC_SAUDE_BUCAL(cpf_tec),
FOREIGN KEY (cod_procedimento) REFERENCES PROCEDIMENTO(codigo)
);
CREATE TABLE CONSULTA(
cpf_paciente VARCHAR(11) NOT NULL,
cpf_dentista VARCHAR(11) NOT NULL,
data_consulta DATE NOT NULL,
PRIMARY KEY(cpf_paciente, cpf_dentista, data_consulta),
FOREIGN KEY (cpf_paciente) REFERENCES PACIENTE(cpf_paciente),
FOREIGN KEY (cpf_dentista) REFERENCES MEDICO_DENTISTA(cpf_dentista)
);

CREATE TABLE AGENDAMENTO (
cpf_sec VARCHAR(11) NOT NULL,
cpf_paciente VARCHAR(11) NOT NULL,
cpf_dentista VARCHAR(11) NOT NULL,
data_agendamento DATE NOT NULL,
hora_agendamento TIME NOT NULL,
status_agendamento VARCHAR(20) NOT NULL,
PRIMARY KEY (cpf_sec, cpf_paciente, cpf_dentista, data_agendamento,
hora_agendamento),
FOREIGN KEY (cpf_sec) REFERENCES SECRETARIA(cpf_sec),
FOREIGN KEY (cpf_paciente) REFERENCES PACIENTE(cpf_paciente),
FOREIGN KEY (cpf_dentista) REFERENCES MEDICO_DENTISTA(cpf_dentista)
);
CREATE TABLE MEDICO_POSSUI_HORARIO (
cpf_dentista VARCHAR(11) NOT NULL,
cod_horario INT NOT NULL,
PRIMARY KEY(cpf_dentista, cod_horario),
FOREIGN KEY (cpf_dentista) REFERENCES MEDICO_DENTISTA(cpf_dentista),
FOREIGN KEY (cod_horario) REFERENCES HORARIO(codigo_horario)
);
CREATE TABLE TECSAUDE_POSSUI_HORARIO (
cpf_tec VARCHAR(11) NOT NULL,
cod_horario INT NOT NULL,
PRIMARY KEY(cpf_tec, cod_horario),
FOREIGN KEY (cpf_tec) REFERENCES TEC_SAUDE_BUCAL(cpf_tec),
FOREIGN KEY (cod_horario) REFERENCES HORARIO(codigo_horario)
);