-----------------------------------------------------------
--- File Name      : insert_activities_data.sql
--- Author Name    : Lakshmi Damodara
--- Creation Date  : 02/28/2018
--- Updated on     : 
--- Version        : 1.0
--- Description    : This function inserts  data into public.activities
---                  
--- 
--- 
------------------------------------------------------------

CREATE OR REPLACE FUNCTION insert_activities_data(p_name text, p_unit_id integer, p_contractor_name text,
													p_unit_cost double precision, p_total_planned_hours integer,
													p_phase_id integer, p_project_id integer,
													p_total_planned_units double precision, p_planned_start date,
													p_planned_end date, p_unit_name text,
													p_hourly_cost double precision,
													p_total_planned_resources integer, p_external_id text,
													p_is_deleted integer, p_is_milestone integer, p_material_id integer,
													p_material_quantity integer,
													p_material_status text, p_shift_hours integer, p_shifts integer)
RETURNS INTEGER AS $$
DECLARE 
	l_contractor_id INTEGER;
	l_activity_id INTEGER;
BEGIN
	SELECT id into l_contractor_id 
	  FROM public.contractors AS con
	 WHERE
	  upper(con.name) IS NOT DISTINCT FROM upper(p_contractor_name);

	SELECT id INTO STRICT l_activity_id
	FROM public.activities AS act
	WHERE
		UPPER(act.name) IS NOT DISTINCT FROM UPPER(p_name)
		AND act.contractor_id IS NOT DISTINCT FROM l_contractor_id
        AND act.unit_id IS NOT DISTINCT FROM p_unit_cost
		AND act.unit_cost IS NOT DISTINCT FROM p_hourly_cost
		AND act.total_planned_hours IS NOT DISTINCT FROM p_total_planned_hours
		AND act.project_id IS NOT DISTINCT FROM p_project_id
		AND act.phase_id IS NOT DISTINCT FROM p_phase_id
		AND act.total_planned_units IS NOT DISTINCT FROM p_total_planned_units
		AND act.planned_start IS NOT DISTINCT FROM p_planned_start
		AND act.planned_end IS NOT DISTINCT FROM p_planned_end
		AND act.unit_name IS NOT DISTINCT FROM p_unit_name
		AND act.total_planned_resources IS NOT DISTINCT FROM p_total_planned_resources
		AND act.external_id IS NOT DISTINCT FROM p_external_id
		AND act.is_deleted IS NOT DISTINCT FROM p_is_deleted
		AND act.is_milestone IS NOT DISTINCT FROM p_is_milestone
		AND act.material_id IS NOT DISTINCT FROM p_material_id
		AND act.material_quantity IS NOT DISTINCT FROM p_material_quantity
		AND act.material_status IS NOT DISTINCT FROM p_material_status
		AND act.shift_hours IS NOT DISTINCT FROM p_shift_hours
		AND act.shifts IS NOT DISTINCT FROM p_shifts
		ORDER BY id;

		RETURN l_activity_id;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				INSERT INTO public.activities (name, unit_id, contractor_id,
												unit_cost, total_planned_hours,
												phase_id, project_id,
												total_planned_units, planned_start,
												planned_end, unit_name,
												hourly_cost, total_planned_resources,
												external_id, is_deleted, is_milestone,
												material_id, material_quantity,
												material_status, shift_hours, shifts)
				VALUES (p_name, p_unit_id, l_contractor_id, p_unit_cost, p_total_planned_hours,
						p_phase_id, p_project_id, p_total_planned_units, p_planned_start,
						p_planned_end, p_unit_name, p_hourly_cost,
						p_total_planned_resources, p_external_id, p_is_deleted, p_is_milestone,
						p_material_id, p_material_quantity, p_material_status, 
						p_shift_hours, p_shifts);

				RETURN CURRVAL('public.activities_id_seq');
			WHEN TOO_MANY_ROWS THEN
				RAISE EXCEPTION 'Found more than one row in activities for name %', p_name;
END; $$
LANGUAGE plpgsql;

