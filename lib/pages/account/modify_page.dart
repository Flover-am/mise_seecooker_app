import 'package:flutter/material.dart';

class ModifyPage extends StatefulWidget {
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  String _username = 'John Doe';
  String _description = 'This is a user';
  String _password = '';

  void _updateUsername(String value) {
    setState(() {
      _username = value;
    });
  }

  void _updateDescription(String value) {
    setState(() {
      _description = value;
    });
  }

  void _updatePassword(String value) {
    setState(() {
      _password = value;
    });
  }

  void _saveChanges() {
    // Save changes to the server or perform necessary actions
    // For simplicity, we just print the updated values here
    print('Username: $_username');
    print('Description: $_description');
    print('Password: $_password');
    // You can navigate back to the previous screen or perform any other desired action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              // Replace with your image selection logic
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              onChanged: _updateUsername,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              onChanged: _updateDescription,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              onChanged: _updatePassword,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}