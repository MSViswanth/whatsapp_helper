// Copyright (C) 2020 Viswanth
//
// This file is part of WhatsApp Helper.
//
// WhatsApp Helper is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// WhatsApp Helper is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with WhatsApp Helper.  If not, see <http://www.gnu.org/licenses/>.

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
              color: Colors.black87,
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
