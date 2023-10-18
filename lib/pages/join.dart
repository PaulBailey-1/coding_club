
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service.dart';
import 'profile.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Join your Club'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 64),
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter a join code', style: TextStyle(fontSize: 20)),
                TextField(
                  controller: codeController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: 'XXX-XXX'),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                ElevatedButton(
                    onPressed: () async {
                      if (await Service().joinClub(codeController.text)) {
                        if (!context.mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast( msg: "Invalid Join Code", );
                      }
                    },
                    child: const Text('Join', style: TextStyle(fontSize: 20))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
