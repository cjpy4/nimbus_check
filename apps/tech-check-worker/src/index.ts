import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { env } from 'cloudflare:workers'

// Define error types
interface ApiError {
  error: string;
  details: Record<string, any>;
  statusCode: number;
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

const api_key = env.SICKW_API_KEY

app.get('/wkr', (c) => {
  return c.text('Hello from Tech Check!')
})

app.post('/wkr/applewatch', async (c) => {
  try {
    // 1. Environment validation
    
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    //const service = 61;
    const url = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    
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
    
    const responseText = await response.text();
    if (!response.ok || responseText.trim().startsWith('<')) {
      return c.json({
        error: 'FMI service failed or returned HTML',
        service: 'FMI',
        status: response.status,
        body: responseText.substring(0, 1000),
      }, 500);
    }
    
    // 7. Parse and return results
    try {
      const data = JSON.parse(responseText)
      return c.json(data)
    } catch (parseError) {
      return c.json({
        error: 'Failed to parse JSON response',
        rawContent: responseText.substring(0, 1000),
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

app.post('/wkr/airpods', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    // const blacklistFMIService = 61;
    // const appleMDMService = 72;
    const urlFMI = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    const urlMDM = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${81}`
    
    // 4. FMI BlackList API request
    const [respFMI, respMDM] = await Promise.all([
          fetch(urlFMI, { headers: { 'Content-Type': 'application/json' } }),
          fetch(urlMDM, { headers: { 'Content-Type': 'application/json' } }),
        ]).catch((fetchError: Error) => {
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
    // Validate FMI response for errors or non-JSON
        const respTextFMI = await respFMI.text();
        if (!respFMI.ok || respTextFMI.trim().startsWith('<')) {
          return c.json({
            error: 'FMI service failed or returned HTML',
            service: 'FMI',
            status: respFMI.status,
            body: respTextFMI.substring(0, 1000),
          }, 500);
        }
    
        // Validate MDM response for errors or non-JSON
        const respTextMDM = await respMDM.text();
        if (!respMDM.ok || respTextMDM.trim().startsWith('<')) {
          return c.json({
            error: 'MDM service failed or returned HTML',
            service: 'MDM',
            status: respMDM.status,
            body: respTextMDM.substring(0, 1000),
          }, 500);
        }
    
    // 7. Parse and return results
    let dataFMI: any, dataMDM: any;
    try {
      dataFMI = JSON.parse(respTextFMI);
    } catch (e) {
      return c.json({ error: 'FMI JSON parse error', raw: respTextFMI.substring(0,500) }, 500);
    }
    try {
      dataMDM = JSON.parse(respTextMDM);
    } catch (e) {
      return c.json({ error: 'MDM JSON parse error', raw: respTextMDM.substring(0,500) }, 500);
    }
    
    // Merge both the top-level properties and the nested result objects
    const combinedJSON = {
      ...dataFMI,
      ...dataMDM,
      result: {
        ...dataFMI.result,
        ...dataMDM.result
      }
    };
  
    return c.json(combinedJSON);
    
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

app.post('/wkr/iphone', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    // const blacklistFMIService = 61;
    // const appleMDMService = 72;
    const urlFMI = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    const urlMDM = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${81}`
    
    // 4. FMI BlackList API request
    const [respFMI, respMDM] = await Promise.all([
          fetch(urlFMI, { headers: { 'Content-Type': 'application/json' } }),
          fetch(urlMDM, { headers: { 'Content-Type': 'application/json' } }),
        ]).catch((fetchError: Error) => {
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
    // Validate FMI response for errors or non-JSON
        const respTextFMI = await respFMI.text();
        if (!respFMI.ok || respTextFMI.trim().startsWith('<')) {
          return c.json({
            error: 'FMI service failed or returned HTML',
            service: 'FMI',
            status: respFMI.status,
            body: respTextFMI.substring(0, 1000),
          }, 500);
        }
    
        // Validate MDM response for errors or non-JSON
        const respTextMDM = await respMDM.text();
        if (!respMDM.ok || respTextMDM.trim().startsWith('<')) {
          return c.json({
            error: 'MDM service failed or returned HTML',
            service: 'MDM',
            status: respMDM.status,
            body: respTextMDM.substring(0, 1000),
          }, 500);
        }
    
    // 7. Parse and return results
    let dataFMI: any, dataMDM: any;
    try {
      dataFMI = JSON.parse(respTextFMI);
    } catch (e) {
      return c.json({ error: 'FMI JSON parse error', raw: respTextFMI.substring(0,500) }, 500);
    }
    try {
      dataMDM = JSON.parse(respTextMDM);
    } catch (e) {
      return c.json({ error: 'MDM JSON parse error', raw: respTextMDM.substring(0,500) }, 500);
    }
    
    // Merge both the top-level properties and the nested result objects
    const combinedJSON = {
      ...dataFMI,
      ...dataMDM,
      result: {
        ...dataFMI.result,
        ...dataMDM.result
      }
    };
  
    return c.json(combinedJSON);
    
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

app.post('/wkr/ipad', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    // const blacklistFMIService = 61;
    // const appleMDMService = 72;
    const urlFMI = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    const urlMDM = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${81}`
    
    // 4. FMI BlackList API request
    const [respFMI, respMDM] = await Promise.all([
          fetch(urlFMI, { headers: { 'Content-Type': 'application/json' } }),
          fetch(urlMDM, { headers: { 'Content-Type': 'application/json' } }),
        ]).catch((fetchError: Error) => {
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
    // Validate FMI response for errors or non-JSON
        const respTextFMI = await respFMI.text();
        if (!respFMI.ok || respTextFMI.trim().startsWith('<')) {
          return c.json({
            error: 'FMI service failed or returned HTML',
            service: 'FMI',
            status: respFMI.status,
            body: respTextFMI.substring(0, 1000),
          }, 500);
        }
    
        // Validate MDM response for errors or non-JSON
        const respTextMDM = await respMDM.text();
        if (!respMDM.ok || respTextMDM.trim().startsWith('<')) {
          return c.json({
            error: 'MDM service failed or returned HTML',
            service: 'MDM',
            status: respMDM.status,
            body: respTextMDM.substring(0, 1000),
          }, 500);
        }
    
    // 7. Parse and return results
    let dataFMI: any, dataMDM: any;
    try {
      dataFMI = JSON.parse(respTextFMI);
    } catch (e) {
      return c.json({ error: 'FMI JSON parse error', raw: respTextFMI.substring(0,500) }, 500);
    }
    try {
      dataMDM = JSON.parse(respTextMDM);
    } catch (e) {
      return c.json({ error: 'MDM JSON parse error', raw: respTextMDM.substring(0,500) }, 500);
    }
    
    // Merge both the top-level properties and the nested result objects
    const combinedJSON = {
      ...dataFMI,
      ...dataMDM,
      result: {
        ...dataFMI.result,
        ...dataMDM.result
      }
    };
  
    return c.json(combinedJSON);
    
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

app.post('/wkr/imac', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    // const blacklistFMIService = 61;
    // const appleMDMService = 72;
    const urlFMI = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    const urlMDM = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${81}`
    
    // 4. FMI BlackList API request
    const [respFMI, respMDM] = await Promise.all([
          fetch(urlFMI, { headers: { 'Content-Type': 'application/json' } }),
          fetch(urlMDM, { headers: { 'Content-Type': 'application/json' } }),
        ]).catch((fetchError: Error) => {
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
    // Validate FMI response for errors or non-JSON
        const respTextFMI = await respFMI.text();
        if (!respFMI.ok || respTextFMI.trim().startsWith('<')) {
          return c.json({
            error: 'FMI service failed or returned HTML',
            service: 'FMI',
            status: respFMI.status,
            body: respTextFMI.substring(0, 1000),
          }, 500);
        }
    
        // Validate MDM response for errors or non-JSON
        const respTextMDM = await respMDM.text();
        if (!respMDM.ok || respTextMDM.trim().startsWith('<')) {
          return c.json({
            error: 'MDM service failed or returned HTML',
            service: 'MDM',
            status: respMDM.status,
            body: respTextMDM.substring(0, 1000),
          }, 500);
        }
    
    // 7. Parse and return results
    let dataFMI: any, dataMDM: any;
    try {
      dataFMI = JSON.parse(respTextFMI);
    } catch (e) {
      return c.json({ error: 'FMI JSON parse error', raw: respTextFMI.substring(0,500) }, 500);
    }
    try {
      dataMDM = JSON.parse(respTextMDM);
    } catch (e) {
      return c.json({ error: 'MDM JSON parse error', raw: respTextMDM.substring(0,500) }, 500);
    }
    
    // Merge both the top-level properties and the nested result objects
    const combinedJSON = {
      ...dataFMI,
      ...dataMDM,
      result: {
        ...dataFMI.result,
        ...dataMDM.result
      }
    };
  
    return c.json(combinedJSON);
    
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

app.post('/wkr/macbook', async (c) => {
  try {
    // 1. Environment validation
    console.log('Environment:', {
      environment: c.env ? 'Found' : 'Not Found',
      hasApiKey: api_key ? 'Yes' : 'No'
    })

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
    // const blacklistFMIService = 61;
    // const appleMDMService = 72;
    const urlFMI = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${61}`
    const urlMDM = `https://sickw.com/api.php?format=beta&key=${api_key}&imei=${imei}&service=${81}`
    
    // 4. FMI BlackList API request
    const [respFMI, respMDM] = await Promise.all([
          fetch(urlFMI, { headers: { 'Content-Type': 'application/json' } }),
          fetch(urlMDM, { headers: { 'Content-Type': 'application/json' } }),
        ]).catch((fetchError: Error) => {
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
    // Validate FMI response for errors or non-JSON
        const respTextFMI = await respFMI.text();
        if (!respFMI.ok || respTextFMI.trim().startsWith('<')) {
          return c.json({
            error: 'FMI service failed or returned HTML',
            service: 'FMI',
            status: respFMI.status,
            body: respTextFMI.substring(0, 1000),
          }, 500);
        }
    
        // Validate MDM response for errors or non-JSON
        const respTextMDM = await respMDM.text();
        if (!respMDM.ok || respTextMDM.trim().startsWith('<')) {
          return c.json({
            error: 'MDM service failed or returned HTML',
            service: 'MDM',
            status: respMDM.status,
            body: respTextMDM.substring(0, 1000),
          }, 500);
        }
    
    // 7. Parse and return results
    let dataFMI: any, dataMDM: any;
    try {
      dataFMI = JSON.parse(respTextFMI);
    } catch (e) {
      return c.json({ error: 'FMI JSON parse error', raw: respTextFMI.substring(0,500) }, 500);
    }
    try {
      dataMDM = JSON.parse(respTextMDM);
    } catch (e) {
      return c.json({ error: 'MDM JSON parse error', raw: respTextMDM.substring(0,500) }, 500);
    }
    
    // Merge both the top-level properties and the nested result objects
    const combinedJSON = {
      ...dataFMI,
      ...dataMDM,
      result: {
        ...dataFMI.result,
        ...dataMDM.result
      }
    };
  
    return c.json(combinedJSON);
    
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