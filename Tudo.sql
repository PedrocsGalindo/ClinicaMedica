DELIMITER //

#quantidade de um certo produto
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

#verifica quantidade de um certo e atualiza
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

#Verifica atendente
CREATE FUNCTION verificar_disponibilidade_atendentes(data DATE, medico varchar(11))
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE sts INT DEFAULT 0;
    DECLARE horario_inicio_medico  TIME;
    DECLARE horario_fim_medico TIME;
    
    #pega os horarios do medico nessa determinada data
    SELECT h.hora_inicio, h.hora_fim into horario_inicio_medico, horario_fim_medico
    FROM medico_possui_horario as mph, horario as h
    WHERE mph.cpf_dentista = medico AND mph.cod_horario = h.codigo_horario AND h.dia = data;
    
    #se exixtir pelo menos um funcionario com horario nessa data que bata com o horario do medico
    IF EXISTS (
		SELECT 1
        FROM tecsaude_possui_horario as tph, horario as h
        where tph.cod_horario = h.codigo_horario AND h.dia = data 
        AND horario_fim_medico > h.hora_inicio OR horario_inicio_medico < h.hora_fim
	)
	THEN
		SET sts = 1;
	END IF;
	
    RETURN sts;
END //

#Gerar Ordem e inserir item_produto apartir da ordem_de_compra
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

#debitar item_solicitado na tabela produto
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

#atualizar quantidade de itens
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
END //

CREATE TRIGGER after_delete_item_solicitado
AFTER DELETE ON ITEM_SOLICITADO
FOR EACH ROW
BEGIN
    UPDATE PRODUTO
    SET quant_atual = quant_atual + OLD.quant
    WHERE cod_produto = OLD.cod_produto;
END //

#depois de uma ordem de compra
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
END //

#inserir data_sol
CREATE TRIGGER before_insert_item_solicitado
BEFORE INSERT ON ITEM_SOLICITADO
FOR EACH ROW
BEGIN
    SET NEW.data_sol = CURRENT_DATE;
END //

#view tratamento
Create view resumo_relatorio_tratamento as
select tp.descricao as Tratamento, p.nome as Paciente, p2.nome as Medico, pro.descricao as Procedimento, t.data_inicio as inicio , t.data_fim as fim
from 
tratamento as t, 
tipo_tratamento as tp, 
pessoa as p,
pessoa as p2,
procedimento as pro
where 
t.cod_tipo_trat = tp.cod_tipo_tratamento AND
t.cpf_paciente = p.cpf AND
t.cpf_dentista = p2.cpf AND 
t.id_tratamento = pro.id_tratamento
//

#view produtos cirurgicos
CREATE VIEW relatorio_produtos_cirurgicos AS
select prod.descricao as produto, isl.quant as quantidade, tp.descricao as Tratamento, p.nome as Medico, pro.descricao as Procedimento, t.data_inicio as inicio , t.data_fim as fim
from 
tratamento as t, 
tipo_tratamento as tp, 
pessoa as p,
procedimento as pro,
pedido_material_cir as pmc,
item_solicitado as isl,
produto as prod
where 
pro.codigo = pmc.cod_procedimento AND
pmc.codigo = isl.cod_pedido_material_cir AND
isl.cod_produto = prod.cod_produto AND
t.cod_tipo_trat = tp.cod_tipo_tratamento AND
t.cpf_dentista = p.cpf AND 
t.id_tratamento = pro.id_tratamento
//

#view consulta
CREATE VIEW relatorio_consultas AS
SELECT  p.nome as Paciente, tp.descricao as Tratamento, pro.descricao as Procedimento, p2.nome as Medico, c.data_consulta
FROM
consulta as c,
tratamento as t, 
tipo_tratamento as tp, 
pessoa as p,
pessoa as p2,
procedimento as pro
WHERE
t.cpf_paciente = c.cpf_paciente AND
t.cpf_dentista = c.cpf_dentista AND
t.id_tratamento = pro.id_tratamento AND
t.cod_tipo_trat = tp.cod_tipo_tratamento AND
c.cpf_paciente = p.cpf AND
c.cpf_dentista = p2.cpf
//