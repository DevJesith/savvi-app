import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputsReutilizableWidgets extends StatelessWidget {
  final TextEditingController controller;
  final String nameInput;
  final TextInputType keyboardType;
  final bool obscuredText;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final int maxLines;
  final int? maxLenght;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;

  final bool readOnly;

  const InputsReutilizableWidgets({
    Key? key,
    required this.controller,
    required this.nameInput,
    this.validator,
    this.decoration,
    this.maxLines = 1,
    this.maxLenght,
    this.obscuredText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.inputFormatters,
    this.textAlign,
    this.textAlignVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nameInput,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscuredText,
          maxLines: maxLines,
          maxLength: maxLenght,
          readOnly: readOnly,
          inputFormatters: inputFormatters ?? [],
          textAlign: textAlign ?? TextAlign.start,
          textAlignVertical: textAlignVertical,

          decoration:
              decoration ??
              InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.inactiveGray,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CupertinoColors.activeBlue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
              ),
        ),
      ],
    );
  }
}