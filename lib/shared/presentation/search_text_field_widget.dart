import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.onChanged,
    required this.onSubmit,
  });
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  // final String? Function(String? value) validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
      ),
      onFieldSubmitted: (_) => onSubmit(),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        prefixIconConstraints: BoxConstraints(
          minWidth: 35,
          minHeight: 40,
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          size: 20,
        ),
        hintText: 'Search by name',
        border: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFebeef4),
      ),
    );
  }
}
