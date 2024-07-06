import 'package:flutter/material.dart';
import 'package:sq_lite/screens/note_screen.dart';
import 'package:sq_lite/services/database_helper.dart';
import 'package:sq_lite/widgets/note_widget.dart';

import 'models/note_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Note app with SQLite'),
      ),
      body: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.getAllNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  return NoteWidget(
                    note: snapshot.data![index],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteScreen(
                            note: snapshot.data![index],
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Are you sure you want to delete this note?',
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  DatabaseHelper.deleteNote(
                                      snapshot.data![index]);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: const Text('Delete'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('You do not add any note yet!'));
            }
          } else {
            return const Center(child: Text('You do not add any note yet!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteScreen(),
            ),
          );
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
