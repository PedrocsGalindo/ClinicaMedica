#Versão que utilizamos não suporta ROLE

#ADM
CREATE USER 'adm'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON * TO 'adm';

#MEDICO
CREATE USER 'medico'@'localhost' IDENTIFIED BY 'medico123';
GRANT UPDATE, INSERT ON pessoa TO 'medico'; 
GRANT UPDATE, INSERT ON paciente TO 'medico'; 
GRANT INSERT, UPDATE ON consulta TO 'medico';
GRANT INSERT ON medico_possui_horario TO 'medico';
GRANT INSERT, UPDATE ON tratamento TO 'medico';
GRANT INSERT, UPDATE ON procedimento TO 'medico';
GRANT INSERT, UPDATE ON pedido_material_cir TO 'medico';
GRANT INSERT ON item_solicitado TO 'medico';

#TECNICO
CREATE USER 'tecnico'@'localhost' IDENTIFIED BY 'tecnico123';
GRANT INSERT ON tecsaude_possui_horario TO 'tecnico';

#SECRETARIA
CREATE USER 'secretaria'@'localhost' IDENTIFIED BY 'secretaria123';
GRANT UPDATE, INSERT ON pessoa TO 'secretaria'; 
GRANT UPDATE, INSERT ON paciente TO 'secretaria'; 
GRANT INSERT, UPDATE ON consulta TO 'secretaria';

#FILIAL
CREATE USER 'filial'@'localhost' IDENTIFIED BY 'filial123';
GRANT UPDATE, INSERT ON ordem_de_compra TO 'filial'; 
GRANT UPDATE, INSERT ON fatura TO 'filial'; 
GRANT UPDATE, INSERT ON ordem_de_compra TO 'filial'; 
GRANT UPDATE, INSERT ON produto to 'filial';
GRANT EXECUTE ON PROCEDURE pedido_reabastecimento_produtos_na_baixa TO 'filial';
GRANT EXECUTE ON PROCEDURE debitar_itens_solicitados TO 'filial';





