DELIMITER //

CREATE PROCEDURE debitar_itens_solicitados(cod_pedido INT)
BEGIN
    DECLARE c_cod_produto INT;
    DECLARE c_quant INT;
    DECLARE fim_cursor INT DEFAULT 0;
    DECLARE verificado BOOLEAN;

    DECLARE cursor_produtos_solicitados CURSOR FOR
    SELECT cod_produto, quant
    FROM item_solicitado
    WHERE cod_pedido_material_cir = cod_pedido;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_cursor = 1;

    START TRANSACTION;

    OPEN cursor_produtos_solicitados;

    leitura: LOOP

        FETCH cursor_produtos_solicitados INTO c_cod_produto, c_quant;

        IF fim_cursor = 1 THEN 
            LEAVE leitura;
        END IF;
        
		-- verificação
        SELECT pedido_verificacao_produto_estoque(c_cod_produto, c_quant) INTO verificado;

        IF verificado = FALSE THEN
            ROLLBACK;
            LEAVE leitura;
        END IF;
        
    END LOOP;
    CLOSE cursor_produtos_solicitados;
    COMMIT;
END //

DELIMITER ;