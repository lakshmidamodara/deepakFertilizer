-----------------------------------------------------------
--- File Name      : insert_activity_data_data.sql
--- Author Name    : Lakshmi Damodara
--- Creation Date  : 02/28/2018
--- Updated on     : 
--- Version        : 1.0
--- Description    : This function inserts  data into public.activity_data
--- 
------------------------------------------------------------
	
CREATE OR REPLACE FUNCTION insert_activity_data_data(p_activity_id integer, p_date date, p_actual_hours integer, p_actual_units double precision, 
												p_planned_hours integer, p_planned_units double precision,
												p_planned_resources integer, p_actual_resources integer)
RETURNS INTEGER AS $$
DECLARE
	l_id INTEGER;
BEGIN
	SELECT id INTO STRICT l_id
	FROM public.activity_data AS p
	WHERE
		UPPER(p.activity_id) IS NOT DISTINCT FROM UPPER(p_activity_id)
		AND p.date IS NOT DISTINCT FROM p_date
		AND p.actual_hours IS NOT DISTINCT FROM p_actual_hours
		AND p.actual_units IS NOT DISTINCT FROM p_actual_units
		AND p.planned_hours IS NOT DISTINCT FROM p_planned_hours
		AND p.planned_units IS NOT DISTINCT FROM p_planned_units
		AND p.actual_resources IS NOT DISTINCT FROM p_actual_resources
		AND p.planned_resources IS NOT DISTINCT FROM p_planned_resources;
    
	RETURN l_id;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			INSERT INTO public.activity_data (activity_id, date, actual_hours, actual_units, planned_hours, planned_units,
												planned_resources, actual_resources, updated, created) 
			VALUES (p_activity_id, p_date, p_actual_hours, p_actual_units, p_planned_hours, p_planned_units,
					p_planned_resources, p_actual_resources, current_timestamp(2), current_timestamp(2));
			RETURN CURRVAL('public.activity_data_id_seq');
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Found more than one row in activity_data for activity_id %', p_activity_id;
   
END; $$
LANGUAGE plpgsql;