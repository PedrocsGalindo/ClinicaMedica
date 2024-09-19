#ADM
GRANT ALL PRIVILEGES ON * TO 'adm';

#MEDICO
GRANT UPDATE, INSERT ON pessoa TO 'medico'; 
GRANT INSERT, UPDATE ON consulta TO 'medico';
GRANT INSERT ON medico_possui_horario TO 'medico';
GRANT INSERT, UPDATE ON tratamento TO 'medico';
GRANT INSERT, UPDATE ON procedimento TO 'medico';
GRANT INSERT, UPDATE ON pedido_material_cir TO 'medico';
GRANT INSERT ON item_solicitado TO 'medico';

#TECNICO
GRANT INSERT ON tecsaude_possui_horario TO 'tecnico';


#FILIAL
GRANT UPDATE, INSERT ON ordem_de_compra TO 'filial'; 
GRANT UPDATE, INSERT ON fatura TO 'filial'; 
GRANT UPDATE, INSERT ON ordem_de_compra TO 'filial'; 
GRANT UPDATE, INSERT ON produto to 'filial';
GRANT EXECUTE ON PROCEDURE pedido_reabastecimento_produtos_na_baixa TO 'filial';
GRANT EXECUTE ON PROCEDURE debitar_itens_solicitados TO 'filial';





