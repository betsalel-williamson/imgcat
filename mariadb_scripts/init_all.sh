#!/bin/bash

# Create the schemas we'll need
cat init/init_db.sql
echo ""; # Add \n between sections

# Load the tables in dependency order
cat init/userdb.tables.sql     # dep: n/a
cat init/posts.tables.sql      # dep: userdb
cat init/comments.tables.sql   # dep: posts
cat init/fpcache.tables.sql    # dep: posts
cat init/actions.tables.sql    # dep: favorites
echo ""; # Add \n between sections

# Order doesn't matter. SPs are checked at runtime, not creation
for filename in init/*.sql; do
	if [[ $filename == "init/init_db.sql" ]]; then
		: # noop skip it
	elif [[ $filename == "init/init_perms.sql" ]]; then
		: # noop skip it
	elif [[ ! $filename =~ ".tables." ]]; then
		cat "$filename";
		echo ""; # Add \n between files
	fi
done
echo ""; # Add \n between sections

# Once all the SPs are created, run perms
# TODO: We can/should put the GRANT permissions in each script
# We just need an envvar, in case people change the user
cat init/init_perms.sql
echo ""; # Add \n between sections