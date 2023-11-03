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

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create your profile'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Consumer<UserModel>(builder: (context, user, child) {
            _nameController.text = user.name;
            _taglineController.text = user.tagline;
            return Column(
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
                ElevatedButton(
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
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Padding getSpacer({double height = 8}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: height));
}
