import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final int flex;
  final Function onSubmitted;
  final bool autofocus;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function onChanged;
  TextCard({
    this.flex,
    this.onSubmitted,
    this.autofocus,
    this.hintText,
    this.keyboardType,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor,
              offset: Offset(1, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              autofocus: autofocus ?? false,
              keyboardType: keyboardType,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
