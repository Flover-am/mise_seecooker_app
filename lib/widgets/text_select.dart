import 'package:flutter/material.dart';

class TextSelect extends StatefulWidget {
  final void Function(int index, String value) onChange;

  final List<String> ops;

  const TextSelect(
      {super.key,
      required this.onChange,
      required this.index,
      required this.ops});

  final int index;

  @override
  State<TextSelect> createState() => _TextSelectState();
}

class _TextSelectState extends State<TextSelect> {
  late final List<String> _kOptions;
  String _text = "";

  @override
  void initState() {
    _kOptions = widget.ops;
    // TODO: implement initState
    super.initState();
  }

  String get text => _text;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsViewBuilder: (context, onSelected, options) {
        // 下拉栏的高度控制为200，宽度为100，可以滑动

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 180,
              width: 160.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        widget.onChange(widget.index, textEditingValue.text);
        _text = textEditingValue.text;

        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        widget.onChange(widget.index, selection);

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
