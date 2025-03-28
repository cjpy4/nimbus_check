import { Hono } from 'hono'

const app = new Hono()

app.get('/', async (c) => {
  
  const req = new Request('Hello!', {
    method: 'POST',
  })
  const res = await app.request(req)

  return c.text('Hello Hono!')
})

export default app
