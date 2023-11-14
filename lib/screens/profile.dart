import 'package:coding_club/models/user.dart';
import 'package:coding_club/screens/clubs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ClubPageState();
}

class _ClubPageState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _editing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _editing = Navigator.of(context).canPop();
    return Consumer<UserModel>(builder: (context, user, child) {
      _nameController.text = user.name;
      _taglineController.text = user.tagline;
      return WillPopScope(
        onWillPop: () {
          if (_formKey.currentState!.validate()) {
            user.update(
                name: _nameController.text, tagline: _taglineController.text);
            return Future(() => true);
          } else {
            return Future(() => false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('${_editing ? 'Edit' : 'Create'} your profile'),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                  getSpacer(),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Tagline'),
                    controller: _taglineController,
                  ),
                  getSpacer(height: 16),
                  (() {
                    if (!_editing) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            user.update(
                                name: _nameController.text,
                                tagline: _taglineController.text);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ClubsScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }())
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Padding getSpacer({double height = 8}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: height));
}
