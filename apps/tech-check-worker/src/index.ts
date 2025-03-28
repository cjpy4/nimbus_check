import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {

    const req = new Request('Hello!', {
      method: 'POST',
    })
    const res = await app.request(req)
    expect(res.status).toBe(201)
  return c.text('Hello Hono!')
})

export default app
