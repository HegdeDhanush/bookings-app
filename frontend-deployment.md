# Frontend Deployment for Netlify

## Files to Include in Frontend Deployment

### Static Assets
- `bookings/static/css/` - All CSS files
- `bookings/static/js/` - All JavaScript files  
- `bookings/static/images/` - All image files
- `bookings/static/admin/` - Admin panel assets

### Template Files (Convert to Static HTML)
- `bookings/templates/` - Convert Go templates to static HTML

### Configuration Files
- `netlify.toml` - Netlify configuration
- `package.json` - Frontend dependencies (if any)
- `.gitignore` - Frontend-specific ignore rules

## Netlify Configuration

Create `netlify.toml` in the frontend root:
```toml
[build]
  publish = "public"
  command = "npm run build"

[build.environment]
  NODE_VERSION = "18"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000"

[[headers]]
  for = "*.css"
  [headers.values]
    Cache-Control = "public, max-age=31536000"

[[headers]]
  for = "*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000"
```

## Required Actions

1. **Extract Static Files**: Copy all files from `bookings/static/` to frontend project
2. **Convert Templates**: Transform Go templates to static HTML pages
3. **API Integration**: Update frontend to call backend API endpoints
4. **Environment Variables**: Set up API base URL for backend communication

## File Structure for Frontend
```
frontend/
├── public/
│   ├── css/
│   ├── js/
│   ├── images/
│   ├── admin/
│   └── index.html
├── src/
│   ├── components/
│   ├── pages/
│   └── utils/
├── netlify.toml
├── package.json
└── README.md
```

## Environment Variables for Netlify
- `REACT_APP_API_URL` or `VITE_API_URL` - Backend API URL
- `REACT_APP_ENVIRONMENT` - Production/Development

## Build Commands
```bash
# Install dependencies
npm install

# Build for production
npm run build

# Deploy to Netlify
netlify deploy --prod
``` 