import type { Handle, redirect } from '@sveltejs/kit';
import { GetUserData, CreateAuthJwt } from '$lib/server/jwtserver.ts';
import { LogInFromRefreshJwt } from '$lib/server/userdb.ts';

export const handle: Handle = async ({ event, resolve }) => {
	let success:bool = false;

	// If we have a valid auth JWT, just copy the data into locals
	const auth = event.cookies.get('imgcat_auth');
	if(auth) {
		const user_data = GetUserData(auth);
		if(user_data) {
			// Happy-path: We have a valid AuthJwt and just need to decode it
			event.locals.logged_in = true;
			event.locals.content_level = 2;
			event.locals.user_id = user_data.user_id;
			event.locals.username = user_data.username;
			event.locals.claims = user_data.claims;
			success = true;
		} else {
			// We have the cookie, but it probably expired
			event.cookies.delete('imgcat_auth', {path:'/'});
		}
	}

	// If that didn't work, try the refresh token
	if(!success) {
		const refresh_jwt = event.cookies.get('imgcat_refresh');
		if(refresh_jwt) {
			const user_id = GetUserData(refresh_jwt)['user_id'];
			if(user_id) {
				const user_data = await LogInFromRefreshJwt(user_id);
				if(user_data) {
					event.locals.logged_in = true;
					event.locals.content_level = 2;
					event.locals.user_id = user_data.user_id;
					event.locals.username = user_data.username;
					event.locals.claims = user_data.claims;
					success = true;

					// Besides setting page access, we also need to save the AuthJwt
					// to avoid a DB hit every pageload.
					// NOTE: Keep this in sync with /src/routes/login/+server.ts
					let auth = CreateAuthJwt(user_data);
					event.cookies.set('imgcat_auth', auth, {
						//domain: process.env.JWT_DOMAIN,
						path: '/',
						httpOnly: true,
						secure: true,
						sameSite: 'strict',
						//maxAge: null - Session cookie
					});
				} else {
					// Probably a server/login error
					event.cookies.delete('imgcat_refresh', {path:'/'});
				}
			} else {
				// Probably a JWT timeout
				event.cookies.delete('imgcat_refresh', {path:'/'});
			}
		}
	}

	// We couldn't read from either JWTs, so we can't log in
	if(!success) {
		event.locals.logged_in = false;
		event.locals.content_level = 2;
	}

	const response = await resolve(event);
	
	return response;
};