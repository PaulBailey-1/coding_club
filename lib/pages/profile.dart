import 'package:coding_club/pages/club.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final taglineController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create your profile'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: nameController,
            ),
            getSpacer(),
            TextField(
              decoration: const InputDecoration(labelText: 'Tagline'),
              controller: taglineController,
            ),
            getSpacer(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ClubPage(),
                  ),
                );
              },
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding getSpacer({double height = 8}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: height));
}
