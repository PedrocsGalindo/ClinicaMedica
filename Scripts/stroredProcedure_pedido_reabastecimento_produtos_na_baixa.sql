DELIMITER //

CREATE PROCEDURE pedido_reabastecimento_produtos_na_baixa(IN cnpj VARCHAR(14))
BEGIN
    DECLARE c_cod_produto INT;
    DECLARE c_valor_unitario DECIMAL(10, 2);
    DECLARE c_qtd_minima INT;
    DECLARE c_quant_atual INT;
    DECLARE c_descricao VARCHAR(100);
    DECLARE c_cod_compra INT DEFAULT NULL;

    DECLARE cc_descricao VARCHAR(150);
    DECLARE unidades INT;

    DECLARE vl_compra_total DOUBLE;
    DECLARE num_parcelas INT;
    DECLARE i INT;
    
    DECLARE fim_cursor INT DEFAULT 0;
    DECLARE erro INT DEFAULT 0; 

    #Cursor Produtos em Baixa
    DECLARE cursor_produtos_baixa CURSOR FOR
    SELECT cod_produto, valor_unitario, qtd_minima, quant_atual, descricao
    FROM produto
    WHERE quant_atual < qtd_minima;

    # Handler cursor atingir o fim
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_cursor = 1;

    START TRANSACTION;

    OPEN cursor_produtos_baixa;

    leitura: LOOP
        FETCH cursor_produtos_baixa INTO c_cod_produto, c_valor_unitario, c_qtd_minima, c_quant_atual, c_descricao;
        
        IF fim_cursor = 1 THEN 
            LEAVE leitura;
        END IF;
        
        SET unidades = c_qtd_minima - c_quant_atual;
        SET cc_descricao = CONCAT(unidades, ' unidades de ', c_descricao);
        
        #Criar ou atualizar a ordem de compra
        IF c_cod_compra IS NULL THEN
        
            #Criar uma nova ordem de compra
            INSERT INTO ordem_de_compra(descricao, vl_total, total_consolidado, foi_cancelada, cnpj_filial, dt_realiza)
            VALUES (cc_descricao, unidades * c_valor_unitario, 0, 0, cnpj, CURDATE());
        
            SET c_cod_compra = LAST_INSERT_ID();
        ELSE
			#Adiciona mais um produto a mesma ordem de compra
            UPDATE ordem_de_compra 
            SET descricao = CONCAT(descricao, CHAR(10), cc_descricao), 
                vl_total = vl_total + (unidades * c_valor_unitario)
            WHERE cod_compra = c_cod_compra;
        END IF;
        
        #criacão do item produto
        INSERT INTO item_produto(cod_produto, cod_ord_compra, qtd_solicitada)
        VALUES (c_cod_produto, c_cod_compra, unidades);
        	
    END LOOP;

    CLOSE cursor_produtos_baixa;

    #Criação das faturas
    SELECT vl_total INTO vl_compra_total
    FROM ordem_de_compra
    WHERE cod_compra = c_cod_compra;

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
        INSERT INTO fatura (valor_total, status, dt_vencimento, dt_geração, cod_ordem)
        VALUES (vl_compra_total / num_parcelas, 'pendente', DATE_ADD(CURDATE(), INTERVAL i MONTH), CURDATE(), c_cod_compra);
    
        SET i = i + 1;
    END WHILE;
    
    # verificação de um erro
    IF erro = 1 THEN
        SELECT 'Erro encontrado';
    ELSE
        COMMIT;
        SELECT 'Transação concluída com sucesso.';
    END IF;
    
END //

DELIMITER ;