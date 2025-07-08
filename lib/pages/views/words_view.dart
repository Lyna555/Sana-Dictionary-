import 'package:flutter/material.dart';
import '../../models/word_model.dart';

class WordsView extends StatefulWidget {
  final List<SanaWord> words;
  final String textTitle;
  final VoidCallback onBack;

  const WordsView({Key? key, required this.words, required this.textTitle, required this.onBack})
      : super(key: key);

  @override
  State<WordsView> createState() => _WordsViewState();
}

class _WordsViewState extends State<WordsView> {
  late List<SanaWord> filteredWords;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredWords = widget.words;
  }

  void filterWords(String query) {
    setState(() {
      filteredWords = widget.words
          .where((word) => word.word.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              labelText: 'ابحث عن كلمة',
              labelStyle: const TextStyle(fontSize: 17),
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: filterWords,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredWords.length,
            itemBuilder: (context, index) {
              final word = filteredWords[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${word.word}:',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(214, 177, 99, 1.0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      Text('شرحها: ${word.explanation}', style: const TextStyle(fontSize: 16)),
                      const Divider(),
                      Text('توظيفها: ${word.example}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}