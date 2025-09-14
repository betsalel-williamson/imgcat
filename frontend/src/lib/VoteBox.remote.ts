import { number as req_number, strictTuple as req_tuple } from 'valibot';
import { error } from '@sveltejs/kit';
import { query } from '$app/server';
import { getDbConn } from '$lib/server/dbpool.ts';

// NOTE: This relies on Svelte Remote Functions, which is EXPERIMENTAL
// But they seem custom-designed to support server-side functions for components
// See more: https://svelte.dev/docs/kit/remote-functions
// 

export const getViewVotes = query(req_number(), async (post_id) => {
	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"CALL Posts.GetViewVotes(?);"
			}, [post_id])
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


export const getMyVote = query(req_tuple([req_number(), req_number()]), async (args) => {
	const post_id = args[0];
	const user_id = args[1];
	
	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"SELECT Posts.GetMyVote(?,?);",
				rowsAsArray: true
			}, [post_id, user_id])
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

export const setMyVote = query(req_tuple([req_number(), req_number(), req_number()]), async (args) => {
	const post_id = args[0];
	const user_id = args[1];
	const vote_type = args[2];

	let conn;
	try {
		conn = await getDbConn();
		return conn.query({
				sql:"SELECT Posts.SetVote(?,?,?);",
				rowsAsArray: true
			}, [post_id, user_id, vote_type])
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