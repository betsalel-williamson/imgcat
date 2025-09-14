import {
	number as req_number,
	string as req_string,
	boolean as req_bool,
	nullable as req_nullable,
	strictTuple as req_tuple
} from 'valibot';
import { error } from '@sveltejs/kit';
import { query } from '$app/server';
import { getDbConn } from '$lib/server/dbpool.ts';

// NOTE: This relies on Svelte Remote Functions, which is EXPERIMENTAL
// But they seem custom-designed to support server-side functions for components
// See more: https://svelte.dev/docs/kit/remote-functions
// 


export const setPostVisibility = query(req_tuple([req_number(), req_number(), req_bool()]), async (args) => {
	const user_id:number = args[0];
	const post_id:number = args[1];
	const is_public:bool = args[2];

	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"CALL Posts.SetPostPublic(?,?,?);"
			}, [user_id, post_id, is_public])
			.then((r)=>{
				if(r[0]?.length > 0) {
					return true;
				} else {
					return null;
				}
			})
			.catch((e)=>{
				console.log(e);
				return null;
			});
	} catch(e) {
		console.log(e); // NOTE: Logs to server, not client
		error(500, 'Data error');
	} finally {
		if(conn){await conn.release()}
	}
});


export const isFavPost = query(req_tuple([req_number(), req_number()]), async (args) => {
	const user_id = args[0];
	const post_id = args[1];

	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"SELECT Actions.IsFavPost(?,?);",
				rowsAsArray: true
			}, [user_id, post_id])
			.then((r)=>{
				if(r[0]?.length > 0) {
					return r[0][0];
				} else {
					return null;
				}
			})
			.catch((e)=>{
				console.log(e);
				return null;
			});
	} catch(e) {
		console.log(e); // NOTE: Logs to server, not client
		error(500, 'Data error');
	} finally {
		if(conn){await conn.release()}
	}
});



//export const isFavMedia = query(req_tuple([req_number(), req_number()]), async (args) => {
//	const user_id = args[0];
//	const media_id = args[1];
//
//	let conn;
//	try {
//		conn = await getDbConn();
//		return conn.query({
//				sql:"SELECT Posts.IsFavMedia(?,?);",
//				rowsAsArray: true
//			}, [user_id, media_id])
//			.then((r)=>{
//				if(r[0]?.length > 0) {
//					return r[0][0];
//				} else {
//					return null;
//				}
//			})
//			.catch((e)=>{
//				console.log(e);
//				return null;
//			});
//	} catch(e) {
//		console.log(e); // NOTE: Logs to server, not client
//		error(500, 'Data error');
//	} finally {
//		if(conn){await conn.release()}
//	}
//});



export const toggleFavPost = query(req_tuple([req_number(), req_number(), req_nullable(req_string())]), async (args) => {
	const user_id = args[0];
	const post_id = args[1];
	const folder_name = args[2];

	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"SELECT Actions.ToggleFavPost(?,?,?);",
				rowsAsArray: true
			}, [user_id, post_id, folder_name])
			.then((r)=>{
				if(r[0]?.length > 0) {
					return r[0][0];
				} else {
					return null;
				}
			})
			.catch((e)=>{
				console.log(e);
				return null;
			});
	} catch(e) {
		console.log(e); // NOTE: Logs to server, not client
		error(500, 'Data error');
	} finally {
		if(conn){await conn.release()}
	}
});


//export const toggleFavMedia = query(req_tuple([req_number(), req_number(), req_string()]), async (args) => {
//	const user_id = args[0];
//	const media_id = args[1];
//	const folder_name = args[2];
//	
//	let conn;
//	try {
//		conn = await getDbConn();
//		return conn.query({
//				sql:"SELECT Posts.ToggleFavMedia(?,?,?);",
//				rowsAsArray: true
//			}, [user_id, media_id, folder_name])
//			.then((r)=>{
//				if(r[0]?.length > 0) {
//					return r[0][0];
//				} else {
//					return null;
//				}
//			})
//			.catch((e)=>{
//				console.log(e);
//				return null;
//			});
//	} catch(e) {
//		console.log(e); // NOTE: Logs to server, not client
//		error(500, 'Data error');
//	} finally {
//		if(conn){await conn.release()}
//	}
//});
