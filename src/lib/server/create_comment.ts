import { error } from '@sveltejs/kit';
import { getDbConn } from '$lib/server/dbpool.ts';

export async function CreateComment(data:any):int {
	if(!data.user_id || !data.post_id || !(data.link || data.comment)) {
		console.log("CreateComment missing params");
		console.log(data);
		return null;
	}

	let conn;
	try {
		conn = await getDbConn();
		const response = await conn.query({
			sql:"SELECT Posts.CreateComment(?,?,?,?,?);",
			rowsAsArray: true
		}, [data.user_id, data.post_id, data.reply_to, data.link, data.comment]);

		return response[0][0];
	} catch(e) {
		// If it's a custom error message, we can send it to the browser, otherwise no
		console.log(e);
		if(e['sqlState'] == '45000') {
			error(400, e['sqlMessage'] || 'Unknown error');
		} else {
			error(400, 'Unknown');
		}
	} finally {
		if(conn){await conn.release()}
	}
}