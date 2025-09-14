import type { ServerPageLoad } from './$types';
import { redirect } from '@sveltejs/kit';

import { GetRecentPage } from '$lib/server/posts.ts';

export const load: ServerPageLoad = async({ locals }) => {
	if(!locals.logged_in){redirect(307, '/login')}

	let posts = GetRecentPage(locals.content_level, 0, 50);

	return {
		posts: posts
	};
}