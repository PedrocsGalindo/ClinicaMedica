/*
SELECT *
FROM produto;
SELECT quantidade_em_estoque(1) AS qtd_produto_1;
*/

/*
SELECT *
FROM produto;
SELECT pedido_verificacao_produto_estoque(1, 5) AS estoque_disponivel;
*/

/*
SELECT *
FROM horario;
SELECT verificar_disponibilidade_atendentes('2023-09-18', '21098765432') AS atendente_disponivel;
*/

/*
UPDATE produto
SET quant_atual = 0
WHERE cod_produto < 3;
CALL pedido_reabastecimento_produtos_na_baixa(33344455566633);
*/
CALL pedido_reabastecimento_produtos_na_baixa(33344455566633);
