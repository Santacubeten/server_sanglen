### Prompt:

**Objective:** Add a new resource named `[YourNewResourceName]` to my existing Dart Shelf API.

**Context:** The project follows a strict structure:
*   Models are in `bin/models/`.
*   Repositories are in `bin/repository/`.
*   Routes are in `bin/routes/`.
*   All routes are mounted in `bin/server.dart`.

**New Resource Details:**
*   **Name:** `[YourNewResourceName]` (e.g., "Member", "Event", "Story")
*   **Attributes:** `id` (int, primary key), `name` (String), `description` (String), and `[any_other_fields]`.

**Instructions:**

1.  **Create the Model:**
    *   Create a new file: `bin/models/[your_new_resource_name].dart`.
    *   Inside, define a `[YourNewResourceName]` class with the specified attributes.

2.  **Create the Repository:**
    *   Create a new file: `bin/repository/[your_new_resource_name]_repository.dart`.
    *   Implement a `[YourNewResourceName]Repository` class that handles all database operations (CRUD: create, getAll, getById, update, delete) for the new resource. It should use the existing `DBConnection`.

3.  **Create the Routes:**
    *   Create a new file: `bin/routes/[your_new_resource_name]_routes.dart`.
    *   Define a `[YourNewResourceName]Routes` class that creates a `shelf_router.Router` and maps the standard RESTful endpoints (`/`, `/<id>`) for GET, POST, PUT, and DELETE methods to the corresponding repository functions.

4.  **Update the Server:**
    *   Modify `bin/server.dart` to import the new routes file (`bin/routes/[your_new_resource_name]_routes.dart`).
    *   Mount the new routes by adding the following line in the `main()` function:
        ```dart
        app.mount('/[your_new_resource_name_plural]', [YourNewResourceName]Routes(db).router.call);
        ```

Ensure all new code matches the style and conventions of the existing files in the project.