# Backend Deployment for Render

## Files to Include in Backend Deployment

### Go Application Files
- `bookings/cmd/web/` - Main application entry point
- `bookings/internal/` - All internal packages (config, handlers, models, etc.)
- `bookings/pkg/` - Shared packages
- `bookings/go.mod` - Go module file
- `bookings/go.sum` - Go dependencies checksum

### Database Files
- `bookings/migrations/` - Database migration files
- `bookings/create_tables.sql` - Database schema
- `bookings/database.yml.example` - Database configuration template

### Configuration Files
- `render.yaml` - Render deployment configuration
- `Dockerfile` - Container configuration
- `.dockerignore` - Docker ignore rules
- `.gitignore` - Backend-specific ignore rules

## Render Configuration

Create `render.yaml` in the backend root:
```yaml
services:
  - type: web
    name: bookings-backend
    env: go
    plan: starter
    buildCommand: go build -o main ./cmd/web
    startCommand: ./main
    envVars:
      - key: GO_ENV
        value: production
      - key: PORT
        value: 8080
      - key: DB_HOST
        sync: false
      - key: DB_PORT
        sync: false
      - key: DB_USER
        sync: false
      - key: DB_PASSWORD
        sync: false
      - key: DB_NAME
        sync: false
      - key: SECRET_KEY
        sync: false
      - key: FRONTEND_URL
        value: https://your-frontend-app.netlify.app

databases:
  - name: bookings-db
    databaseName: bookings
    user: bookings_user
    plan: starter
```

## Dockerfile for Backend

Create `Dockerfile` in the backend root:
```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/web

# Final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Run the binary
CMD ["./main"]
```

## Environment Variables for Render

### Required Environment Variables
- `DB_HOST` - Database host
- `DB_PORT` - Database port (usually 5432)
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password
- `DB_NAME` - Database name
- `SECRET_KEY` - Application secret key
- `FRONTEND_URL` - Frontend application URL

### Optional Environment Variables
- `GO_ENV` - Environment (production/development)
- `PORT` - Application port (default: 8080)
- `SMTP_HOST` - SMTP server for emails
- `SMTP_PORT` - SMTP port
- `SMTP_USERNAME` - SMTP username
- `SMTP_PASSWORD` - SMTP password

## File Structure for Backend
```
backend/
├── cmd/
│   └── web/
│       ├── main.go
│       ├── middleware.go
│       ├── routes.go
│       └── send-mail.go
├── internal/
│   ├── config/
│   ├── driver/
│   ├── forms/
│   ├── handlers/
│   ├── helpers/
│   ├── models/
│   ├── render/
│   └── repository/
├── migrations/
├── go.mod
├── go.sum
├── render.yaml
├── Dockerfile
├── .dockerignore
└── README.md
```

## Required Actions

1. **API Endpoints**: Convert server-side rendered pages to REST API endpoints
2. **CORS Configuration**: Enable CORS for frontend communication
3. **Database Setup**: Configure PostgreSQL database on Render
4. **Environment Variables**: Set up all required environment variables
5. **Static File Serving**: Remove static file serving (handled by frontend)

## Build and Deploy Commands

```bash
# Test the application locally
go test ./...

# Build the application
go build -o main ./cmd/web

# Run locally
./main

# Deploy to Render
# Connect your GitHub repository to Render
# Render will automatically build and deploy on push
```

## API Endpoints to Implement

### Authentication
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `GET /api/auth/user`

### Reservations
- `GET /api/reservations`
- `POST /api/reservations`
- `GET /api/reservations/{id}`
- `PUT /api/reservations/{id}`
- `DELETE /api/reservations/{id}`

### Rooms
- `GET /api/rooms`
- `GET /api/rooms/{id}`
- `GET /api/rooms/availability`

### Admin
- `GET /api/admin/dashboard`
- `GET /api/admin/reservations`
- `PUT /api/admin/reservations/{id}/process`

## CORS Configuration

Add CORS middleware to allow frontend communication:
```go
import (
    "github.com/rs/cors"
)

func main() {
    // ... existing code ...
    
    // CORS configuration
    c := cors.New(cors.Options{
        AllowedOrigins: []string{"https://your-frontend-app.netlify.app"},
        AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowedHeaders: []string{"*"},
        AllowCredentials: true,
    })
    
    // Apply CORS middleware
    handler := c.Handler(router)
    
    // ... rest of the code ...
}
``` 