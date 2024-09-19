USE clinicamedica
DELIMITER //

CREATE FUNCTION quantidade_em_estoque(cod_produto INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE quantidade INT;
    SELECT quant_atual INTO quantidade
    FROM produto as p
    WHERE cod_produto = p.cod_produto; 

    RETURN quantidade;
END //

DELIMITER ;