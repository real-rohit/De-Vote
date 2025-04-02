// lib/screens/voting_screen.dart
import 'package:de_vote/services/blockchain_service.dart';
import 'package:de_vote/widgets/candidate_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  // Sample candidate list
  final List<Map<String, String>> candidates = [
    {"id": "0", "name": "Candidate A", "party": "Party X"},
    {"id": "1", "name": "Candidate B", "party": "Party Y"},
  ];
  int selectedCandidateId = 0;
  bool isLoading = false;
  String transactionHash = '';
  final BlockchainService blockchainService = BlockchainService();

  Future<void> _castVote() async {
    setState(() {
      isLoading = true;
    });
    try {
      String txHash = await blockchainService.vote(selectedCandidateId);
      setState(() {
        transactionHash = txHash;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Vote Cast Successfully"),
              content: Text("Transaction Hash: $transactionHash"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Error casting vote")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCandidateList() {
    return ListView.builder(
      itemCount: candidates.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return CandidateCard(
          candidate: candidates[index],
          groupValue: selectedCandidateId,
          onChanged: (val) {
            setState(() {
              selectedCandidateId = val;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cast Your Vote")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildCandidateList()),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _castVote,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text("Submit Vote", style: TextStyle(fontSize: 18)),
                ),
          ],
        ),
      ),
    );
  }
}
