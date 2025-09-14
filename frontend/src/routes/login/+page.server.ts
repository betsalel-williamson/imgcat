import 'dotenv/config';

import type { Actions } from './$types';
import { redirect, fail, json } from '@sveltejs/kit';

function GetValidationError(email:string, password:string):string|undefined {
	if(!email)
		return 'Missing email address';
	if(!password)
		return 'Missing password';
	if(typeof email !== 'string')
		return 'Invalid email';
	if(typeof password !== 'string')
		return 'Invalid password';
	if(email.length > 255)
		return 'Invalid email address length';
	if(password.length > 255)
		return 'Invalid email address length';
	// If there's no error, just return void/undefined
}


export const actions:Actions = {
	default: async({ cookies, request, fetch }) => {
		const formData:FormData = await request.formData();
		const email:string = formData.get('email');
		const password:string = formData.get('password');

		let message = GetValidationError(email, password);
		if(message){return {success:false, email, message}}

		// If we specify an IDP server, use that, else do a local request
		const login_response = await fetch((process.env.IDP_SERVER || '') + '/auth/login', {
			method: 'POST',
			headers: {'Content-Type': 'application/json'},
			body: JSON.stringify({
				e: formData.get('email'),
				p: formData.get('password'),
			})
		}).then(r=>r.json());

		if(!login_response.success) {
			return {success:false, email, message:login_response['message']};
		}

		if(login_response['a'] && login_response['r']) {
			// NOTE: Keep this in sync with /src/hooks.server.ts
			// NOTE: Consider NOT setting the auth JWT here, and only creating a refreshJWT,
			// then the hook will run & complete the full login at a seperate time.
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

