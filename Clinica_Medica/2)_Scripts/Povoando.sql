START TRANSACTION;

-- Inserção na tabela PESSOA
INSERT INTO PESSOA (cpf, rg, nome, data_nasc, email, sexo, tipo_sang, num_rua, apto, cep)
VALUES
('98765432101', '987654321', 'Carlos Ribeiro', '1982-05-12', 'carlos.ribeiro@gmail.com', 'Masculino', 'A+', 123, 101, '54321987'),
('87654321098', '876543210', 'Patricia Lima', '1993-04-20', 'patricia.lima@hotmail.com', 'Feminino', 'B+', 456, 202, '65432198'),
('76543210987', '765432109', 'Felipe Almeida', '1975-11-30', 'felipe.almeida@yahoo.com', 'Masculino', 'O-', 789, 303, '76543219'),
('65432109876', '654321098', 'Sandra Ferreira', '1987-02-14', 'sandra.ferreira@outlook.com', 'Feminino', 'AB+', 321, 404, '87654321'),
('54321098765', '543210987', 'Jorge Martins', '1999-09-18', 'jorge.martins@gmail.com', 'Masculino', 'O+', 654, 505, '98765432'),
('43210987654', '432109876', 'Beatriz Sousa', '1991-08-25', 'beatriz.sousa@hotmail.com', 'Feminino', 'A-', 987, 606, '09876543'),
('32109876543', '321098765', 'Henrique Costa', '1983-12-11', 'henrique.costa@gmail.com', 'Masculino', 'B-', 258, 707, '10987654'),
('21098765432', '210987654', 'Camila Rocha', '1990-07-05', 'camila.rocha@gmail.com', 'Feminino', 'AB-', 369, 808, '21098765'),
('10987654321', '109876543', 'Marcelo Dias', '1978-10-21', 'marcelo.dias@yahoo.com', 'Masculino', 'A+', 741, 909, '32109876'),
('09876543210', '098765432', 'Luciana Moreira', '1985-03-03', 'luciana.moreira@outlook.com', 'Feminino', 'O-', 852, 1010, '43210987'),
('11223344556', '987654122', 'Ana Clara Barbosa', '1995-07-21', 'ana.barbosa@gmail.com', 'Feminino', 'B+', 111, 9, '56781234'),
('66554433221', '123456788', 'Eduardo Mendes', '1988-12-30', 'eduardo.mendes@gmail.com', 'Masculino', 'O+', 222, 15, '87654320');

-- Inserção na tabela PACIENTE
INSERT INTO PACIENTE (cpf_paciente, idade, em_tratamento)
VALUES
('98765432101', 42, TRUE),
('87654321098', 31, FALSE),
('76543210987', 48, TRUE),
('10987654321', 45, TRUE),
('66554433221', 35, FALSE);

-- Inserção na tabela SECRETARIA
INSERT INTO SECRETARIA (cpf_sec, num_carteira_trab, dt_admissao)
VALUES
('65432109876', '98712365410', '2019-06-10'),
('54321098765', '87612354309', '2018-08-25'),
('11223344556', '56781234567', '2022-05-20');

-- Inserção na tabela TEC_SAUDE_BUCAL
INSERT INTO TEC_SAUDE_BUCAL (cpf_tec, num_carteira_trab, dt_admissao, diploma_ens_medio, dt_diploma)
VALUES
('43210987654', '76543219876', '2017-09-15', 789654, '2016-11-20'),
('32109876543', '65432109875', '2016-11-30', 654987, '2015-10-05'),
('09876543210', '54321098764', '2018-03-10', 987654, '2017-01-15');

-- Inserção na tabela MEDICO_DENTISTA
INSERT INTO MEDICO_DENTISTA (cpf_dentista, num_carteira_trab, dt_admissao, cfo, especialidade)
VALUES
('21098765432', '54321098765', '2015-05-18', 'CFO54321', 'Implantodontia'),
('10987654321', '43210987654', '2014-12-12', 'CFO98765', 'Periodontia'),
('32109876543', '76543219876', '2013-07-22', 'CFO12345', 'Ortodontia');

