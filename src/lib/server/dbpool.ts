
import mariadb from 'mariadb';
import 'dotenv/config';
import { error } from '@sveltejs/kit';

// NOTE: If you're leaking pool connections, it's b/c "vite dev" will
// watch for changes & reload files dynamically. But it will leak the pool.
const db = mariadb.createPool({
	idleTimeout: 60, //sec
	connectionLimit: 100,
	acquireTimeout: 1000,
	connectTimeout: 250,
	queryTimeout: 2000,
	leakDetectionTimeout: 10000,
	host: (process.env.DB_APP_HOST),
	port: Number(process.env.DB_APP_PORT),
	database: (process.env.DB_APP_DB),
	user: process.env.DB_APP_USER,
	password: process.env.DB_APP_PASS
});


export async function getDbConn() {
	return db.getConnection();
}