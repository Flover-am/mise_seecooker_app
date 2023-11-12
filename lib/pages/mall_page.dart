import 'package:flutter/material.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  var text = 'mall';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}