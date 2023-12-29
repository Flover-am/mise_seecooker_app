import 'dart:developer';

import 'package:flutter/material.dart';

class TextSelect extends StatefulWidget {
  const TextSelect({super.key});

  @override
  State<TextSelect> createState() => _TextSelectState();
}

class _TextSelectState extends State<TextSelect> {
  final List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];
  String _text = "";

  String get text => _text;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        _text = textEditingValue.text;
        log(_text);

        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        log(_text);
        _text = selection;
        debugPrint('You just selected $selection');
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: '用量：比如一只',
            border: InputBorder.none,
            // TODO: 修改样式
          ),
        );
      },
    );
  }
}
