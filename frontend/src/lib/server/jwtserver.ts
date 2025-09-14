import { jwtSign, jwtDecode, JWT_ISS, JWT_AUD } from '$lib/server/jwtcore.ts';

export function ValidateJwtClaim(jwt:string, claim:string):string {
	const decoded = jwtDecode(jwt);
	return (decoded?.claims?.indexOf(claim) >= 0);
}

export function GetUserId(jwt:string):number {
	const decoded = jwtDecode(jwt);
	if(decoded?.sub) {
		return decoded?.sub;
	} else {
		return null;
	}
}

export function GetUserData(jwt:string):any {
	const decoded = jwtDecode(jwt);
	if(decoded) {
		// RefreshJwts don't have username
		let result = {
			user_id: decoded.sub,
			claims: decoded.claims
		};
		// AuthJwts do include the username, but RefreshJws don't care
		if(decoded.du) {
			result['username'] = decoded.du;
		}
		return result;
	} else {
		return null;
	}
}

export function CreateAuthJwt(user_data:any):string|null {
	if(!user_data) return null;

	const dt_sec:number = Date.now() / 1000;
	const data = {
		iss: JWT_ISS,
		aud: JWT_AUD,
		exp: dt_sec + 15*60, //15 min
		sub: user_data['user_id'],
		claims: user_data['claims'],
		// critical client data - stored flat
		// NOTE: DO NOT ABUSE THIS STORAGE
		du: user_data['username'],
	};
	try {
		const jwt = jwtSign(data);
		//console.log(jwtValidate(jwt));
		return jwt;
	} catch(e) {
		console.log(e);
		return null;
	}
}

export function CreateRefreshJwt(user_data:any):string|null {
	if(!user_data) return null;

	const dt_sec:number = Date.now() / 1000;
	const data = {
		iss: JWT_ISS,
		aud: JWT_AUD,
		exp: dt_sec + 14*24*60*60, //2wks
		sub: user_data['user_id'],
		claims: ['refreshJwt']
	};
	try {
		const jwt = jwtSign(data);
		//console.log(jwtValidate(jwt));
		return jwt;
	} catch(e) {
		console.log(e);
		return null;
	}
}
