import type { ServerPageLoad } from './$types';

export const load: ServerPageLoad = async({ locals }) => {
	return locals;
}