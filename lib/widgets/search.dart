import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.controller, required this.onSearch});
  final TextEditingController controller;
  final Function onSearch;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onEditingComplete: (){
        widget.controller.text = widget.controller.text.trim();
        if (widget.controller.text.isNotEmpty) {
          FocusScope.of(context).unfocus();
          widget.onSearch();
        }
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        hintText: "Search Here..",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: Colors.blue),
          gapPadding: 5,
        ),
        suffixIcon: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: TextButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Search"),
            ),
            onPressed: () {
              widget.controller.text = widget.controller.text.trim();
              if (widget.controller.text.isNotEmpty) {
                FocusScope.of(context).unfocus();
                widget.onSearch();
              }
              widget.onSearch();
            },
          ),
        ),
      ),
    );
  }
}
