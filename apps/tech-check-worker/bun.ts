#!/usr/bin/env bun
console.log("Running Tech Check Worker with Bun 🚀");

// Set environment variables for local development
process.env.SICKW_API_KEY = process.env.SICKW_API_KEY || "local-dev-key";

// Run the main worker script
await import("./src/index.ts");