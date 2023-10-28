# README

This application allows users to upload files, storing and encrypting them for security. Users can download the archived files and decrypt them using the password provided during the upload process.

## Configuration & Prerequisites

- Ruby version: 3.1.4

- MySQL Database Configuration:

  ```sql
  CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
  GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'localhost';
  FLUSH PRIVILEGES;

- Project Setup:

  ```
  bundle install
  rails db:setup

## How to Use

### Documentation

Start the server and navigate to `/api/docs` for the API documentation.

### Features

#### User Authentication

Authenticate a user by sending a `GET /api/login` request with the following body:

  ```json
  {
    "user": {
      "email": "admin@email.com",
      "password": "password"
    }
  }
  ```

The response will include a JWT, which is required for the Auth Bearer token when uploading or reading files.

#### File Upload and Encryption

To upload and encrypt a file, send a `POST /api/files` request with the file attachment as a MultiPart form. The response will include a message, the URL of the uploaded file, and a password for decryption:

  ```json
  {
    "message": "File 'foo.png' uploaded and archived with password successfully.",
    "url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEsInB1ciI6ImJsb2JfaWQifX0=--18da61b9f3847d27f5c19807308d66b2c69bac05/foo.png.zip",
    "password": "25e008b2"
  }
  ```

#### Retrieve All Attached Files

To retrieve all attached files, send a `GET /api/files` request. The response will return a list of attached files:

  ```json
  [
    {
      "filename": "foo.png.zip",
      "url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--189d9bfdc057c1f47a803fefc1ff8efb6e65c573/foo.png.zip"
    }
  ]
  ```

#### Run tests

  ```
  rspec
