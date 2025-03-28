import { env } from 'cloudflare:workers'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello from Tech Check Worker!')
})

app.get('/stdcheck', async (c) => {

  let url = ''

  try {
    const api_key = env.SICKW_API_KEY
    url = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=354442067957452&service=demo`
    
  } catch (error) {
    return c.json({ error: 'Failed to fetch API key' }, 500)
  }

    try {
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        // Add any required headers
      }
    })
    const data = await response.json()
    return c.json(data)
  } catch (error) {
    return c.json({ error: 'Failed to fetch data' }, 500)
  }
})

export default app
