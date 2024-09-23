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
;