DELIMITER //

	CREATE PROCEDURE debitar_itens_solicitados( cod_pedido INT)
    BEGIN
	
    DECLARE c_cod_produto INT;
    DECLARE c_quant INT;
	DECLARE fim_cursor INT DEFAULT 0;
    
    DECLARE cursor_produtos_solicitados CURSOR FOR
    SELECT cod_produto, quant
    FROM item_solicitado
    WHERE cod_pedido_material_cir = cod_pedido;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_cursor = 1;

    OPEN cursor_produtos_solicitados;

    leitura: LOOP
		FETCH cursor_produtos_solicitados INTO c_cod_produto, c_quant;
        
        IF fim_cursor = 1 THEN 
            LEAVE leitura;
        END IF;
        
        UPDATE produto
        SET quant_atual = quant_atual - c_quant
        WHERE cod_produto = c_cod_produto;
	
    END LOOP;
    
    CLOSE cursor_produtos_solicitados;
END //
        
DELIMITER ;