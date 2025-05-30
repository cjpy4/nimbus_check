# Tech Check Project Guidelines

## Commands
### Worker (Bun/TypeScript)
- Run worker locally: `bun run dev` or `bun run backend:dev` (uses wrangler dev server)
- Deploy worker: `bun run deploy` (production deployment to Cloudflare)
- Type check: `bun run tsc --noEmit` (validate TypeScript without generating files)
- Install ESLint: `bun install eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin --save-dev`
- Run with inspector: `bun run --bun wrangler dev --inspector-port=9229` (for debugging)

### Flutter
- Run app in dev environmet: `flutter run -d chrome --dart-define=APP_ENV=dev`
- Run app: `flutter run` or `bun run frontend:dev` (launches on connected device/emulator)
- Test all: `flutter test` (runs all tests in the test directory)
- Test single file: `flutter test test/widget_test.dart` (runs specific test file)
- Test single unit: `flutter test --name="Counter increments smoke test"` (runs specific test)
- Lint: `flutter analyze` (static analysis using analysis_options.yaml rules)
- Build: `flutter build <platform>` (where platform is ios, android, web, etc.)

## Code Style
### Worker (TypeScript)
- TypeScript with strict typing enabled (noImplicitAny, strictNullChecks, strictFunctionTypes)
- 2-space indentation, 80-character line limit
- Import order: external packages, internal modules, types/interfaces
- Use async/await with try/catch blocks for comprehensive error handling
- Environment variables defined in wrangler.jsonc (use snake_case)
- Prefer arrow functions for callbacks and simple functions
- Use Hono framework patterns for route handlers and middleware
- Document functions with JSDoc comments

### Flutter (Dart)
- Follow flutter_lints package rules defined in analysis_options.yaml
- Organize code into logical directories: widgets, models, services, screens
- Prefer const constructors where possible to improve performance
- Organize imports alphabetically with Flutter imports first, then package imports, then local imports
- Use named parameters for widgets with multiple options
- Keep widget methods small and focused on a single responsibility
- Extract reusable widgets to separate files

## Naming Conventions
- camelCase for variables, functions, and method names
- PascalCase for classes, enums, types, and interfaces
- snake_case for environment variables and file names
- Use descriptive, self-explanatory function names describing actions (e.g., fetchUserData)
- Flutter widgets should have Widget suffix when appropriate (e.g., UserCardWidget)
- Prefix private properties with underscore (_privateProp)
- Use verb prefixes consistently (e.g., get, fetch, load, create)

## Error Handling
- Use structured error responses for API errors (status code + message)
- Log errors with appropriate context for debugging
- Implement graceful degradation for UI when services are unavailable
- Validate all external inputs at service boundaries
- Use try/catch blocks for operations that might fail