import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var text = 'account';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}