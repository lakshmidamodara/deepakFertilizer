-----------------------------------------------------------
--- File Name      : insert_bundle_phases_data.sql
--- Author Name    : Lakshmi Damodara
--- Creation Date  : 02/28/2018
--- Updated on     : 
--- Version        : 1.0
--- Description    : This function inserts data into public.bundle_phases
---                  
--- 
--- 
------------------------------------------------------------

CREATE OR REPLACE FUNCTION insert_bundle_phases_data(p_bundle_id integer, p_phase_id integer)
RETURNS INTEGER AS $$
DECLARE
	l_id INTEGER;
BEGIN
	SELECT id INTO STRICT l_id
	FROM public.bundle_phases AS bun
	WHERE
		bun.bundle_id IS NOT DISTINCT FROM p_bundle_id 
		AND bun.phase_id IS NOT DISTINCT FROM p_phase_id;
		
	RETURN l_id;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			INSERT INTO public.bundle_phases (bundle_id, phase_id)
			VALUES (p_bundle_id, p_phase_id);
			return currval('public.bundle_phases_id_seq');
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Found more than one row in bundles for name %', p_name;
END; $$
LANGUAGE plpgsql