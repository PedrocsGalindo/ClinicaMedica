DELIMITER //
CREATE FUNCTION verificar_disponibilidade_atendentes(data DATE, medico varchar(11))
RETURNS BOOLEAN
READS SQL DATA
BEGIN
	DECLARE status BOOLEAN;
    DECLARE horario_inicio_medico  TIME;
    DECLARE horario_fim_medico TIME;
    
    #pega os horarios do medico nessa determinada data
    SELECT h.hora_inicio, h.hora_fim into horario_inicio_medico, horario_fim_medico
    FROM medico_possui_horario as mph, horario as h
    WHERE mph.cpf_dentista = medico AND mph.cod_horario = h.cod_horario AND h.dia = data;
    
    #se exixtir pelo menos um funcionario com horario nessa data que bata com o horario do medico
    IF EXISTS (
		SELECT 1
        FROM tecsaude_possui_horario as tph, horario as h
        where tph.cod_horario = h.cod_horario AND h.dia = data 
        AND horario_fim_medico > h.hora_inicio OR horario_inicio_medico < h.hora_fim
	)
	THEN
		SET status = TRUE;
	ELSE
		SET status = false;
	END IF;
	
    RETURN status;
END //

DELIMITER ;