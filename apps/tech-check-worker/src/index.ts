import { Hono } from 'hono'

const app = new Hono()

app.get('/', async (c) => {
  
  const req = new Request('https://sickw.com/api.php?format=beta&key=V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ&imei=354442067957452&service=demo', {
    method: 'GET',
  })
  const res = await app.request(req)

  return c.text(await res.text())
})

export default app
