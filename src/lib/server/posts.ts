
//import mariadb from 'mariadb';
//import 'dotenv/config';
import { error } from '@sveltejs/kit';

import { query } from '$lib/server/dbpool.ts';



export async function GetMyPosts(user_id:number, pg_num:number, pg_size:number):any {
	if(!user_id){return null}

	return query(
		"CALL Posts.GetMyPosts(?,?,?);",
		[user_id, (pg_num*pg_size) || 0, pg_size || 50],
		(r)=>r[0]
	);
}

export async function GetMyFavs(user_id:number, pg_num:number, pg_size:number):any {
	if(!user_id){return null}

	return query(
		"CALL Posts.GetMyFavs(?,?,?);",
		[user_id, (pg_num*pg_size) || 0, pg_size || 50],
		(r)=>r[0]
	);
}

export async function GetRecentPage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}

	return query(
		"CALL Posts.GetRecentPage(?,?,?);",
		[content_level, (pg_num*pg_size) || 0, pg_size || 50],
		(r)=>r[0]
	);
}

export async function GetViralPage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}

	return query(
		"CALL Posts.GetViralPage(?,?,?);",
		[content_level, (pg_num*pg_size) || 0, pg_size || 50],
		(r)=>r[0]
	);
}

export async function GetHomePage(content_level:number, pg_num:number, pg_size:number):any {
	if(!content_level){return null}

	return query(
		"CALL Posts.GetHomePage(?,?,?);",
		[content_level, (pg_num*pg_size) || 0, pg_size || 50],
		(r)=>r[0]
	);
}

export async function GetPost(post_link:string, content_level:number, user_id:number):any {
	if(!post_link || !content_level){return null}

	return query(
		"CALL Posts.GetPost(?,?,?,true);",
		[post_link, content_level, user_id],
		(r)=>{
			let result = r[0][0];
			// Fold the second resultset into img=[]
			result['img'] = r[1];
			return result;
		}
	);
}

