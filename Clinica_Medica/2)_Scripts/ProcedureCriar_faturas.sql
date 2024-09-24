DELIMITER //
#Criação das faturas
CREATE PROCEDURE criarFaturas(IN c_cod_compra INT, vl_compra_total DOUBLE)
BEGIN

DECLARE num_parcelas INT;
DECLARE i INT;

# Número de faturas com base no valor total
IF vl_compra_total < 1000 THEN
	SET num_parcelas = 2;
ELSEIF vl_compra_total >= 1000 AND vl_compra_total < 2000 THEN
	SET num_parcelas = 3;
ELSE
	SET num_parcelas = 4;
END IF;
    
# Logica de inserção
SET i = 1;
WHILE i <= num_parcelas DO
	INSERT INTO fatura (valor_total, status, dt_venc, dt_geracao, cod_ordem)
	VALUES (vl_compra_total / num_parcelas, 'pendente', DATE_ADD(CURDATE(), INTERVAL i MONTH), CURDATE(), c_cod_compra);
    
	SET i = i + 1;
END WHILE;
END //
DELIMITER ;