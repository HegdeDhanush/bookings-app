# Deployment Guide: Netlify (Frontend) + Render (Backend)

This guide will help you deploy your Go bookings application with the frontend on Netlify and backend on Render.

## 📁 File Structure

After running the separation script, you'll have:

```
├── frontend-deployment/     # For Netlify
│   ├── public/             # Static assets
│   ├── src/                # Source code
│   ├── netlify.toml        # Netlify config
│   └── package.json        # Frontend dependencies
│
├── backend-deployment/      # For Render
│   ├── cmd/                # Go application entry point
│   ├── internal/           # Internal packages
│   ├── migrations/         # Database migrations
│   ├── render.yaml         # Render config
│   ├── Dockerfile          # Container config
│   └── go.mod              # Go dependencies
│
└── separate-deployment.sh  # Separation script
```

## 🚀 Quick Start

### 1. Separate Files
```bash
# Make script executable
chmod +x separate-deployment.sh

# Run separation script
./separate-deployment.sh
```

### 2. Deploy Backend to Render

1. **Create Render Account**: Sign up at [render.com](https://render.com)

2. **Connect Repository**: 
   - Push your code to GitHub
   - Connect your repository to Render

3. **Create Web Service**:
   - Choose "Web Service"
   - Select your repository
   - Set build command: `go build -o main ./cmd/web`
   - Set start command: `./main`

4. **Configure Environment Variables**:
   ```
   GO_ENV=production
   PORT=8080
   DB_HOST=<your-db-host>
   DB_PORT=5432
   DB_USER=<your-db-user>
   DB_PASSWORD=<your-db-password>
   DB_NAME=<your-db-name>
   SECRET_KEY=<your-secret-key>
   FRONTEND_URL=https://your-frontend-app.netlify.app
   ```

5. **Create Database**:
   - Create a PostgreSQL database on Render
   - Link it to your web service

### 3. Deploy Frontend to Netlify

1. **Create Netlify Account**: Sign up at [netlify.com](https://netlify.com)

2. **Convert Templates**: 
   - Convert Go templates to React components
   - Update API calls to use your Render backend URL

3. **Deploy**:
   - Connect your repository to Netlify
   - Set build command: `npm run build`
   - Set publish directory: `public`

4. **Configure Environment Variables**:
   ```
   REACT_APP_API_URL=https://your-backend-app.onrender.com
   ```

## 🔧 Required Changes

### Backend Changes

1. **Add CORS Support**:
```go
import "github.com/rs/cors"

func main() {
    c := cors.New(cors.Options{
        AllowedOrigins: []string{"https://your-frontend-app.netlify.app"},
        AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowedHeaders: []string{"*"},
        AllowCredentials: true,
    })
    
    handler := c.Handler(router)
    // Use handler instead of router
}
```

2. **Convert to API Endpoints**:
```go
// Instead of server-side rendering, return JSON
func (m *Repository) GetReservations(w http.ResponseWriter, r *http.Request) {
    reservations, err := m.DB.GetAllReservations()
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(reservations)
}
```

3. **Add Health Check Endpoint**:
```go
func (m *Repository) HealthCheck(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
}
```

### Frontend Changes

1. **Create React Components**:
```jsx
// Convert Go templates to React components
function HomePage() {
    const [rooms, setRooms] = useState([]);
    
    useEffect(() => {
        fetch('/api/rooms')
            .then(res => res.json())
            .then(data => setRooms(data));
    }, []);
    
    return (
        <div>
            {rooms.map(room => (
                <RoomCard key={room.id} room={room} />
            ))}
        </div>
    );
}
```

2. **Set up API Client**:
```javascript
// src/utils/api.js
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

export const api = {
    async get(endpoint) {
        const response = await fetch(`${API_BASE_URL}/api${endpoint}`);
        return response.json();
    },
    
    async post(endpoint, data) {
        const response = await fetch(`${API_BASE_URL}/api${endpoint}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });
        return response.json();
    }
};
```

## 🌐 Environment Variables

### Backend (Render)
| Variable | Description | Example |
|----------|-------------|---------|
| `GO_ENV` | Environment | `production` |
| `PORT` | Server port | `8080` |
| `DB_HOST` | Database host | `dpg-xxx.render.com` |
| `DB_PORT` | Database port | `5432` |
| `DB_USER` | Database user | `bookings_user` |
| `DB_PASSWORD` | Database password | `your_password` |
| `DB_NAME` | Database name | `bookings` |
| `SECRET_KEY` | App secret | `your_secret_key` |
| `FRONTEND_URL` | Frontend URL | `https://app.netlify.app` |

### Frontend (Netlify)
| Variable | Description | Example |
|----------|-------------|---------|
| `REACT_APP_API_URL` | Backend API URL | `https://app.onrender.com` |

## 📋 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `GET /api/auth/user` - Get current user

### Reservations
- `GET /api/reservations` - Get all reservations
- `POST /api/reservations` - Create reservation
- `GET /api/reservations/{id}` - Get reservation by ID
- `PUT /api/reservations/{id}` - Update reservation
- `DELETE /api/reservations/{id}` - Delete reservation

### Rooms
- `GET /api/rooms` - Get all rooms
- `GET /api/rooms/{id}` - Get room by ID
- `GET /api/rooms/availability` - Check room availability

### Admin
- `GET /api/admin/dashboard` - Admin dashboard data
- `GET /api/admin/reservations` - Admin reservations
- `PUT /api/admin/reservations/{id}/process` - Process reservation

## 🔍 Troubleshooting

### Common Issues

1. **CORS Errors**:
   - Ensure CORS is properly configured in backend
   - Check that frontend URL is correct in CORS settings

2. **Database Connection**:
   - Verify database credentials in Render
   - Check that database is accessible from your service

3. **Build Failures**:
   - Check Go version compatibility
   - Ensure all dependencies are in go.mod

4. **Environment Variables**:
   - Verify all required variables are set
   - Check variable names match exactly

### Debug Commands

```bash
# Test backend locally
cd backend-deployment
go run ./cmd/web

# Test frontend locally
cd frontend-deployment
npm install
npm run dev

# Check database connection
psql -h $DB_HOST -U $DB_USER -d $DB_NAME
```

## 📞 Support

- **Render Documentation**: [docs.render.com](https://docs.render.com)
- **Netlify Documentation**: [docs.netlify.com](https://docs.netlify.com)
- **Go Documentation**: [golang.org/doc](https://golang.org/doc)

## 🔄 Continuous Deployment

Both Render and Netlify support automatic deployments:

1. **Push to GitHub**: Any push to main branch triggers deployment
2. **Preview Deployments**: Pull requests create preview deployments
3. **Rollback**: Easy rollback to previous versions

## 💰 Cost Considerations

- **Render**: Free tier available, paid plans start at $7/month
- **Netlify**: Free tier available, paid plans start at $19/month
- **Database**: PostgreSQL on Render starts at $7/month

## 🎯 Next Steps

1. ✅ Separate frontend and backend files
2. 🔄 Convert Go templates to React components
3. 🔄 Implement API endpoints in backend
4. 🔄 Set up CORS and authentication
5. 🔄 Configure environment variables
6. 🔄 Deploy to Render and Netlify
7. 🔄 Test and monitor
8. 🔄 Set up custom domains (optional) 