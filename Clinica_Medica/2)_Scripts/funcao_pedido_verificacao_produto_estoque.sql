USE clinicamedicaagendamento
DELIMITER //

CREATE FUNCTION pedido_verificacao_produto_estoque(cod_produto INT , quantidade_pedido INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
	DECLARE status BOOLEAN;
    DECLARE resto INT;
    DECLARE quantidade_minima INT;
    
    SELECT qtd_minima INTO quantidade_minima
    FROM produto as p
    WHERE cod_produto = p.cod_produto;

    
    set resto = quantidade_em_estoque(cod_produto) - quantidade_pedido;
    IF (resto < quantidade_minima) THEN
		SET status = FALSE;
	ELSE
		SET status = TRUE;
        UPDATE produto as p SET p.quant_atual = resto Where p.cod_produto = cod_produto;
    END IF;
    
    RETURN status;
END //

DELIMITER ;