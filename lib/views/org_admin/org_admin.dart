import 'package:flutter/material.dart';

void main() => runApp(BestLabApp());

class BestLabApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BestLab'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InfoCard(
                  icon: Icons.computer,
                  title: 'Thiết Bị',
                  count: 10,
                ),
                InfoCard(
                  icon: Icons.people,
                  title: 'Tài khoản',
                  count: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Replace with the actual number of users
              itemBuilder: (context, index) {
                return UserTile();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;

  InfoCard({required this.icon, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.blue)),
          SizedBox(height: 5),
          Text('$count', style: TextStyle(fontSize: 24, color: Colors.blue)),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text('Username'),
        subtitle: Text('Developer'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit action
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete action
              },
            ),
          ],
        ),
      ),
    );
  }
}
