import { Hono } from 'hono'
import { cors } from 'hono/cors'

// Import env from workers runtime if available
let env: any;
try {
  env = require('cloudflare:workers').env;
} catch (e) {
  // env won't be available in local development
  env = {}; 
}

// Define error types
interface ApiError {
  error: string;
  details: Record<string, any>;
  statusCode: number;
}

// Safely get API key from available environment sources
let SICKW_API_KEY: string | null = null;

// Try to get from Cloudflare Workers environment
if (env && env.SICKW_API_KEY) {
  SICKW_API_KEY = env.SICKW_API_KEY;
} 
// Will be used by Wrangler in development
else if (typeof process !== 'undefined' && process.env && process.env.SICKW_API_KEY) {
  SICKW_API_KEY = process.env.SICKW_API_KEY;
}

const app = new Hono()

app.use('*', cors({
  // For production, use specific origins:
  origin: (origin) => {
    if (!origin) return origin;
    return origin.startsWith('http://localhost:') ? origin :
          origin === 'https://tech-check.us' ? origin :
          (origin.startsWith('https://') && origin.includes('.tech-check.us')) ? origin : null;
  },
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization'],
  exposeHeaders: ['Content-Length'],
  maxAge: 600,
  credentials: true,
}))


app.get('/wkr', (c) => {
  return c.text('Hello from Tech Check Worker!')
})

app.post('/wkr/applewatch', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: SICKW_API_KEY ? 'Yes' : 'No'
    })

    const api_key = SICKW_API_KEY
    if (!api_key) {
      return c.json({ 
        error: 'API key not found in environment',
        environment: process.env.NODE_ENV || 'unknown'
      }, 500)
    }
  
    // 2. Request validation
    const reqBody = await c.req.json();
    const imei = reqBody.imei as string | undefined;
    if (!imei) {
      return c.json({ error: 'Missing imei' }, 400)
    }
    
    // 3. Prepare request parameters
    const service = 61;
    const url = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${service}`
    
    // 4. API request
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    }).catch((fetchError: Error) => {
      // Get detailed error information
      const errorDetail = {
        name: fetchError.name,
        message: fetchError.message,
        stack: fetchError.stack,
        cause: (fetchError as any).cause,
        errorString: String(fetchError)
      }
      
      console.error('Fetch error details:', errorDetail)
      throw { 
        error: 'Failed to fetch data', 
        details: errorDetail,
        statusCode: 500
      } as ApiError
    });
    
    // 5. Response validation
    console.log('Response status:', response.status)
    
    // Log response headers
    const headers: Record<string, string> = {}
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
      }, 500) // Using 500 as a consistent error code
    }
    
    // 6. Response content validation
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
    
    // 7. Parse and return results
    try {
      const data = JSON.parse(rawText)
      return c.json(data)
    } catch (parseError) {
      return c.json({
        error: 'Failed to parse JSON response',
        rawContent: rawText.substring(0, 1000),
        parseError: {
          name: (parseError as Error).name,
          message: (parseError as Error).message
        },
        headers: headers
      }, 500)
    }
  } catch (error: unknown) {
    // Catch any other errors that might occur
    if (typeof error === 'object' && error !== null) {
      const apiError = error as Partial<ApiError>;
      if (apiError.statusCode && apiError.error) {
        // This is a known error we threw earlier
        // Safely use a fixed status code instead of a dynamic one
        const statusCode = 500; // Always use 500 as a safe status code
        return c.json({ 
          error: apiError.error, 
          details: apiError.details,
          originalStatus: apiError.statusCode // Include the original status code in the response
        }, statusCode)
      }
    }
    
    // Unknown error
    const errorInfo = {
      name: error instanceof Error ? error.name : 'Unknown',
      message: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined,
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