// lib/screens/results_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/blockchain_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final List<Map<String, String>> candidates = [
    {"id": "0", "name": "Candidate A"},
    {"id": "1", "name": "Candidate B"},
  ];
  final BlockchainService blockchainService = BlockchainService();
  bool isLoading = false;
  Map<String, int> voteCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchVoteCounts();
  }

  Future<void> _fetchVoteCounts() async {
    setState(() => isLoading = true);
    try {
      Map<String, int> counts = await blockchainService.getVoteCounts(
        candidates,
      );
      setState(() {
        voteCounts = counts;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching votes: $e");
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildResultCard(Map<String, String> candidate) {
    String id = candidate["id"]!;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(candidate["name"]!),
        subtitle: Text("Votes: ${voteCounts[id] ?? 0}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Results")),
      body: RefreshIndicator(
        onRefresh: _fetchVoteCounts,
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                  padding: EdgeInsets.all(16),
                  children: candidates.map((c) => _buildResultCard(c)).toList(),
                ),
      ),
    );
  }
}
