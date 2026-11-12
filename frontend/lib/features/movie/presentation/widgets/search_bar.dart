import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Digite o nome do filme...',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
          prefixIcon: const Icon(Icons.search,
              color: Color.fromARGB(255, 142, 139, 139)),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: Color.fromARGB(255, 142, 139, 139)),
                  onPressed: () {
                    widget.controller.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 142, 139, 139)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 142, 139, 139)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => widget.onSubmitted(),
      ),
    );
  }
}
