import 'package:coding_club/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
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
                      if (await Provider.of<UserModel>(context, listen: false).joinClub(codeController.text)) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                          msg: "Invalid Join Code",
                        );
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
