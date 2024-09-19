DELIMITER $$

CREATE TRIGGER after_insert_item_solicitado
AFTER INSERT ON ITEM_SOLICITADO
FOR EACH ROW
BEGIN
  
    UPDATE PRODUTO
    SET quant_atual = quant_atual - NEW.quant
    WHERE cod_produto = NEW.cod_produto;
    IF (SELECT quant_atual FROM PRODUTO WHERE cod_produto = NEW.cod_produto) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade insuficiente no estoque';
    END IF;
END $$

DELIMITER ;