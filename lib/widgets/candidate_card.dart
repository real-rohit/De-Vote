// lib/widgets/candidate_card.dart
import 'package:flutter/material.dart';

class CandidateCard extends StatelessWidget {
  final Map<String, String> candidate;
  final int groupValue;
  final ValueChanged<int> onChanged;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    int candidateId = int.parse(candidate["id"]!);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            candidate["name"]!.substring(0, 1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          candidate["name"]!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          candidate.containsKey("party") ? candidate["party"]! : "",
        ),
        trailing: Radio<int>(
          value: candidateId,
          groupValue: groupValue,
          onChanged: (int? value) {
            onChanged(value!);
          },
        ),
      ),
    );
  }
}
