import { error } from '@sveltejs/kit';
import { array } from '$lib/server/dbpool.ts';


// DEPRECATED - This comment replies (inside Comment) use this via a form, but
// CommentBox uses remote functions (preferred). All of it needs to be chunked
// into a common control that applies to any level of nesting & code reuse
export async function CreateComment(data:any):int {
	if(!data.user_id || !data.post_id || !(data.link || data.comment)) {
		//console.log("CreateComment missing params");
		//console.log(data);
		return null;
	}

	return array(
		"SELECT Posts.CreateComment(?,?,?,?,?);",
		[data.user_id, data.post_id, data.reply_to, data.link, data.comment],
		(r)=>r[0][0]
	);
}