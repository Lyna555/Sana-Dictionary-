import 'package:flutter/material.dart';
import '../../models/text_model.dart';

class TextsView extends StatefulWidget {
  final List<SanaText> texts;
  final Function(int, String) onTextSelected;

  const TextsView({Key? key, required this.texts, required this.onTextSelected})
      : super(key: key);

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
          .where(
              (text) => text.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: const Text(
              'قائمة النصوص:',
              style: TextStyle(
                color: Color.fromRGBO(214, 177, 99, 1.0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                labelText: 'ابحث عن نص',
                labelStyle: const TextStyle(fontSize: 17),
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterTexts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTexts.length,
              itemBuilder: (context, index) {
                final text = filteredTexts[index];
                return GestureDetector(
                  onTap: () => widget.onTextSelected(text.id, text.title),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        opacity: 0.7,
                        image: NetworkImage(text.photoURL ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                text.author ?? '-',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}