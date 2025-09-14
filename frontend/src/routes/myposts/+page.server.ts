import type { ServerPageLoad } from './$types';
import { redirect } from '@sveltejs/kit';

import { GetMyPosts } from '$lib/server/posts.ts';

export const load: ServerPageLoad = async({ locals }) => {
	if(!locals.logged_in){redirect(307, '/login')}

	let posts = GetMyPosts(locals.user_id, 0, 50);

	return {
		posts: posts
	};
}