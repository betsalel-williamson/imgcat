# Frontend Build Instructions

## Development Requirements

* sveltejs
* sveltejs/kit
* vite

## Run Dev Build

1. Run `npm run dev`

## Run Node Build

1. `npm ci --omit dev`
2. `npm run build`
3. `export ORIGIN=https://example.com`
   * See [https://svelte.dev/docs/kit/adapter-node](https://svelte.dev/docs/kit/adapter-node) for other configuration
4. `node build`
