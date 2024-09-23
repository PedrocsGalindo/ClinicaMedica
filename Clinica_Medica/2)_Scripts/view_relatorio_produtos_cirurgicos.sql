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
;