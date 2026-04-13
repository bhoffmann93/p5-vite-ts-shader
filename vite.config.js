import glsl from 'vite-plugin-glsl';
import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 8080,
    open: 'index.html',
  },
  publicDir: 'static',
  plugins: [glsl()],
  optimizeDeps: {
    include: ['p5'],
  },
});
