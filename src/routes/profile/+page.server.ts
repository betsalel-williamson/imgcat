import type { ServerPageLoad } from './$types';
import { redirect } from '@sveltejs/kit';

export const load: ServerPageLoad = async({ locals }) => {
	if(!locals.logged_in){redirect(307, '/login')}

	return locals;
}
