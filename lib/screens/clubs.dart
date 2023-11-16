import 'package:coding_club/auth.dart';
import 'package:coding_club/models/user.dart';
import 'package:coding_club/screens/join.dart';
import 'package:coding_club/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, child) {
      if (!user.loaded) {
        Auth.signIn().then((uid) async {
          if (uid != null) {
            bool userLoaded = await user.load(uid);
            if (!context.mounted) return;
            if (!userLoaded) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ProfileScreen()));
            } else {
              await user.preloadImages(context);
            }
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Clubs'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_circle),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
              )
            ]),
        body: Container(
            margin: const EdgeInsets.all(16),
            child: user.clubs.isNotEmpty
                ? getClubTiles(user)
                : const Center(
                    child: Text("Join a club"),
                  )),
        floatingActionButton: SizedBox(
          width: 112,
          height: 56,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const JoinScreen()));
            },
            child: Container(
                padding: const EdgeInsets.all(16),
                child: const Text("Join Club")),
          ),
        ),
      );
    });
  }

  Widget getClubTiles(UserModel user) {
    List<ListTile> tiles = [];
    for (var club in user.clubs) {
      tiles.add(ListTile(
        title: Text(club.name),
        subtitle: Text(club.latestMessage),
        leading: club.imgUrl != '' ? Image.network(club.imgUrl) : null,
      ));
    }
    return ListView(
      children: tiles,
    );
  }
}
