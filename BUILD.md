# Build Process

## Software Requirements
* MariaDB (Tested on 10.11)
* Node (Tested on 22.13.1)
* S3 blob storage (Using Cloudflare R2)

## Development Requirements
* sveltejs
* sveltejs/kit
* vite

## Initial Setup
1. Install MariaDB, Node, and setup an S3 cloud provider
2. Follow /mariadb_scripts/readme.txt
	* NOTE: init_users.sql must be manually edited, to add passwords
3. Use TEMPLATE.env as a baseline
4. Add both FE users to the .env file
5. Setup certs for JWT validation, add path to .env
	* openssl genpkey -algorithm ed25519 -out id_jwtsign.pvt
	* openssl pkey -in id_jwtsign.pvt -pubout -out id_jwtsign.pub
6. Add S3 credentials to .env file

## Docker build

The following instructions allow you to set up the system without needing to install software other than Docker. Note that if you need to make changes to the database via the `mariadb_scripts` folder, you will need to delete the contents of `db_data` so that the next run of the `db` docker container will re-trigger the init sequence.

1. Install Docker
   * Windows users want to install WSL ([instructions](https://learn.microsoft.com/en-us/windows/wsl/install)) and [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   * Linux users should install Docker using the package manager of their choice
2. Clone the repository
3. Set up a Cloudflare R2 bucket
   1. Create a Cloudflare account
   2. Create an r2 bucket
   3. Create a User API token using the S3 api
   4. Make your bucket public with a development url
4. Create certs for JWT validation
	* `openssl genpkey -algorithm ed25519 -out id_jwtsign.pvt`
	* `openssl pkey -in id_jwtsign.pvt -pubout -out id_jwtsign.pub4`. Make necessary config changes
5. Edit config files as needed
   1. In `mariadb_scripts/init/ZZY_init_users.sql`, create and update passwords for the database users
   2. Fill out `TEMPLATE.env`
   3. Move the certs created in step 3 to `docker/common`
   4. Rename `TEMPLATE.env` to `dev.env`
6. Start the containers with docker compose
	* `docker compose up -d`


## Run Dev Build
1. Run "npm run dev"

## Run Node Build
1. "npm ci --omit dev"
2. "npm run build"
3. "export ORIGIN=https://example.com"
	* See https://svelte.dev/docs/kit/adapter-node for other configuration 
4. "node build"