-- Inserção na tabela FILIAL
INSERT INTO FILIAL (cnpj_filial, edificio, numero, data_abertura, cep, telefone, email)
VALUES
('33344455566633', 'Edifício C', 300, '2017-03-25', '54321987', '(21) 3456-7890', 'filial3@clinica.com'),
('44455566677744', 'Edifício D', 400, '2020-07-30', '65432198', '(21) 4567-8901', 'filial4@clinica.com'),
('55566677788855', 'Edifício E', 500, '2018-10-10', '43219876', '(21) 5678-9012', 'filial5@clinica.com');

-- Inserção na tabela TIPO_TRATAMENTO
INSERT INTO TIPO_TRATAMENTO (descricao)
VALUES
('Clareamento Dental'),
('Extração Dentária'),
('Cirurgia Ortognática'),
('Implante Dental'),
('Restauração');

-- Inserção na tabela TRATAMENTO
INSERT INTO TRATAMENTO (status_tratamento, obs, motivo, data_inicio, data_fim, cpf_paciente, cpf_dentista, cod_tipo_trat)
VALUES
('Concluído', 'Tratamento finalizado', 'Clareamento', '2021-05-15', '2021-08-30', '87654321098', '21098765432', 1),
('Em andamento', 'Paciente em processo', 'Cirurgia Ortognática', '2023-02-20', NULL, '76543210987', '10987654321', 3),
('Concluído', 'Extração realizada com sucesso', 'Extração', '2020-11-10', '2021-02-14', '98765432101', '21098765432', 2),
('Em andamento', 'Paciente em fase de recuperação', 'Implante Dental', '2022-11-01', NULL, '10987654321', '32109876543', 4),
('Concluído', 'Restauração completa', 'Restauração molar', '2023-03-01', '2023-05-01', '66554433221', '21098765432', 5);

-- Inserção na tabela PROCEDIMENTO
INSERT INTO PROCEDIMENTO (descricao, tipo, data_procedimento, status_procedimento, id_tratamento, cpf_dentista)
VALUES
('Clareamento dentário', 'Estética', '2021-07-10', 'Concluído', 1, '21098765432'),
('Extração de siso', 'Cirúrgico', '2021-01-20', 'Concluído', 3, '21098765432'),
('Preparação para cirurgia', 'Ortognática', '2023-03-10', 'Em andamento', 2, '10987654321'),
('Implante dental', 'Cirúrgico', '2022-12-15', 'Em andamento', 4, '32109876543'),
('Restauração de molar', 'Restauradora', '2023-04-10', 'Concluído', 5, '21098765432');

-- Inserção na tabela ORDEM_DE_COMPRA
INSERT INTO ORDEM_DE_COMPRA (descricao, vl_total, total_consolidado, foi_cancelada, cnpj_filial, dt_realiza)
VALUES
('Compra de equipamentos ortodônticos', 15000.50, 15000.50, FALSE, '33344455566633', '2022-04-15'),
('Compra de material cirúrgico', 10000.75, 10000.75, FALSE, '44455566677744', '2023-01-20'),
('Compra de instrumentos de restauração', 8500.00, 8500.00, FALSE, '55566677788855', '2023-06-05');

-- Inserção na tabela PRODUTO
INSERT INTO PRODUTO (descricao, fabricante, valor_unitario, tipo_unidade, qtd_minima, dt_validade, dt_fabricacao, quant_atual)
VALUES
('Alicate Ortodôntico', 'DentalTools', 250.00, 'Unidade', 10, '2025-12-01', '2023-05-15', 50),
('Fio de Sutura', 'SuturaMax', 75.00, 'Caixa', 20, '2024-10-10', '2023-01-10', 100),
('Cimento Dentário', 'DentalBond', 320.00, 'Unidade', 5, '2026-06-20', '2023-02-15', 30),
('Anestésico Dental', 'MediDental', 120.00, 'Unidade', 15, '2024-12-12', '2022-12-01', 75),
('Lâminas Cirúrgicas', 'SurgicalBlades', 45.00, 'Caixa', 25, '2025-03-01', '2023-01-20', 150);

