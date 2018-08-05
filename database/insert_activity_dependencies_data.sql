-----------------------------------------------------------
--- File Name      : insert_activity_dependencies_data.sql
--- Author Name    : Lakshmi Damodara
--- Creation Date  : 02/28/2018
--- Updated on     : 
--- Version        : 1.0
--- Description    : This function inserts data into public.activity_dependencies
---                  
--- 
--- 
------------------------------------------------------------

CREATE OR REPLACE FUNCTION insert_activity_dependencies_data(p_activity_id integer, p_required_activity_id integer)
RETURNS INTEGER AS $$
DECLARE
	l_id INTEGER;
BEGIN
	SELECT id INTO STRICT l_id
	FROM public.activity_dependencies AS act
	WHERE
		act.activity_id IS NOT DISTINCT FROM p_activity_id 
		AND act.required_activity_id IS NOT DISTINCT FROM p_required_activity_id;
		
	RETURN l_id;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			INSERT INTO public.activity_dependencies (activity_id, required_activity_id)
			VALUES (p_activity_id, p_required_activity_id);
			return currval('public.activity_dependencies_id_seq');
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Found more than one row in bundles for name %', p_name;
END; $$
LANGUAGE plpgsql