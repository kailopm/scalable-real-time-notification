from fastapi import FastAPI, HTTPException, WebSocket
from pydantic import BaseModel
import redis
import aio_pika
import psycopg2

# Initialize Redis connection for rate-limiting
r = redis.Redis(host="localhost", port=6379, db=0)

# Initialize FastAPI app
app = FastAPI()

# Database connection
db_conn = psycopg2.connect(
    host="your-db-host",
    dbname="notificationdb",
    user="admin",
    password="securepassword"
)

# Pydantic model for user subscription
class UserSubscription(BaseModel):
    user_id: str
    email: str

# Rate limiting check
def is_rate_limited(user_id: str) -> bool:
    key = f"user:{user_id}:requests"
    count = r.incr(key)
    if count == 1:
        r.expire(key, 60)  # Reset count every 60 seconds
    return count > 10  # Max 10 requests per minute

@app.post("/subscribe")
async def subscribe_user(subscription: UserSubscription):
    if is_rate_limited(subscription.user_id):
        raise HTTPException(status_code=429, detail="Too many requests")
    
    # Store user subscription in PostgreSQL (for example)
    with db_conn.cursor() as cursor:
        cursor.execute(
            "INSERT INTO subscriptions (user_id, email) VALUES (%s, %s)",
            (subscription.user_id, subscription.email)
        )
        db_conn.commit()

    # Queue the notification task in RabbitMQ
    await queue_message(subscription)

    return {"message": "User subscribed successfully!"}

# Function to queue messages in RabbitMQ
async def queue_message(subscription: UserSubscription):
    connection = await aio_pika.connect_robust("amqp://guest:guest@localhost/")
    async with connection:
        channel = await connection.channel()  # Creating channel
        queue = await channel.declare_queue("notifications", durable=True)  # Declare queue

        # Sending message to queue
        await channel.default_exchange.publish(
            aio_pika.Message(body=str(subscription.dict()).encode()),
            routing_key=queue.name,
        )