-- Inserção na tabela ITEM_PRODUTO
INSERT INTO ITEM_PRODUTO (cod_produto, cod_ord_compra, num_lote, qtd_solicitada)
VALUES
(1, 1, 10001, 15),
(2, 2, 20002, 30),
(3, 3, 30003, 10),
(4, 1, 40004, 25),
(5, 2, 50005, 50);

-- Inserção na tabela FATURA
INSERT INTO FATURA (valor_total, data_pag, status, dt_venc, dt_geracao, cod_ordem)
VALUES
(15000.50, '2022-04-30', 'Pago', '2022-04-30', '2022-04-15', 1),
(10000.75, NULL, 'Pendente', '2023-02-20', '2023-01-20', 2),
(8500.00, '2023-07-05', 'Pago', '2023-07-01', '2023-06-05', 3);

-- Inserção na tabela PEDIDO_MATERIAL_CIR
INSERT INTO PEDIDO_MATERIAL_CIR (status_pedido, data_pedido, cod_procedimento)
VALUES
('Concluído', '2022-05-01', 1),
('Em andamento', '2023-03-10', 2),
('Concluído', '2023-07-20', 3);

-- Inserção na tabela ITEM_SOLICITADO
INSERT INTO ITEM_SOLICITADO (cod_produto, cod_pedido_material_cir, quant, data_sol)
VALUES
(1, 1, 10, '2022-04-28'),
(2, 2, 20, '2023-03-08'),
(3, 3, 5, '2023-07-10'),
(4, 1, 15, '2022-05-01'),
(5, 2, 30, '2023-03-15');

-- Inserção na tabela ASSISTIDO_POR
INSERT INTO ASSISTIDO_POR (cpf_tec, cod_procedimento)
VALUES
('43210987654', 1),
('32109876543', 2),
('09876543210', 3);

-- Inserção na tabela CONSULTA
INSERT INTO CONSULTA (cpf_paciente, cpf_dentista, data_consulta)
VALUES
('98765432101', '21098765432', '2023-08-15'),
('87654321098', '10987654321', '2023-07-10'),
('76543210987', '32109876543', '2023-06-05');

-- Inserção na tabela AGENDAMENTO
INSERT INTO AGENDAMENTO (cpf_sec, cpf_paciente, cpf_dentista, data_agendamento, hora_agendamento, status_agendamento)
VALUES
('65432109876', '98765432101', '21098765432', '2023-08-10', '09:00:00', 'Confirmado'),
('54321098765', '87654321098', '10987654321', '2023-07-05', '14:00:00', 'Pendente'),
('11223344556', '76543210987', '32109876543', '2023-06-01', '11:00:00', 'Confirmado');

-- Inserção na tabela HORARIO
INSERT INTO HORARIO (descricao, hora_inicio, hora_fim, dia)
VALUES
('Matutino', '08:00:00', '12:00:00', '2023-09-18'), 
('Vespertino', '13:00:00', '17:00:00', '2023-09-19'), 
('Noturno', '18:00:00', '22:00:00', '2023-09-20'),    
('Matutino', '09:00:00', '12:00:00', '2023-09-18'),  
('Vespertino', '10:30:00', '17:00:00', '2023-09-19'), 
('Noturno', '11:00:00', '22:00:00', '2023-09-20');    

-- Inserção na tabela MEDICO_POSSUI_HORARIO
INSERT INTO MEDICO_POSSUI_HORARIO (cpf_dentista, cod_horario)
VALUES
('21098765432', 1),
('10987654321', 2),
('32109876543', 3);

-- Inserção na tabela TECSAUDE_POSSUI_HORARIO
INSERT INTO TECSAUDE_POSSUI_HORARIO (cpf_tec, cod_horario)
VALUES
('43210987654', 4),
('32109876543', 5),
('09876543210', 6);

COMMIT;