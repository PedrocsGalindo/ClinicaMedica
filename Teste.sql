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
#tem que verificar ainda
UPDATE produto
SET quant_atual = 0
WHERE cod_produto < 3;
CALL pedido_reabastecimento_produtos_na_baixa(33344455566633);
*/

/*
SELECT *
FROM pedido_material_cir;

SELECT *
FROM item_solicitado
WHERE cod_pedido_material_cir = 2;

SELECT *
FROM produto
WHERE cod_produto = 2 OR cod_produto = 5;

CALL debitar_itens_solicitados(2);
*/


#views
/*
SELECT * FROM resumo_relatorio_tratamento;
*/
/*
SELECT * FROM relatorio_produtos_cirurgicos;
*/
/*
SELECT * FROM relatorio_consultas;
*/
