# Dart Shelf Server

This is a sample RESTful API built with Dart and the Shelf framework.

## API Usage

The base URL for the API is `http://localhost:3000`.

### Todos

#### Create a Todo

*   **Endpoint:** `/todos`
*   **Method:** `POST`
*   **Body:**

    ```json
    {
      "title": "My First Todo",
      "description": "This is a test todo.",
      "isCompleted": false
    }
    ```

*   **Example:**

    ```bash
    curl -X POST http://localhost:3000/todos -H "Content-Type: application/json" -d '{
      "title": "My First Todo",
      "description": "This is a test todo.",
      "isCompleted": false
    }'
    ```

#### Get All Todos

*   **Endpoint:** `/todos`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/todos
    ```

#### Get a Todo by ID

*   **Endpoint:** `/todos/<id>`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/todos/1
    ```

#### Update a Todo

*   **Endpoint:** `/todos/<id>`
*   **Method:** `PUT`
*   **Body:**

    ```json
    {
      "title": "My Updated Todo",
      "description": "This is an updated test todo.",
      "isCompleted": true
    }
    ```

*   **Example:**

    ```bash
    curl -X PUT http://localhost:3000/todos/1 -H "Content-Type: application/json" -d '{
      "title": "My Updated Todo",
      "description": "This is an updated test todo.",
      "isCompleted": true
    }'
    ```

#### Delete a Todo

*   **Endpoint:** `/todos/<id>`
*   **Method:** `DELETE`
*   **Example:**

    ```bash
    curl -X DELETE http://localhost:3000/todos/1
    ```

### Clans

#### Create a Clan

*   **Endpoint:** `/clans`
*   **Method:** `POST`
*   **Body:**

    ```json
    {
      "name": "New Clan Name",
      "created_by": "Admin"
    }
    ```

*   **Example:**

    ```bash
    curl -X POST http://localhost:3000/clans -H "Content-Type: application/json" -d '{
      "name": "New Clan Name",
      "created_by": "Admin"
    }'
    ```

#### Get All Clans

*   **Endpoint:** `/clans`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/clans
    ```

#### Get a Clan by ID

*   **Endpoint:** `/clans/<id>`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/clans/1
    ```

#### Update a Clan

*   **Endpoint:** `/clans/<id>`
*   **Method:** `PUT`
*   **Body:**

    ```json
    {
      "name": "Updated Clan Name",
      "created_by": "Another Admin"
    }
    ```

*   **Example:**

    ```bash
    curl -X PUT http://localhost:3000/clans/1 -H "Content-Type: application/json" -d '{
      "name": "Updated Clan Name",
      "created_by": "Another Admin"
    }'
    ```

#### Delete a Clan

*   **Endpoint:** `/clans/<id>`
*   **Method:** `DELETE`
*   **Example:**

    ```bash
    curl -X DELETE http://localhost:3000/clans/1
    ```

### Surnames

#### Create a Surname

*   **Endpoint:** `/surnames`
*   **Method:** `POST`
*   **Body:**

    ```json
    {
      "name": "New Surname",
      "clan_id": 1
    }
    ```

*   **Example:**

    ```bash
    curl -X POST http://localhost:3000/surnames -H "Content-Type: application/json" -d '{
      "name": "New Surname",
      "clan_id": 1
    }'
    ```

#### Get All Surnames

*   **Endpoint:** `/surnames`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/surnames
    ```

#### Get Surnames by Clan ID

*   **Endpoint:** `/surnames/clan/<clanId>`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/surnames/clan/1
    ```

#### Get a Surname by ID

*   **Endpoint:** `/surnames/<id>`
*   **Method:** `GET`
*   **Example:**

    ```bash
    curl http://localhost:3000/surnames/1
    ```

#### Update a Surname

*   **Endpoint:** `/surnames/<id>`
*   **Method:** `PUT`
*   **Body:**

    ```json
    {
      "name": "Updated Surname",
      "clan_id": 1
    }
    ```

*   **Example:**

    ```bash
    curl -X PUT http://localhost:3000/surnames/1 -H "Content-Type: application/json" -d '{
      "name": "Updated Surname",
      "clan_id": 1
    }'
    ```

#### Delete a Surname

*   **Endpoint:** `/surnames/<id>`
*   **Method:** `DELETE`
*   **Example:**

    ```bash
    curl -X DELETE http://localhost:3000/surnames/1
    ```

## Project Structure (Easy English)

Imagine this project is like a small restaurant:

*   **`server.dart` (The Manager):** This is the main program. It starts the restaurant, connects to the kitchen (database), and waits for customers (your requests) to come in.

*   **`todo_routes.dart` (The Menu):** This file lists all the things you can do with "todo" items, like:
    *   "Order a new todo" (create)
    *   "See all todos" (read)
    *   "Change an existing todo" (update)
    *   "Throw away a todo" (delete)

*   **`todo.dart` (The Recipe Card):** This is just the basic idea of what a "todo" looks like – it has a title, a description, and whether it's done or not.

*   **`database/` folder (The Kitchen & Storage):**
    *   `db_connection.dart` (The Kitchen Door): This handles getting into the database (our storage room).
    *   `todo_table.dart` (The Chef): This is the part that actually talks to the database to save, get, or change your "todo" items.

*   **`middleware/middleware.dart` (The Bouncer):** This checks every customer (request) before they get to the menu, making sure everything is allowed and safe.

*   **`config/swagger.yaml` and `index.html` (The Instruction Manual):**
    *   `swagger.yaml` is like a detailed book explaining every dish on the menu and how to order it.
    *   `index.html` is the webpage that shows you this book in a nice, easy-to-read way.

*   **`pubspec.yaml` (The Shopping List):** This file lists all the special ingredients (other software parts) the restaurant needs to run.

*   **`README.md` (The Welcome Sign):** This is the first thing you see, telling you what the restaurant is about and how to use its services.

So, in short, it's a small server that helps you manage your "todo" lists, stores them in a database, and even provides a nice instruction manual (Swagger) for how to use it!
