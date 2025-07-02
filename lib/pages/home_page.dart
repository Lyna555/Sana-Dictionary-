import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/text_model.dart';
import '../../models/word_model.dart';
import '../../services/text_service.dart';
import '../../services/word_service.dart';
import '../main.dart';
import 'views/texts_view.dart';
import 'views/words_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SanaText>> _textsFuture;
  Future<List<SanaWord>>? _wordsFuture;

  int? selectedTextId;
  String? selectedTextTitle;

  List<SanaText> allTexts = [];
  List<SanaWord> allWords = [];

  @override
  void initState() {
    super.initState();
    _textsFuture = TextService.getAllTexts();
    _textsFuture.then((texts) {
      setState(() {
        allTexts = texts;
      });
    });
  }

  void selectText(int textId, String title) {
    setState(() {
      selectedTextId = textId;
      selectedTextTitle = title;
      _wordsFuture = WordService.getTextWords(textId);
      _wordsFuture!.then((words) {
        setState(() {
          allWords = words;
        });
      });
    });
  }

  void goBackToTexts() {
    setState(() {
      selectedTextId = null;
      selectedTextTitle = null;
      _wordsFuture = null;
      allWords = [];
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(93, 151, 144, 1.0),
            ),
            child: Text(
              'معجم سنا',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('قائمة النصوص'),
            tileColor: themeNotifier.value == ThemeMode.dark
                ? Colors.grey[700]
                : Colors.grey[200],
            iconColor: const Color.fromRGBO(214, 177, 99, 1.0),
            onTap: () {
              Navigator.pop(context);
              goBackToTexts();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('بخصوص التطبيق'),
            selectedTileColor: themeNotifier.value == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            iconColor: const Color.fromRGBO(214, 177, 99, 1.0),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'معجم سنا',
                applicationVersion: '1.0.0',
                children: const [
                  Text(
                      'هذا التطبيق يوفر شرحًا للكلمات الصعبة في نصوص كتب اللغة العربية الخاصة بطور الثانوية.')
                ],
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text(themeNotifier.value == ThemeMode.dark
                ? 'الوضع النهاري'
                : 'الوضع الليلي'),
            secondary: Icon(themeNotifier.value == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            value: themeNotifier.value == ThemeMode.dark,
            onChanged: (bool value) async {
              final prefs = await SharedPreferences.getInstance();
              final mode = value ? ThemeMode.dark : ThemeMode.light;

              setState(() {
                themeNotifier.value = mode;
              });

              await prefs.setString('themeMode', value ? 'dark' : 'light');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(selectedTextTitle ?? 'معجم سنا'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(93, 151, 144, 1.0),
        actions: selectedTextId != null
            ? [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: goBackToTexts,
                ),
              ]
            : null,
      ),
      body: selectedTextId == null ? buildTextList() : buildWordsList(),
    );
  }

  Widget buildTextList() {
    return FutureBuilder<List<SanaText>>(
      future: _textsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد نصوص'));
        }

        return TextsView(
          texts: snapshot.data!,
          onTextSelected: selectText,
        );
      },
    );
  }

  Widget buildWordsList() {
    return FutureBuilder<List<SanaWord>>(
      future: _wordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد كلمات'));
        }

        return WordsView(
          words: snapshot.data!,
          textTitle: selectedTextTitle ?? '',
          onBack: goBackToTexts,
        );
      },
    );
  }
}
