const request = require('supertest');
const app = require('../src/index');

describe('Node.js API Tests', () => {
    describe('GET /', () => {
        it('should return welcome message', async () => {
            const response = await request(app).get('/');
            
            expect(response.status).toBe(200);
            expect(response.body.message).toContain('Welcome to Node.js DevPod API');
            expect(response.body.version).toBe('1.0.0');
        });
    });

    describe('GET /health', () => {
        it('should return health status', async () => {
            const response = await request(app).get('/health');
            
            expect(response.status).toBe(200);
            expect(response.body.status).toBe('OK');
            expect(response.body.service).toBe('Node.js API');
        });
    });

    describe('GET /api/users', () => {
        it('should return list of users', async () => {
            const response = await request(app).get('/api/users');
            
            expect(response.status).toBe(200);
            expect(response.body.users).toBeInstanceOf(Array);
            expect(response.body.count).toBeGreaterThan(0);
        });
    });

    describe('POST /api/users', () => {
        it('should create a new user', async () => {
            const newUser = {
                name: 'Test User',
                email: 'test@example.com'
            };

            const response = await request(app)
                .post('/api/users')
                .send(newUser);
            
            expect(response.status).toBe(201);
            expect(response.body.message).toContain('User created successfully');
            expect(response.body.user.name).toBe(newUser.name);
            expect(response.body.user.email).toBe(newUser.email);
        });

        it('should return error for missing fields', async () => {
            const response = await request(app)
                .post('/api/users')
                .send({ name: 'Test User' }); // Missing email
            
            expect(response.status).toBe(400);
            expect(response.body.error).toContain('Name and email are required');
        });
    });

    describe('404 handling', () => {
        it('should return 404 for unknown routes', async () => {
            const response = await request(app).get('/unknown-route');
            
            expect(response.status).toBe(404);
            expect(response.body.error).toBe('Route not found');
        });
    });
});