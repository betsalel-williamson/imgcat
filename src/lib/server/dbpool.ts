
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
}).then((pool)=>{
	// Test a query to see if it work
	const conn = pool.getConnection();
	const res = conn.query('SELECT Posts.GetFilename()');
	if(res[0]) {
		return pool;
	} else {
		console.log('ERROR: Could not query DB using the main connection pool, there may be a misconfiguration');
		return pool;
	}
}).catch((e)=>{
	console.log('Error creating the main app pool, using variables:');
	console.log('Host: ', process.env.DB_APP_HOST || '- null -');
	console.log('User: ', process.env.DB_APP_USER || '- null -');
	console.log('Pass: ', process.env.DB_APP_PASS?'- exists -':'- null -' );
});

const userDB = mariadb.createPool({
	idleTimeout: 60, //sec
	connectionLimit: 25,
	acquireTimeout: 100,
	connectTimeout: 100,
	queryTimeout: 100,
	leakDetectionTimeout: 1000,
	host: (process.env.DB_USERDB_HOST),
	port: Number(process.env.DB_USERDB_PORT),
	database: (process.env.DB_USERDB_DB),
	user: process.env.DB_USERDB_USER,
	password: process.env.DB_USERDB_PASS
}).then((pool)=>{
	// Test a query to see if it work
	const conn = pool.getConnection();
	const res = conn.query("SELECT UserDB.IsUsernameFree('whatever')");
	if(res[0]) {
		return pool;
	} else {
		console.log('ERROR: Could not query DB using the UserDB connection pool, there may be a misconfiguration');
		return pool;
	}
}).catch((e)=>{
	console.log('Error creating the user login pool, using variables:');
	console.log('Host: ', process.env.DB_USERDB_HOST || '- null -');
	console.log('User: ', process.env.DB_USERDB_USER || '- null -');
	console.log('Pass: ', process.env.DB_USERDB_PASS?'- exists -':'- null -' );
});

export async function getDbConn() {
	return db.getConnection();
}

export async function getUserDbConn() {
	return userDB.getConnection();
}

export async function query(sql:string, args:any, handler:(response:any)=>any) {
	return db.getConnection()
	.then((conn)=>{
		return conn.query(sql, args)
		.catch((e)=>{
			console.log(e);
			return null;
		})
		.finally(()=>{conn?.release()});
	})
	.then((response)=>{
		if(response?.length > 0) {
			return handler(response);
		} else {
			return null;
		}
	})
	.catch((e)=>{
		// NOTE: It is unsafe to log e['sql'] or e itself, because both print paramaters (aka: user passwords)
		if(e['sqlState'] == '45000') {
			error(500, e['sqlMessage'] || 'Unknown error');
		} else if(e['errno'] == 1226) {
			console.log(e);
			error(500, 'The server is temporarially overloaded, please wait a moment and try again');
		} else {
			console.log(e);
			error(500, 'Unknown server error');
		}
	});
}

export async function array(sql:string, args:any, handler) {
	return db.getConnection()
	.then((conn)=>{
		return conn.query({sql:sql, rowsAsArray:true}, args)
		.catch((e)=>{
			console.log(e);
			return null;
		})
		.finally(()=>{conn?.release()});
	})
	.then((response)=>{
		if(response?.length > 0) {
			return handler(response);
		} else {
			return null;
		}
	})
	.catch((e)=>{
		// NOTE: It is unsafe to log e['sql'] or e itself, because both print paramaters (aka: user passwords)
		if(e['sqlState'] == '45000') {
			error(500, e['sqlMessage'] || 'Unknown error');
		} else if(e['sqlState'] == 'HY000') {
			console.log(e);
			error(500, 'The server is temporarially overloaded, please wait a moment and try again');
		} else {
			console.log(e['sqlMessage']);
			error(500, 'Unknown server error');
		}
	});
}