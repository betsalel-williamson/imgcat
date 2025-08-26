
//import mariadb from 'mariadb';
//import 'dotenv/config';
import { error } from '@sveltejs/kit';

import { getDbConn } from '$lib/server/dbpool.ts';



export async function GetMyPosts(user_id:number, pg_num:number, pg_size:number):any {
	if(!user_id){return null}
	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"CALL Posts.GetMyPosts(?,?,?);"
		}, [user_id, (pg_num*pg_size) || 0, pg_size || 50]);

		if(!response) {return null}

		return response[0];
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


export async function GetMyFavs(user_id:number, pg_num:number, pg_size:number):any {
	if(!user_id){return null}
	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"CALL Posts.GetMyFavs(?,?,?);"
		}, [user_id, (pg_num*pg_size) || 0, pg_size || 50]);

		if(!response) {return null}

		return response[0];
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


export async function GetRecentPage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}
	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"CALL Posts.GetRecentPage(?,?,?);"
		}, [content_level, (pg_num*pg_size) || 0, pg_size || 50]);

		if(!response) {return null}

		return response[0];
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

export async function GetViralPage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}
	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"CALL Posts.GetViralPage(?,?,?);"
		}, [content_level, (pg_num*pg_size) || 0, pg_size || 50]);

		if(!response) {return null}

		return response[0];
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

export async function GetHomePage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}
	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"CALL Posts.GetHomePage(?,?,?);"
		}, [content_level, (pg_num*pg_size) || 0, pg_size || 50]);

		if(!response) {return null}

		return response[0];
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


export async function GetPost(post_link:string, content_level:number, user_id:number):any {
	if(!post_link || !content_level){return null}

	let conn;
	try {
		conn = await getDbConn();
		//await conn.query("DO Posts.SetView(?,?);", [post_id, user_id]);
		const response = await conn.query({
			sql:"CALL Posts.GetPost(?,?,?,true);"
		}, [post_link, content_level, user_id]);

		if(response[0]?.length > 0){
			let result = response[0][0];
			// Fold the second resultset into img=[]
			result['img'] = response[1];
			return result;
		} else {
			return null;
		}
		/*
		if(response[0]?.length > 0){
			let result = response[0][0];
			// Fold the second resultset into img=[]
			result['img'] = response[1];

			// Grab everything else with async promises
			await conn.query('DO Posts.SetView(?,?);', [post_id, user_id]);
			
			result['viewvote'] = conn.query({
				sql:"CALL Posts.GetViewVoteCount(?);"
			}, [post_id]).then((r) => {
				if(r[0]?.length > 0) {
					return r[0][0];
				} else {
					return null;
				}
			});

			//result['comments'] = conn.query({
			//	sql:"CALL Posts.GetPostComments(?);"
			//}, [post_id]).then((r) => {
			//	if(r[0]?.length > 0) {
			//		return r[0];
			//	} else {
			//		return null;
			//	}
			//});

			// If they're logged in, check other things
			//if(user_id) {
			//	result['myvote'] = conn.query({
			//		sql:"SELECT Posts.GetMyVote(?,?);",
			//		rowsAsArray: true
			//	}, [post_id, user_id]).then((r) => {
			//		if(r[0]?.length > 0) {
			//			return r[0][0];
			//		} else {
			//			return null;
			//		}
			//	});
			//}

			return result;	
		} else {
			return null;
		}
		*/
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(400, e['sqlMessage'] || 'Unknown error');
		} else {
			error(500, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}

