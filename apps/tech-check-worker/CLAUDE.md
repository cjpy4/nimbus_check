# Tech Check Worker Guidelines

## Commands
- Build/Run: `npm run dev` (development with wrangler)
- Deploy: `npm run deploy` (production deployment)
- Add linting: `npm install eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin --save-dev`

## Code Style
- TypeScript with strict typing
- 2-space indentation
- Use async/await for asynchronous operations
- Use try/catch blocks for error handling
- Export interfaces and types from dedicated files
- Use environment variables for configuration (defined in wrangler.jsonc)

## Naming Conventions
- camelCase for variables and functions
- PascalCase for interfaces, types, and classes
- snake_case for environment variables

## Architecture
- Hono framework for API routing
- Cloudflare Workers for serverless functions
- Organized endpoints with descriptive route handlers
- Separation of concerns between API layer and business logic

## Best Practices
- Validate inputs at API boundaries
- Return appropriate status codes and error messages
- Document functions with JSDoc comments