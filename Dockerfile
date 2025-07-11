# Setup Dart server
FROM dart:3.3.0 AS dart-server

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml file and get dependencies
COPY pubspec.* ./
COPY . .
RUN dart pub get

# Run the app
CMD ["dart", "bin/server.dart"]

