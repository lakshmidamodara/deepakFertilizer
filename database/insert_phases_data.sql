-----------------------------------------------------------
--- File Name      : insert_phases_data.sql
--- Author Name    : Lakshmi Damodara
--- Creation Date  : 02/28/2018
--- Updated on     : 
--- Version        : 1.0
--- Description    : This function inserts  data into public.phases
---                  
--- 
--- 
------------------------------------------------------------
	
CREATE OR REPLACE FUNCTION insert_phases_data(p_name text,p_project_id integer)
RETURNS INTEGER AS $$
DECLARE
	l_phase_id INTEGER;
BEGIN
	SELECT id INTO STRICT l_phase_id
	FROM public.phases AS p
	WHERE
		UPPER(p.name) IS NOT DISTINCT FROM UPPER(p_name)
		AND p.project_id IS NOT DISTINCT FROM p_project_id;
    
	RETURN l_phase_id;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			INSERT INTO public.phases (name, project_id) 
			VALUES (p_name, p_project_id);
			RETURN CURRVAL('public.phases_id_seq');
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Found more than one row in phases for name %', p_name;
   
END; $$
LANGUAGE plpgsql;
