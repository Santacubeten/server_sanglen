# Dart Shelf Server

This is a sample RESTful API built with Dart and the Shelf framework.

## API Usage

The base URL for the API is `http://localhost:3000`.


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

*   **`todo_routes.dart`, `clan_routes.dart`, `surname_routes.dart` (The Menu):** These files list all the things you can do with "todo" items, "clans", and "surnames" like:
    *   "Order a new item" (create)
    *   "See all items" (read)
    *   "Change an existing item" (update)
    *   "Throw away an item" (delete)

*   **`todo.dart`, `clan.dart`, `surname.dart` (The Recipe Cards):** These are the basic ideas of what a "todo", a "clan", and a "surname" look like.

*   **`database/` folder (The Kitchen & Storage):**
    *   `db_connection.dart` (The Kitchen Door): This handles getting into the database (our storage room).
    *   `todo_table.dart`, `surname_table.dart` (The Chefs): These are the parts that actually talk to the database to save, get, or change your items.
    *   `clan_repository.dart` is a specialized chef for clans.

*   **`middleware/middleware.dart` (The Bouncer):** This checks every customer (request) before they get to the menu, making sure everything is allowed and safe.

*   **`config/swagger.yaml` and `index.html` (The Instruction Manual):**
    *   `swagger.yaml` is like a detailed book explaining every dish on the menu and how to order it.
    *   `index.html` is the webpage that shows you this book in a nice, easy-to-read way.

*   **`pubspec.yaml` (The Shopping List):** This file lists all the special ingredients (other software parts) the restaurant needs to run.

*   **`README.md` (The Welcome Sign):** This is the first thing you see, telling you what the restaurant is about and how to use its services.

So, in short, it's a small server that helps you manage your lists, clans, and surnames, stores them in a database, and even provides a nice instruction manual (Swagger) for how to use it!
