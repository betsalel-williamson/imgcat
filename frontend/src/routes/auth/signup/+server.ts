import { json, error, redirect } from '@sveltejs/kit';
import { CreateAuthJwt, CreateRefreshJwt, GetUserData } from '$lib/server/jwtserver.ts';
import { LogIn, CreateAccount } from '$lib/server/userdb.ts';

export async function GET(){
	// Nobody should be doing a GET & we want to hide this URL from anyone trying it
	return error(404);
}

export async function POST({ request, clientAddress }) {
	// TODO: These are printing to the console/stdout, but figure out how to log to a dedicated file

	const dt = new Date().toISOString();
	const data = await request.json();
	
	const new_user_id = await CreateAccount(data);
	console.log(dt + ", New account, " + new_user_id + ", " + data.username + ", " + data.location);

	///////////////////////////////////////////////////
	// TODO: DO NOT DO THIS...
	// Redirect to /auth/login and forward the username/password
	// Because any changes to the Login flow will break here
	/////////////////////////////////////////////////////

	// TODO: This should be stored as request.remoteAddress,
	// but it needs env vars to set headers as expected:
	// https://svelte.dev/docs/kit/adapter-node#Environment-variables-ADDRESS_HEADER-and-XFF_DEPTH
	//let client_ip = clientAddress || '::ffff:127.0.0.1';

	return json({
		success:true,
		new_user_id
	});
	//redirect(303, '/login');

	//const user_data = await LogIn(data.email, data.password);
	//if(user_data === null){
	//	console.log(dt+', Login Failure, Incorrect password, '+email);
	//	return json({success:false, message:"Incorrect password"})
	//}
	//
	//// Now that we've got user_data, we need to sign a JWT and return it
	//console.log(dt+', Login Success, '+data.email+', '+user_data['user_id']);
	//return json({
	//	success:true,
	//	a: CreateAuthJwt(user_data),
	//	r: CreateRefreshJwt(user_data)
	//});
}