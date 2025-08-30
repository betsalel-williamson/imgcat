
=== Step 1 ===
init_users.sql needs to be edited, adding your passwords, then run like so:
> mariadb -h [your host] -u [admin user] -p < init_users.sql
It'll prompt for your mariadb root password, and create 4 users we'll need

=== Step 2 ===
To setup the database run:
> ./init_all.sh | mariadb -h [your host] -u [admin user] -p
It'll prompt for your password and apply the initial setup


NOTE: This should be automated. I'm just so far behind.
  Generate 4 random passwords
  Create envvars for them
  Pass them into init_users.sql
  Pass them into init_all.sql
  Generate the .env template with those PWs filled in

Once this is done, we can move GRANT statements into each routine,
where it belongs, for better maintainability
