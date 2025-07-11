# Dart Shelf Server

This is a sample RESTful API built with Dart and the Shelf framework. It provides basic user management functionalities, including authentication, CRUD operations, and password management.

## Features

*   User authentication with JWT (JSON Web Tokens)
*   CRUD operations for users (Create, Read, Update, Delete)
*   Password hashing using bcrypt
*   Password reset functionality
*   Email notifications using the mailer package
*   CORS middleware for handling cross-origin requests

## Technologies Used

*   [Dart](https://dart.dev/)
*   [Shelf](https://pub.dev/packages/shelf)
*   [Shelf Router](https://pub.dev/packages/shelf_router)
*   [MySQL Client](https://pub.dev/packages/mysql_client)
*   [dart_jsonwebtoken](https://pub.dev/packages/dart_jsonwebtoken)
*   [bcrypt](https://pub.dev/packages/bcrypt)
*   [mailer](https://pub.dev/packages/mailer)

## Installation and Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/your-repo.git
    ```
2.  **Install dependencies:**
    ```bash
    dart pub get
    ```
3.  **Set up the database:**
    *   Make sure you have a MySQL server running.
    *   Create a database and update the connection details in `bin/database/db_connection.dart`.
    *   Run the `init.sql` script to create the `users` table.
4.  **Run the server:**
    ```bash
    dart bin/server.dart
    ```
    The server will start on `http://localhost:3000`.

## API Endpoints

All endpoints are prefixed with `/api`.

| Method | Endpoint | Description |
| --- | --- | --- |
| `POST` | `/login` | Authenticate a user and get a JWT token. |
| `POST` | `/user` | Create a new user. |
| `GET` | `/users` | Get a list of all users. |
| `GET` | `/user/:id` | Get a user by their ID. |
| `PUT` | `/user/:id` | Update a user's information. |
| `DELETE` | `/user/:id` | Delete a user. |
| `PUT` | `/user_reset_pwd/:id` | Reset a user's password. |
| `GET` | `/test_mailer` | Send a test email. |

## Database Schema

The `users` table has the following schema:

| Column | Type | Description |
| --- | --- | --- |
| `id` | `INT` | Primary key, auto-incrementing |
| `username` | `VARCHAR(255)` | User's username |
| `email` | `VARCHAR(255)` | User's email address |
| `role` | `VARCHAR(255)` | User's role (e.g., "admin", "user") |
| `password` | `VARCHAR(255)` | Hashed password |
| `created_at` | `TIMESTAMP` | Timestamp of when the user was created |
| `created_by` | `VARCHAR(255)` | The user who created this user |
| `jwt_token` | `TEXT` | The user's JWT token |
