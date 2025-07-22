FROM dart:3.3.0 AS build

WORKDIR /app

# Copy pubspec and fetch dependencies first
COPY pubspec.* ./
RUN dart pub get

# Copy the rest of the application
COPY . .

# Compile the server to native executable
RUN dart compile exe bin/server.dart -o bin/server

# --- Final lightweight image ---
FROM scratch

# Set working directory
WORKDIR /app

# Copy compiled binary and required files from build stage
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/server

# Expose port
EXPOSE 3000

# Run the compiled binary
CMD ["/app/server"]


