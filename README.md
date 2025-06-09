# Async Email API Demo

A lightweight Ruby on Rails API that demonstrates asynchronous email delivery using Sidekiq and Redis.

---

## ✅ Features

- Accepts email requests via REST API
- Enqueues emails for background delivery
- Provides job status lookup via API
- Uses Sidekiq + Redis for background processing

---

## ⚙️ Requirements

- Ruby 3.4.4
- Rails 7.2.2.1
- Redis
- Sidekiq

---

## 🚀 Setup

Devcontainers are availible for setup on VSCode. Will require Docker installation. Continue for local installation.

### 1. Clone the repository

```bash
git clone https://github.com/jettdlee/async_email_api_demo.git
cd async_email_api_demo
```
### 2. Install dependencies

`bundle install`

### 3. Set up the database

`rails db:create db:migrate`

### 4. Start Redis (in a new terminal tab)

`redis-server`

### 5. Start the server

```
bundle exec sidekiq
rails server

or

bin/dev
```

## API Endpoints
#### GET /up

Healthcheck endpoint

#### POST /upload

Upload a csv file for validation. Test files are located in the `spec/fixtures/files` folder
```
curl -X POST http://localhost:3000/uploads \
  -F "file=@test/fixtures/files/invalid_users.csv" \
  -H "Content-Type: multipart/form-data"
```

Success Response (202 Accepted)
```
{
    "uploadId": 1,
    "message": "File uploaded successfully. Processing started."
}
```

#### GET /status/:id

Check the status and results of the upload.
Response Example (200 OK)
```
{
    "id": 1,
    "progress": "200%"
}
```
OR
```
{
    "id": 80,
    "total_records": "2",
    "processed_records": "2",
    "failed_records": "0",
    "details": []
}
```
