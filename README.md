# Content Publisher Backend

## Overview
Backend for the Content Publisher App, built with **Ruby on Rails** and JWT authentication. Handles user signup/login and CRUD operations for publications.

---

## Features

- User authentication using JWT (signup & login)
- CRUD operations for publications
  - Fields: `title`, `content`, `status` (draft, published, archived)
- Proper validations and error handling
- Meaningful HTTP status codes
- Public API endpoint to view published publications

---

## Prerequisites

- Ruby 3+  
- Rails 7+   
- SQLite3 (or other DB supported by Rails)  

---

## Setup

**Clone the repository:**
```bash
git clone https://github.com/Saikanhaiya21/content_publisher.git
cd content_publisher
```
**Install dependencies:**
```bash
bundle install
```
**Set up the database:**
```bash
rails db:create db:migrate
```

**Start Server:**
```bash
rails server
```
## API Endpoints
**Authentication:**
```bash
Method          Endpoint          Description
POST            /signup           Create new user
POST           /login             Login user & get JWT token
```

**Publications (Protected):**
```bash
Method          Endpoint                Description
GET            /publications            Get all user's publications
POST           /publications            Create a new publication
GET            /publications/:id        Update a publication
PUT           /publications/:id         Delete a publication
```

**Public View (No login required):**
```bash
Method          Endpoint              Description
GET            /public/published      List all published publications
```