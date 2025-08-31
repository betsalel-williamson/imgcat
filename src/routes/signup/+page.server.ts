import 'dotenv/config';

import type { PageServerLoad, Actions } from './$types';
import { redirect, fail, json } from '@sveltejs/kit';


function GetValidationError(fd:any):string|undefined {
	if(!fd.email)
		return 'Missing email address';
	if(!fd.username)
		return 'Missing username';
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
	if(fd.password.length > 255)
		return 'Password can only be 255 characters long';
	// If there's no error, just return void/undefined
}


export const load: PageServerLoad = async({ locals }) => {
	return locals;
}


export const actions:Actions = {
	default: async({ cookies, request, fetch }) => {
		const fd = await request.formData().then((fd)=>{
			return {
				email: fd.get('email'),
				username: fd.get('username'),
				location: fd.get('country'),
				age: parseInt(fd.get('age')),
				password: fd.get('password')
			};
		});

		let message = GetValidationError(fd);
		if(message){return {success:false, message}}

		// If we specify an IDP server, use that, else do a local request
		const signup_response = await fetch((process.env.IDP_SERVER || '') + '/auth/signup', {
			method: 'POST',
			headers: {'Content-Type': 'application/json'},
			body: JSON.stringify(fd)
		}).then(r=>r.json());

		console.log(signup_response)

		// Display an error message, if needed
		if(!signup_response.success) {
			return {success:false, message:signup_response['message']};
		}

		// If we created an account, use this data to now log in
		const login_response = await fetch((process.env.IDP_SERVER || '') + '/auth/login', {
			method: 'POST',
			headers: {'Content-Type': 'application/json'},
			body: JSON.stringify({
				e:fd.email,
				p:fd.password
			})
		}).then(r=>r.json());

		// TODO: This needs code reuse with /login

		if(login_response['a'] && login_response['r']) {
			// Before we create cookies & redirect, we want to prime the security mechanism,
			// so (hopefully) it's recached before the user needs it.
			// REMOVED: This was crashing things
			//const districts = GetUserData(login_response['a']).districts;
			//primeSecurity(districts);

			cookies.set('imgcat_auth', login_response['a'], {
				//domain: process.env.JWT_DOMAIN,
				path: '/',
				httpOnly: true,
				secure: true,
				sameSite: 'strict',
				//maxAge: null - Session cookie
			});

			cookies.set('imgcat_refresh', login_response['r'], {
				//domain: process.env.JWT_DOMAIN,
				path: '/',
				httpOnly: true,
				secure: true,
				sameSite: 'strict',
				maxAge: 60*60*24 // 24hrs
			});

			// You're logged in, so redirect to home
			// TODO: Capture the URL they were accessing before login & go there instead
			redirect(302, '/');
		}
	}
}




