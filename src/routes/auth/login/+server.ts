import { json, error } from '@sveltejs/kit';
import { CreateAuthJwt, CreateRefreshJwt, GetUserData } from '$lib/server/jwtserver.ts';
import { LogIn } from '$lib/server/userdb.ts';

export async function GET(){
	// Nobody should be doing a GET & we want to hide this URL from anyone trying it
	return error(404);
}

export async function POST({ request, clientAddress }) {
	// NOTE: Earlier versions would return errors as: error(403, "Validation error"), which is more streamlined
	//       But it returned: {status:403, message:'Forbidden', body:{message:'Validation Error'},
	//       which required a two-step promise handler, and was FAR more complicated on the client-side
	//       We're now always returning 200, with a success flag

	// TODO: These are printing to the console/stdout, but figure out how to log to a dedicated file

	const dt = new Date().toISOString();
	const data = await request.json();
	
	const email = data['e']?.toLowerCase();
	const password = data['p'];
	if(!email || !password) {
		console.log(dt+', Login Failure, POST data in an unexpected format');
		if(data['p']){data['p']='***HIDDEN***'}
		console.log(data);
		// NOTE: Slightly different user-error on purpose
		// This should never occur unless someone's doing shenanigans...
		// And it's probably us, changing the FE w/o updating the BE.  :-[
		return json({success:false, message:"Missing data"});
	}

	// TODO: Thist should be stored as request.remoteAddress,
	// but it needs env vars to set headers as expected:
	// https://svelte.dev/docs/kit/adapter-node#Environment-variables-ADDRESS_HEADER-and-XFF_DEPTH
	//let client_ip = clientAddress || '::ffff:127.0.0.1';

	const user_data = await LogIn(email, password);
	if(user_data === null){
		console.log(dt+', Login Failure, Incorrect password, '+email);
		return json({success:false, message:"Incorrect password"})
	}

	// Now that we've got user_data, we need to sign a JWT and return it
	console.log(dt+', Login Success, '+email+', '+user_data['user_id']);
	return json({
		success:true,
		a: CreateAuthJwt(user_data),
		r: CreateRefreshJwt(user_data)
	});
}