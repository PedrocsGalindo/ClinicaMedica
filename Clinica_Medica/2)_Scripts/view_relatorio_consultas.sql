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
;