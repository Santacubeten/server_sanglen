# Dart Shelf Server

This is a sample RESTful API built with Dart and the Shelf framework.

## API Usage

The base URL for the API is `http://localhost:3000`.

### Todos

#### Create a Todo

- **Endpoint:** `/todos`
- **Method:** `POST`
- **Body:**

  ```json
  {
    "title": "My First Todo",
    "description": "This is a test todo.",
    "isCompleted": false
  }
  ```

- **Example:**

  ```bash
  curl -X POST http://localhost:3000/todos -H "Content-Type: application/json" -d '{
    "title": "My First Todo",
    "description": "This is a test todo.",
    "isCompleted": false
  }'
  ```

#### Get All Todos

- **Endpoint:** `/todos`
- **Method:** `GET`
- **Example:**

  ```bash
  curl http://localhost:3000/todos
  ```

#### Get a Todo by ID

- **Endpoint:** `/todos/<id>`
- **Method:** `GET`
- **Example:**

  ```bash
  curl http://localhost:3000/todos/1
  ```

#### Update a Todo

- **Endpoint:** `/todos/<id>`
- **Method:** `PUT`
- **Body:**

  ```json
  {
    "title": "My Updated Todo",
    "description": "This is an updated test todo.",
    "isCompleted": true
  }
  ```

- **Example:**

  ```bash
  curl -X PUT http://localhost:3000/todos/1 -H "Content-Type: application/json" -d '{
    "title": "My Updated Todo",
    "description": "This is an updated test todo.",
    "isCompleted": true
  }'
  ```

#### Delete a Todo

- **Endpoint:** `/todos/<id>`
- **Method:** `DELETE`
- **Example:**

  ```bash
  curl -X DELETE http://localhost:3000/todos/1
  ```
