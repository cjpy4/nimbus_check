import { env } from 'cloudflare:workers'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello from Tech Check Worker!')
})

app.get('/stdcheck', async (c) => {
  try {
    // Let's log the environment for debugging
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: env.SICKW_API_KEY ? 'Yes' : 'No'
    })

    const api_key = env.SICKW_API_KEY

    if (!api_key) {
      return c.json({ 
        error: 'API key not found in environment',
        environment: process.env.NODE_ENV || 'unknown'
      }, 500)
    }
    
    const url = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=354442067957452&service=demo`
    console.log('Fetching URL:', url.replace(api_key, 'REDACTED_KEY'))
    
    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        }
      })
      
      console.log('Response status:', response.status)
      
      // Log response headers
      const headers = {}
      response.headers.forEach((value, key) => {
        headers[key] = value
      })
      console.log('Response headers:', headers)
      
      if (!response.ok) {
        const errorText = await response.text()
        console.error('Response error:', errorText)
        return c.json({ 
          error: 'API request failed',
          status: response.status,
          statusText: response.statusText,
          headers: headers,
          details: errorText.substring(0, 500) // Limit response size
        }, response.status)
      }
      
      // Clone the response so we can read the raw text for debugging
      const responseClone = response.clone()
      const rawText = await responseClone.text()
      console.log('Raw response:', rawText.substring(0, 500))
      
      // Check if the response starts with HTML tags
      if (rawText.trim().startsWith('<')) {
        return c.json({
          error: 'HTML response received instead of JSON',
          htmlContent: rawText.substring(0, 1000),
          headers: headers
        }, 500)
      }
      
      try {
        const data = JSON.parse(rawText)
        return c.json(data)
      } catch (parseError) {
        return c.json({
          error: 'Failed to parse JSON response',
          rawContent: rawText.substring(0, 1000),
          parseError: {
            name: parseError.name,
            message: parseError.message
          },
          headers: headers
        }, 500)
      }
    } catch (fetchError) {
      // Get detailed error information
      const errorDetail = {
        name: fetchError.name,
        message: fetchError.message,
        stack: fetchError.stack,
        cause: fetchError.cause,
        errorString: String(fetchError)
      }
      
      console.error('Fetch error details:', errorDetail)
      
      return c.json({ 
        error: 'Failed to fetch data', 
        details: errorDetail
      }, 500)
    }
  } catch (error) {
    // Catch any other errors that might occur
    const errorInfo = {
      name: error.name,
      message: error.message,
      stack: error.stack,
      errorString: String(error)
    }
    
    console.error('Unexpected error:', errorInfo)
    
    return c.json({ 
      error: 'Unexpected error occurred', 
      details: errorInfo
    }, 500)
  }
})

export default app