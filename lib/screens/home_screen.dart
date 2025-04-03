import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      _buildDashboard(),
      _buildVoteScreen(),
      _buildResultsScreen(),
      _buildEducationScreen(),
      _buildProfileScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white60,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.how_to_vote), label: "Vote"),
          BottomNavigationBarItem(icon: Icon(Icons.poll), label: "Results"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome, Voter!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _luxuryButton(
            "Cast Your Vote",
            Icons.how_to_vote,
            '/vote',
            Colors.red,
          ),
          SizedBox(height: 15),
          _luxuryButton(
            "View Live Results",
            Icons.poll,
            '/results',
            Colors.white,
          ),
          SizedBox(height: 15),
          _luxuryButton(
            "Learn About Voting",
            Icons.book,
            '/education',
            Colors.grey,
          ),
          SizedBox(height: 15),
          _luxuryButton("Profile", Icons.person, '/profile', Colors.white),
        ],
      ),
    );
  }

  Widget _luxuryButton(String text, IconData icon, String route, Color color) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon, size: 26, color: Colors.black),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 55),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  Widget _buildVoteScreen() {
    return Center(
      child: Text(
        "Voting Page",
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget _buildResultsScreen() {
    return Center(
      child: Text(
        "Results Page",
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget _buildEducationScreen() {
    final videoId = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=QfICeBtVv8U",
    ); // Example video URL
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId!,
                flags: const YoutubePlayerFlags(autoPlay: false),
              ),
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 20),
            const Text(
              "Why Should You Vote?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Voting is a fundamental right and responsibility of every citizen. "
              "It allows you to have a say in the decisions that affect your life and community. "
              "By voting, you contribute to shaping the future of your country.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    // Example profile data fetched from verification_screen.dart
    final profileData = {
      "Name": "John Doe",
      "Age": "30",
      "Gender": "Male",
      "Aadhaar": "1234-5678-9012",
      "Voter ID": "ABC1234567",
      "Phone": "+1234567890",
      "Email": "johndoe@example.com",
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...profileData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    "${entry.key}: ",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
