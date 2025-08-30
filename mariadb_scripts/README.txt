
=== Step 1 ===
To setup the database run:
> ./init_all.sh | mariadb -h [your host] -u [admin user] -p
It'll prompt for your password and apply the initial setup

=== Step 2 ===
init_users.sql needs to be edited, and passwords added then run:
> ./init_users.sh | mariadb -h [your host] -u [admin user] -p

NOTE: This is manual, but should be automated. I'm just so far behind.
  Generate 4 random passwords
  Pass them into init_users.sql
  Create GRANT statements
  Generate the .env template with those PWs filled in
Once this is done, move it after init_db.sql, which allows us to
do GRANT statements inline with the source, for maintainability
