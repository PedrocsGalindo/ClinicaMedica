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
t.cod_tipo_trat = tp.cod_tipo_tratamento AND
t.cpf_paciente = p.cpf AND
t.cpf_paciente = c.cpf_paciente AND
t.cpf_dentista = p2.cpf AND
t.cpf_dentista = c.cpf_dentista AND

t.id_tratamento = pro.id_tratamento
;