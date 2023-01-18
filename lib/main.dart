import 'dart:convert';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

import 'widgets/scrollable_list.dart';

Faker faker = Faker();
List<String> names = List<String>.generate(
    20, (index) => faker.person.firstName(),
    growable: true);

List<HintEntry> entries = [];

/// Main function of the app.
void main() {
  runApp(const App());
}

/// App widget : builds the Password Hints app with a dark theme.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Home(),
      ),
      title: 'Passwd Hints',
    );
  }
}

/// Home widget : contains the state of the app.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// _HomeState widget : defines the state of the app.
class _HomeState extends State<Home> {
  final FileController controller = FileController();
  final alphabets = List.generate(
      26, (index) => String.fromCharCode(index + firstLetterIndex));
  int _searchIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  /// Sets the search index after a tap on searchLetter on the screen.
  /// If a matching entry is directly found, jumps to it. Otherwise, it
  /// reads the next entries and jumps to the first found. If there is no entry
  /// after the searched one, no jump is performed.
  void setSearchIndex(String searchLetter) {
    setState(() {
      _searchIndex = names.indexWhere((element) => element[0] == searchLetter);
      // Entry directly found
      if (_searchIndex >= 0) {
        _itemScrollController.jumpTo(index: _searchIndex);
        // Entry not found : investigating next letters
      } else {
        var i = 0;
        var asciiLetter = searchLetter.codeUnitAt(0);
        while (_searchIndex < 0) {
          if (i + asciiLetter > firstLetterIndex + zIndex) {
            break;
          }
          ++i;
          _searchIndex = names.indexWhere(
              (element) => element[0] == String.fromCharCode(asciiLetter + i));
        }

        if (_searchIndex >= 0) {
          _itemScrollController.jumpTo(index: _searchIndex);
        } else {
          if (names.isNotEmpty) {
            _searchIndex = names.length - 1;
            _itemScrollController.jumpTo(index: _searchIndex);
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    names.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  /*
  Widget getMainContentWidget(List names) {
    if (names.isEmpty) {
      return EmptyListCard();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      child: ScrollablePositionedList.separated(
        separatorBuilder: (context, index) =>
            HorizontalLabeledSeparator(names, index),
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: names.length + 1,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: Card(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            names[index - 1],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
    
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text('Passwd Hints'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: AppSearchDelegate(names));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          //getMainContentWidget(names),
          ScrollableList(names, _itemScrollController, _itemPositionsListener),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 10),
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: alphabets
                  .map((alphabet) => InkWell(
                        onTap: () {
                          setSearchIndex(alphabet);
                        },
                        child: Text(
                          alphabet,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController hintController = TextEditingController();
          TextEditingController identifierController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('New hint'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              suffixText: '*',
                              suffixStyle: TextStyle(
                                color: Colors.red,
                              ),
                              icon: Icon(Icons.short_text),
                            ),
                          ),
                          TextFormField(
                            controller: hintController,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              labelText: 'Hint',
                              suffixText: '*',
                              suffixStyle: TextStyle(
                                color: Colors.red,
                              ),
                              icon: Icon(Icons.remove_red_eye),
                            ),
                          ),
                          TextFormField(
                            controller: identifierController,
                            decoration: InputDecoration(
                              labelText: 'Email/Username',
                              icon: Icon(Icons.alternate_email),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text('Add'),
                      onPressed: () {
                        // handle
                        controller.addEntry(nameController.text,
                            hintController.text, identifierController.text);
                        controller.readEntries();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
        shape: CircleBorder(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AppSearchDelegate extends SearchDelegate {
  final List<String> names;

  AppSearchDelegate(this.names);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => Center(
      child: Text(query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)));

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = names.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class FileController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<int> addEntry(String name, String hint, String identifier) async {
    final file = await _localFile;

    HintEntry entry = HintEntry(name, hint, identifier);
    entries.add(entry);
    entries
        .map(
          (player) => entry.toJson(),
        )
        .toList();

    file.writeAsStringSync(json.encode(entries));
    // Write the file
    return 0;
  }

  Future<int> readEntries() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      var jsonResponse = jsonDecode(contents);

      for (var e in jsonResponse) {
        HintEntry entry = HintEntry(e['name'], e['hint'], e['identifier']);
        print(entry.name);
        print(entry.hint);
        print(entry.identifier);
      }

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}

class HintEntry {
  late String name;
  late String hint;
  late String identifier;

  HintEntry(this.name, this.hint, this.identifier);

  HintEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hint = json['hint'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['hint'] = hint;
    data['identifier'] = identifier;

    return data;
  }
}
