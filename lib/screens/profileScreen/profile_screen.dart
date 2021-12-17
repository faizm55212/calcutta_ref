import 'package:cached_network_image/cached_network_image.dart';
import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: Api().fetchProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        snapshot.data!['image'] ?? ''),
                    radius: 50,
                  ),
                ),
                Text(snapshot.data!['name'] ?? 'Unknown'),
                Text('General'),
                ListTile(
                  leading: Text('Email:'),
                  title: Text(
                    snapshot.data!['email'] ?? 'Unknown@gmail.com',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  leading: Text('Mobile:'),
                  title: Text(
                    snapshot.data!['mobile'].toString(),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  leading: Text('Address:'),
                  title: Text(
                    snapshot.data!['address'] ?? 'Please Update',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          }),
    );
  }
}
