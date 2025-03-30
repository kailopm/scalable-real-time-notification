# Scalable Real-Time Notification System

### Description
This project i'll create a `Scalable Real-Time Notification System` including various cloud native tools

### Quick Breakdown :construction_worker:
1. API Gateway (Ingress Controller) to route traffic into microservices.
2. Backend Microservices for handling different notification channels (Email, SMS, Push, WebSocket).
3. Redis for caching data and handling rate-limiting.
4. RabbitMQ for queuing messages and processing asynchronously.
5. WebSocket server for real-time notification delivery.
6. PostgreSQL for storing user preferences and history.
7. Cloudflare CDN for caching API responses and static assets.