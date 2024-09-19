DELIMITER $$

CREATE TRIGGER after_delete_item_solicitado
AFTER DELETE ON ITEM_SOLICITADO
FOR EACH ROW
BEGIN
    UPDATE PRODUTO
    SET quant_atual = quant_atual + OLD.quant
    WHERE cod_produto = OLD.cod_produto;
END $$

DELIMITER ;