# Simple Deployment Guide - Complete App to Render

This guide will deploy your entire Go bookings application to Render without any code changes.

## 🚀 Quick Deployment Steps

### 1. Create Render Account
- Go to [render.com](https://render.com)
- Sign up/login with your GitHub account

### 2. Create Web Service
1. Click "New +" → "Web Service"
2. Connect your GitHub repository: `HegdeDhanush/bookings-app`
3. Configure:
   - **Name**: `bookings-app`
   - **Environment**: `Go`
   - **Build Command**: `go build -o main ./bookings/cmd/web`
   - **Start Command**: `./main`
   - **Plan**: `Free`

### 3. Create Database
1. Go back to dashboard
2. Click "New +" → "PostgreSQL"
3. Configure:
   - **Name**: `bookings-db`
   - **Database**: `bookings`
   - **User**: `bookings_user`
   - **Plan**: `Free`

### 4. Link Database
1. Go back to your web service
2. Environment tab → "Link Database"
3. Select `bookings-db`

### 5. Add Environment Variables
In the Environment tab, add:
```
GO_ENV=production
PORT=8080
SECRET_KEY=your-super-secret-key-here-make-it-long-and-random-12345
```

### 6. Deploy
- Click "Create Web Service"
- Wait for build to complete
- Your app will be live at: `https://your-app-name.onrender.com`

## ✅ What This Deploys

Your complete Go application including:
- ✅ All HTML templates
- ✅ Static files (CSS, JS, images)
- ✅ Backend API logic
- ✅ Database integration
- ✅ Admin panel
- ✅ User authentication

## 🔧 Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `GO_ENV` | `production` | Environment mode |
| `PORT` | `8080` | Server port |
| `SECRET_KEY` | `your-secret-key` | App secret (set this) |

## 🌐 Access Your App

Once deployed, you can access:
- **Main site**: `https://your-app-name.onrender.com`
- **Admin panel**: `https://your-app-name.onrender.com/admin`
- **Login**: `https://your-app-name.onrender.com/user/login`

## 🔍 Troubleshooting

### Build Fails
- Check that all Go dependencies are in `go.mod`
- Ensure the build command is correct: `go build -o main ./bookings/cmd/web`

### Database Connection Fails
- Verify database is linked to web service
- Check environment variables are set correctly

### App Not Loading
- Check the logs in Render dashboard
- Verify the health check path is correct

## 📞 Support

- **Render Documentation**: [docs.render.com](https://docs.render.com)
- **Go Documentation**: [golang.org/doc](https://golang.org/doc)

## 🎯 Next Steps

1. ✅ Deploy to Render
2. 🔄 Test all functionality
3. 🔄 Set up custom domain (optional)
4. 🔄 Configure email settings (if needed) 