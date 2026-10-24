COPY passengers (p_id, is_survived, p_class, name, surname, title, sex, age, sib_sp, par_ch, family_size, ticket, fare, cabin, embarked)
FROM 'C:/Users/HOME/OneDrive/Documents/titanic_transformed.csv'
WITH (FORMAT csv, HEADER true, NULL '');

-- ERROR: Database load issue: could not open file "C:/Users/.../titanic_transformed.csv" for reading: Permission denied.

/*
Steps taken to reload data:

1. Drop the existing database:
   DROP DATABASE IF EXISTS passengers;

2. Recreate the database and load table schemas by running:
   - 1_create_database.sql
   - 2_create_table.sql

3. Open pgAdmin and run the following command in the PSQL Tool:

   \copy passengers FROM 'C:/Users/HOME/OneDrive/Documents/titanic_transformed.csv' WITH (FORMAT csv, HEADER true, NULL '');
*/