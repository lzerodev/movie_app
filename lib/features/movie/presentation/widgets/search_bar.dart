import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search for a movie...',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 142, 139, 139)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 142, 139, 139)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 142, 139, 139)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        onSubmitted: (_) => onSubmitted(),
      ),
    );
  }
}
