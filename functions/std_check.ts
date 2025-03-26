import { Hono } from 'hono'
const app = new Hono()

app.get('/std_check', (c) => c.text('Hello Cloudflare Workers!'))

export default app