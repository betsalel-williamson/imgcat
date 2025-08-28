
import mariadb from 'mariadb';
import 'dotenv/config';
import { createHash, randomBytes } from 'crypto';
import { error } from '@sveltejs/kit';

// NOTE: If you're leaking pool connections, it's b/c "vite dev" will
// watch for changes & reload files dynamically. But it will leak the pool.
const db = mariadb.createPool({
	idleTimeout: 60, //sec
	connectionLimit: 25,
	acquireTimeout: 1000,
	connectTimeout: 250,
	queryTimeout: 2000,
	leakDetectionTimeout: 10000,
	host: (process.env.DB_USERDB_HOST),
	port: Number(process.env.DB_USERDB_PORT),
	database: (process.env.DB_USERDB_DB),
	user: process.env.DB_USERDB_USER,
	password: process.env.DB_USERDB_PASS
});

export async function LogIn(user_or_email:string, password:string):any {
	let conn;
	try {
		conn = await db.getConnection();
		const response = await db.query({
			sql:"CALL UserDB.GetLoginData(UserDB.GetLoginId(?,?));"
		}, [user_or_email, password]);

		if(!response) {return null}

		let result = {};

		if(response[0]?.length > 0) {
			result['user_id'] = response[0][0]['id'];
			result['username'] = response[0][0]['username'];
			result['content_level'] = response[0][0]['content_level'];
			result['claims'] = [];

			for(let i in response[1]) {
				result['claims'].push(response[1][i]);
			}
		}

		return result;
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(401, e['sqlMessage'] || 'Unknown error');
		} else {
			error(401, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}


export async function LogInFromRefreshJwt(user_id:int):any {
	let conn;
	try {
		conn = await db.getConnection();
		const response = await db.query({
			sql:"CALL UserDB.GetLoginData(?);"
		}, [user_id]);

		if(!response) {return null}

		let result = {};

		if(response[0]?.length > 0) {
			result['user_id'] = response[0][0]['id'];
			result['username'] = response[0][0]['username'];
			result['content_level'] = response[0][0]['content_level'];
			result['claims'] = [];

			for(let i in response[1]) {
				result['claims'].push(response[1][i]);
			}
		}

		return result;
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(401, e['sqlMessage'] || 'Unknown error');
		} else {
			error(401, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}


export async function CreateAccount(fd:any):int|string {
	// TODO: LOTS MORE VALIDATION
	if(!fd.email)
		return 'Missing email address';
	if(!fd.username)
		return 'Missing username';
	if(!fd.location)
		return 'Missing location';
	if(!fd.age)
		return 'Missing age';
	if(!fd.password)
		return 'Missing password';
	
	if(typeof fd.email !== 'string')
		return 'Invalid email';
	if(typeof fd.username !== 'string')
		return 'Invalid username';
	if(typeof fd.location !== 'string')
		return 'Invalid location';
	if(typeof fd.age !== 'number')
		return 'Invalid age';
	if(typeof fd.password !== 'string')
		return 'Invalid password';

	if(fd.email.length > 255)
		return 'Email address can only be 255 characters long';
	if(fd.username.length > 40)
		return 'Username can only be 40 characters long';
	if(fd.location.length > 2)
		return 'Location must be a 2-digit code';
	if(fd.password.length > 255)
		return 'Password can only be 255 characters long';

	// OK, validations complete
	let conn;
	try {
		conn = await db.getConnection();
		const response = await db.query({
			sql:"SELECT CreateAccount(?,?,?,?,?);",
			rowsAsArray: true
		}, [fd.email, fd.password, fd.username, fd.location, fd.age]).then((d)=>{
			if(d[0]?.length > 0) {
				return d[0][0];
			} else {
				return null;
			}
		});

		return response;
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(401, e['sqlMessage'] || 'Unknown error');
		} else {
			error(401, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}


export async function IsUsernameFree(username:string):bool {
	let conn;
	try {
		conn = await db.getConnection();
		const response = await db.query({
			sql:"SELECT IsUsernameFree(?);",
			rowsAsArray: true
		}, [username]);

		if(!response) {return null}

		console.log("Result of IsUsernameFree()");
		console.log(response);

		let result = {};
		return result;
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(401, e['sqlMessage'] || 'Unknown error');
		} else {
			error(401, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}