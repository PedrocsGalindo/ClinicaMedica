DELIMITER $$

CREATE TRIGGER after_update_ordem_de_compra
AFTER UPDATE ON ORDEM_DE_COMPRA
FOR EACH ROW
BEGIN
    IF NEW.foi_cancelada = 0 THEN  
        UPDATE ORDEM_DE_COMPRA
        SET total_consolidado = (
            SELECT SUM(p.valor_unitario * i.qtd_solicitada)
            FROM ITEM_PRODUTO i
            JOIN PRODUTO p ON i.cod_produto = p.cod_produto
            WHERE i.cod_ord_compra = NEW.cod_compra
        )
        WHERE cod_compra = NEW.cod_compra;
    END IF;
END $$

DELIMITER ;