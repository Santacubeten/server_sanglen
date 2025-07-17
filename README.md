# Sanglen Server

This is a RESTful API built with Dart and the Shelf framework, designed to manage genealogical data, including clans, surnames, and other related details. It uses a MySQL database for data persistence and provides a Swagger UI for easy API exploration and testing.

## 📜 Table of Contents

- [✨ Features](#-features)
- [🛠️ Getting Started](#️-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [🚀 Running the Server](#-running-the-server)
- [📚 API Documentation](#-api-documentation)
- [🏗️ Project Structure](#️-project-structure)
- [🐳 Docker Support](#-docker-support)

## ✨ Features

- **RESTful API:** A well-structured API for managing clans, surnames, and more.
- **Database Integration:** Uses MySQL for robust data storage.
- **API Documentation:** Integrated with Swagger UI for clear and interactive API documentation.
- **Dockerized:** Includes a `Dockerfile` for easy containerization and deployment.

## 🛠️ Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (version 3.3.0 or higher)
- [MySQL](https://dev.mysql.com/downloads/installer/)
- An IDE or text editor of your choice (e.g., [VS Code](https://code.visualstudio.com/))

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/server_sanglen.git
    cd server_sanglen
    ```

2.  **Install dependencies:**

    ```bash
    dart pub get
    ```

3.  **Set up the database:**
    - Make sure your MySQL server is running.
    - Create a new database.
    - Update the database connection details in `bin/database/db_connection.dart` with your MySQL credentials (host, port, user, password, and database name).

## 🚀 Running the Server

To start the server, run the following command from the project's root directory:

```bash
dart run bin/server.dart
```

The server will start on `http://localhost:3000`. You can see the server logs in your console, which will include the IP addresses the server is running on.

## 📚 API Documentation

The API is documented using Swagger UI. Once the server is running, you can access the interactive API documentation at:

[http://localhost:3000/](http://localhost:3000/)

This interface provides a detailed overview of all available endpoints, their parameters, and response types, and allows you to test the API directly from your browser.

## 🏗️ Project Structure

Here’s a high-level overview of the project's structure:

-   **`bin/server.dart`**: The main entry point of the application. It initializes the server, database connection, and routes.
-   **`bin/config/`**: Contains configuration files, such as `swagger.yaml` for the API documentation.
-   **`bin/database/`**: Manages all database-related logic, including the database connection (`db_connection.dart`), table creation scripts, and middleware.
-   **`bin/models/`**: Defines the data structures (e.g., `Clan`, `Surname`) used throughout the application.
-   **`bin/repository/`**: Contains the logic for interacting with the database, such as fetching, creating, updating, and deleting records.
-   **`bin/routes/`**: Defines the API endpoints and maps them to the corresponding logic in the repositories.
-   **`pubspec.yaml`**: The project's dependency management file.
-   **`Dockerfile`**: A script for building the application as a Docker container.
-   **`README.md`**: This file, providing an overview of the project.

## ➕ Adding a New Table

To add a new table to the project, you'll need to create a few files and update the main server file. Here’s a step-by-step guide:

1.  **Create a Model:**
    -   Create a new file in `bin/models/` that defines the data structure for your new table (e.g., `new_table.dart`).

2.  **Create a Repository:**
    -   Create a new file in `bin/repository/` to handle database operations for the new table (e.g., `new_table_repository.dart`).

3.  **Create a Routes File:**
    -   Create a new file in `bin/routes/` to define the API endpoints for the new table (e.g., `new_table_routes.dart`).

4.  **Update the Server:**
    -   Open `bin/server.dart`.
    -   Import your new routes file.
    -   Mount the new routes in the `main()` function, similar to the existing routes.

This structure ensures that your new feature is well-organized and follows the project's existing architecture.

## 🐳 Docker Support

This project includes a `Dockerfile` that allows you to build and run the application in a Docker container. To build the Docker image, run:

```bash
docker build -t sanglen-server .
```

To run the container:

```bash
docker run -p 3000:3000 sanglen-server
```

This will start the server inside a Docker container and map port `3000` to your local machine, allowing you to access the API at `http://localhost:3000`.