#!/bin/bash

# Script to separate frontend and backend files for deployment
# Usage: ./separate-deployment.sh

echo "Creating deployment directories..."

# Create frontend directory
mkdir -p frontend-deployment/public
mkdir -p frontend-deployment/src

# Create backend directory
mkdir -p backend-deployment

echo "Copying frontend files..."

# Copy static files to frontend
if [ -d "bookings/static" ]; then
    cp -r bookings/static/* frontend-deployment/public/
    echo "✓ Copied static files"
fi

# Copy templates (will need conversion to static HTML)
if [ -d "bookings/templates" ]; then
    cp -r bookings/templates frontend-deployment/src/
    echo "✓ Copied templates (need conversion to static HTML)"
fi

# Copy frontend configuration
cp netlify.toml frontend-deployment/
echo "✓ Copied netlify.toml"

echo "Copying backend files..."

# Copy Go application files
if [ -d "bookings/cmd" ]; then
    cp -r bookings/cmd backend-deployment/
    echo "✓ Copied cmd directory"
fi

if [ -d "bookings/internal" ]; then
    cp -r bookings/internal backend-deployment/
    echo "✓ Copied internal directory"
fi

if [ -d "bookings/pkg" ]; then
    cp -r bookings/pkg backend-deployment/
    echo "✓ Copied pkg directory"
fi

# Copy Go module files
if [ -f "bookings/go.mod" ]; then
    cp bookings/go.mod backend-deployment/
    echo "✓ Copied go.mod"
fi

if [ -f "bookings/go.sum" ]; then
    cp bookings/go.sum backend-deployment/
    echo "✓ Copied go.sum"
fi

# Copy database files
if [ -d "bookings/migrations" ]; then
    cp -r bookings/migrations backend-deployment/
    echo "✓ Copied migrations"
fi

if [ -f "bookings/create_tables.sql" ]; then
    cp bookings/create_tables.sql backend-deployment/
    echo "✓ Copied create_tables.sql"
fi

# Copy backend configuration files
cp render.yaml backend-deployment/
cp Dockerfile backend-deployment/
cp .dockerignore backend-deployment/
echo "✓ Copied backend configuration files"

# Create package.json for frontend (basic)
cat > frontend-deployment/package.json << EOF
{
  "name": "bookings-frontend",
  "version": "1.0.0",
  "description": "Frontend for bookings application",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.27",
    "@types/react-dom": "^18.0.10",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0"
  }
}
EOF
echo "✓ Created package.json for frontend"

# Create .gitignore for frontend
cat > frontend-deployment/.gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
EOF
echo "✓ Created .gitignore for frontend"

# Create .gitignore for backend
cat > backend-deployment/.gitignore << EOF
# Binaries
main
*.exe
*.exe~
*.dll
*.so
*.dylib

# Environment variables
.env
.env.local

# Logs
*.log

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Temporary files
tmp/
temp/
EOF
echo "✓ Created .gitignore for backend"

echo ""
echo "✅ Deployment separation complete!"
echo ""
echo "📁 Frontend files are in: frontend-deployment/"
echo "📁 Backend files are in: backend-deployment/"
echo ""
echo "Next steps:"
echo "1. Convert Go templates to static HTML/React components"
echo "2. Set up API endpoints in backend"
echo "3. Configure environment variables"
echo "4. Deploy frontend to Netlify"
echo "5. Deploy backend to Render" 