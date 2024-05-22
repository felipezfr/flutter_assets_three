import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.hitText,
    required this.onSearch,
  });

  final String hitText;
  final Function(String value) onSearch;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final ValueNotifier<String> searchTerm = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        onChanged: (value) {
          searchTerm.value = value;
          widget.onSearch(value);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: widget.hitText,
          icon: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.search,
              color: Color(0xFF8E98A3),
            ),
          ),
        ),
      ),
    );
  }
}
