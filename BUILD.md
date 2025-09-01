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

## Run Dev Build
1. Run "npm run dev"

## Run Node Build
1. "npm ci --omit dev"
2. "npm run build"
3. "export ORIGIN=https://example.com"
	* See https://svelte.dev/docs/kit/adapter-node for other configuration 
4. "node build"
