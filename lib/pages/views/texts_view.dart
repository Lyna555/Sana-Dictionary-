import 'package:flutter/material.dart';
import '../../models/text_model.dart';

class TextsView extends StatefulWidget {
  final List<SanaText> texts;
  final Function(int, String) onTextSelected;

  const TextsView({Key? key, required this.texts, required this.onTextSelected}) : super(key: key);

  @override
  State<TextsView> createState() => _TextsViewState();
}

class _TextsViewState extends State<TextsView> {
  late List<SanaText> filteredTexts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredTexts = widget.texts;
  }

  void filterTexts(String query) {
    setState(() {
      filteredTexts = widget.texts
          .where((text) => text.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'ابحث عن نص',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: filterTexts,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'قائمة النصوص:',
            style: TextStyle(
              color: Color.fromRGBO(214, 177, 99, 1.0),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTexts.length,
            itemBuilder: (context, index) {
              final text = filteredTexts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(text.title),
                  subtitle: Text(
                    text.author ?? '-',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => widget.onTextSelected(text.id, text.title),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
