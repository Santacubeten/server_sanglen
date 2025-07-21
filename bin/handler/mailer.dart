import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../models/user.model.dart';

sendMail(User user,String autoPwd) async {
  String username = 'mayengbamsantasingh@gmail.com';
  String password = 'oinb dbqf wltl bebz'; // provided by google

  final message = Message()
    ..from = Address(username, 'Santa')
    ..recipients.add(user.email)
    ..subject = 'Account created successful'
    ..html = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            text-align: center;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
        }

        p {
            color: #666;
            margin-bottom: 20px;
        }

        .login-details {
            background-color: #f9f9f9;
            border-radius: 5px;
            padding: 10px;
            margin-top: 20px;
            text-align: left;
        }

        .login-details h2 {
            color: #333;
            margin-bottom: 10px;
        }

        .login-details p {
            color: #666;
            margin: 5px 0;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Your Account has been created!</h1>
        <p>Hi, <strong>${user.username}</strong></p>
        <p>This password is system generated for one-time login credential. You must change the password.</p>
        <div class="login-details">
            <h2>Login Details:</h2>
            <p><strong>Username:</strong> ${user.username}</p>
            <p><strong>Password:</strong> $autoPwd</p>
        </div>
       
    </div>
</body>
</html>
''';
  final smtpServer = gmail(username, password);

  try {
    final sendReport = await send(message, smtpServer);

    print("Message sent: ${sendReport.toString()}");
  } on MailerException catch (e) {
    print(e);
  }
}
