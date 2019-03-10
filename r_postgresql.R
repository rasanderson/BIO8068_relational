# Check that interface works ok with postgresql

library(DBI)
library(RPostgreSQL)
con <- dbConnect(drv = dbDriver("PostgreSQL"),
                 dbname = 'gps_tracking_db', 
                 host = 'localhost', # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
                 port = 5432, # or any other port specified by your DBA
                 user = 'basic_user',
                 password = 'basic_user')



dbListTables(con)

res <- dbSendQuery(con, "SELECT * FROM main.animals;")
animals <- fetch(res)
animals

res <- dbSendQuery(con, "SELECT * FROM lu_tables.lu_species;")
lu_species <- fetch(res)
lu_species

res <- dbSendQuery(con, "SELECT * FROM lu_tables.lu_age_class;")
lu_age_class <- fetch(res)
lu_age_class

# More comprehensive query linking tables
res <- dbSendQuery(con,
                   "SELECT
                       animals.name,
                       animals.sex,
                       lu_age_class.age_class_description,
                       lu_species.species_description
                   FROM
                       lu_tables.lu_age_class,
                       lu_tables.lu_species,
                       main.animals
                   WHERE
                       lu_age_class.age_class_code = animals.age_class_code
                       AND
                       lu_species.species_code = animals.species_code;")
animal_names_spp_ages <- fetch(res)
animal_names_spp_ages



# More comprehensive query linking tables and renaming variables
res <- dbSendQuery(con,
                   "SELECT
                       animals.animals_id AS id,
                       animals.animals_code AS code,
                       animals.name,
                       animals.sex,
                       lu_age_class.age_class_description AS age_class,
                       lu_species.species_description AS species
                   FROM
                       lu_tables.lu_age_class,
                       lu_tables.lu_species,
                       main.animals
                   WHERE
                       lu_age_class.age_class_code = animals.age_class_code
                       AND
                       lu_species.species_code = animals.species_code;")
animal_names_spp_ages <- fetch(res)
animal_names_spp_ages

# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)

#dbWriteTable(con, "mtcars", mtcars)
#dbListTables(con)

# Check and see if dbplyr works; no
con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), 
                      host = "localhost",
                      port = 5432,
                      user = "basic_user",
                      password = "basic_user")
