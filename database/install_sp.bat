echo Creating postgres database cct and its objects
:: Below is for dropping and creating the database
set PGPASSWORD=%DATABASE_PWD%

psql --file insert_activity_data_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_activities_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_activity_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_bundles_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_contractor_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_location_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_phases_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_portfolios_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_portfolio_projects_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_project_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_units_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file update_baseline_activities.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file update_baseline_activity_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file update_production_activities.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file update_production_activity_data.sql --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_bundle_activities_data.sql  --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
psql --file insert_activity_dependencies_data.sql  --echo-errors --dbname=cct --host=%DATABASE_HOSTNAME% --port=%DATABASE_PORT% --username=%DATABASE_USER% 
exit
