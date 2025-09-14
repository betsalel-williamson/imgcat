import { json, error } from '@sveltejs/kit';
import { IsUsernameFree } from '$lib/server/userdb.ts';

export async function GET(){
	// Nobody should be doing a GET & we want to hide this URL from anyone trying it
	return error(404);
}

export async function POST({ request, clientAddress }) {
	// TODO: Verify this works as expected
	// https://svelte.dev/docs/kit/adapter-node#Environment-variables-ADDRESS_HEADER-and-XFF_DEPTH
	let client_ip = clientAddress || '::ffff:127.0.0.1';
	// TODO: Rate-limiting things...

	const data = await request.json();
	if(data?.username) {
		return json({success:true, is_free:IsUserNameFree(data?.username)});
	}
}