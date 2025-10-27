const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
    res.json({
        message: '🚀 Hello from DevPod CLI Project!',
        status: 'success',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

app.get('/api/info', (req, res) => {
    res.json({
        name: 'DevPod CLI Example API',
        version: '1.0.0',
        description: 'Example Express.js application running in DevPod',
        endpoints: {
            '/': 'Welcome message',
            '/api/info': 'API information',
            '/api/health': 'Health check',
            '/api/demo': 'Demo data'
        }
    });
});

app.get('/api/health', (req, res) => {
    res.json({
        status: 'healthy',
        uptime: process.uptime(),
        timestamp: new Date().toISOString(),
        memory: process.memoryUsage(),
        version: process.version
    });
});

app.get('/api/demo', (req, res) => {
    const demoData = [
        {
            id: 1,
            name: 'DevPod Workspace',
            type: 'Development Environment',
            features: ['Docker Integration', 'VS Code Support', 'Multi-language']
        },
        {
            id: 2,
            name: 'Express Server',
            type: 'Backend Framework',
            features: ['RESTful API', 'Middleware Support', 'Fast & Minimalist']
        },
        {
            id: 3,
            name: 'Node.js Runtime',
            type: 'JavaScript Runtime',
            features: ['V8 Engine', 'Event-driven', 'Non-blocking I/O']
        }
    ];
    
    res.json({
        message: 'Demo data from DevPod environment',
        data: demoData,
        count: demoData.length
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        message: 'Something went wrong!',
        error: process.env.NODE_ENV === 'development' ? err.message : 'Internal Server Error'
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        message: 'Route not found',
        availableRoutes: ['/', '/api/info', '/api/health', '/api/demo']
    });
});

// Start server
app.listen(port, () => {
    console.log(`🚀 DevPod Express server running on port ${port}`);
    console.log(`📱 Access the application at: http://localhost:${port}`);
    console.log(`📊 API endpoints available at: http://localhost:${port}/api/info`);
    console.log(`🏥 Health check at: http://localhost:${port}/api/health`);
});

module.exports = app;