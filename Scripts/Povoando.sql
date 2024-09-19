START TRANSACTION;

INSERT INTO PESSOA (cpf, rg, nome, data_nasc, email, sexo, tipo_sang, num_rua, apto, cep)
VALUES
('12345678901', '123456789', 'João da Silva', '1985-06-15', 'joao.silva@gmail.com', 'Masculino', 'O+', 123, 45, '12345678'),
('23456789012', '234567890', 'Maria Oliveira', '1990-03-22', 'maria.oliveira@gmail.com', 'Feminino', 'A-', 456, 78, '23456789'),
('34567890123', '345678901', 'Pedro Santos', '1978-09-10', 'pedro.santos@gmail.com', 'Masculino', 'B+', 789, 12, '34567890'),
('45678901234', '456789012', 'Ana Souza', '1983-11-05', 'ana.souza@gmail.com', 'Feminino', 'AB-', 321, 34, '45678901'),
('56789012345', '567890123', 'Lucas Pereira', '1995-07-30', 'lucas.pereira@gmail.com', 'Masculino', 'A+', 654, 56, '56789012'),
('67890123456', '678901234', 'Juliana Carvalho', '1992-12-01', 'juliana.carvalho@gmail.com', 'Feminino', 'O-', 987, 78, '67890123'),
('78901234567', '789012345', 'Ricardo Lima', '1980-03-18', 'ricardo.lima@gmail.com', 'Masculino', 'B-', 147, 90, '78901234'),
('89012345678', '890123456', 'Mariana Dias', '1987-08-22', 'mariana.dias@gmail.com', 'Feminino', 'AB+', 258, 12, '89012345'),
('90123456789', '901234567', 'Carlos Mendes', '1993-05-14', 'carlos.mendes@gmail.com', 'Masculino', 'O-', 369, 34, '90123456'),
('01234567890', '012345678', 'Fernanda Costa', '1989-01-27', 'fernanda.costa@gmail.com', 'Feminino', 'A-', 741, 56, '01234567');

INSERT INTO PACIENTE (cpf_paciente, idade, em_tratamento)
VALUES
('12345678901', 39, TRUE),
('23456789012', 34, FALSE),
('34567890123', 45, TRUE);

INSERT INTO SECRETARIA (cpf_sec, num_carteira_trab, dt_admissao)
VALUES
('45678901234', '98765432101', '2021-02-15'),
('56789012345', '87654321012', '2020-03-30');

INSERT INTO TEC_SAUDE_BUCAL (cpf_tec, num_carteira_trab, dt_admissao, diploma_ens_medio, dt_diploma)
VALUES
('67890123456', '76543210987', '2019-04-25', 123456, '2018-12-10'),
('78901234567', '65432109876', '2018-08-12', 654321, '2017-07-15');

INSERT INTO MEDICO_DENTISTA (cpf_dentista, num_carteira_trab, dt_admissao, cfo, especialidade)
VALUES
('89012345678', '54321098765', '2017-05-20', 'CFO12345', 'Ortodontia'),
('90123456789', '43210987654', '2016-11-30', 'CFO67890', 'Endodontia');

INSERT INTO FILIAL (cnpj_filial, edificio, numero, data_abertura, cep, telefone, email)
VALUES
('11122233344411', 'Edifício A', 100, '2010-01-15', '12345678', '(11) 1234-5678', 'filial1@clinica.com'),
('22233344455522', 'Edifício B', 200, '2015-06-20', '23456789', '(11) 2345-6789', 'filial2@clinica.com');

INSERT INTO TIPO_TRATAMENTO (descricao)
VALUES
('Tratamento Ortodôntico'),
('Tratamento Endodôntico'),
('Limpeza Dentária');

INSERT INTO TRATAMENTO (status_tratamento, obs, motivo, data_inicio, data_fim, cpf_paciente, cpf_dentista, cod_tipo_trat)
VALUES
('Em andamento', 'Paciente está respondendo bem', 'Aparelho dentário', '2022-01-10', NULL, '12345678901', '89012345678', 1),
('Concluído', 'Tratamento finalizado com sucesso', 'Canal', '2021-09-15', '2022-02-20', '23456789012', '90123456789', 2),
('Em andamento', 'Manutenção periódica', 'Limpeza', '2023-03-01', NULL, '34567890123', '89012345678', 3);

INSERT INTO PROCEDIMENTO (descricao, tipo, data_procedimento, status_procedimento, id_tratamento, cpf_dentista)
VALUES
('Ajuste de aparelho', 'Ortodontia', '2023-07-10', 'Concluído', 1, '89012345678'),
('Canal dentário', 'Endodontia', '2022-02-15', 'Concluído', 2, '90123456789'),
('Limpeza bucal', 'Higiene', '2023-03-10', 'Concluído', 3, '89012345678');

COMMIT;