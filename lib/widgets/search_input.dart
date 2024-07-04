import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const SearchInput({required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.titleLarge!.color!;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: textColor.withOpacity(0.3))),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.lato(color: textColor, fontSize: 18),
        cursorColor: textColor,
        onSubmitted: (_) => onPressed(),
        decoration: InputDecoration(
          hintText: 'Enter city name',
          hintStyle: GoogleFonts.lato(color: textColor.withOpacity(0.5)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
