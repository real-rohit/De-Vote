// lib/services/blockchain_service.dart
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:io';

const String rpcUrl = "http://172.16.22.62:7545"; // Use your host machine's IP
const String contractAddress = "0xb9712009bDb715ce2fe06b6603D28d42A79FE094";
const String contractABI = '''[
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "candidateId",
				"type": "uint256"
			}
		],
		"name": "getVoteCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "hasVoted",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "candidateId",
				"type": "uint256"
			}
		],
		"name": "vote",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "voteCounts",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
''';
const String privateKey =
    "0xec91237e27d1b92d72287d5c9c61b4b84dff6f839cb72da9e689ae11e564981a";

class BlockchainService {
  late Web3Client client;
  late EthPrivateKey credentials;
  late DeployedContract contract;

  BlockchainService() {
    int retryCount = 3;
    while (retryCount > 0) {
      try {
        client = Web3Client(rpcUrl, Client());
        credentials = EthPrivateKey.fromHex(privateKey);
        contract = DeployedContract(
          ContractAbi.fromJson(contractABI, "Voting"),
          EthereumAddress.fromHex(contractAddress),
        );
        print("Connected to blockchain node successfully.");
        break;
      } on SocketException catch (e) {
        retryCount--;
        print(
          "Error: Unable to connect to the blockchain node. Retrying... ($retryCount retries left). Details: $e",
        );
        if (retryCount == 0) {
          print("Failed to connect to the blockchain node after retries.");
          rethrow;
        }
        sleep(Duration(seconds: 2)); // Wait before retrying
      } catch (e) {
        print("Unexpected error during initialization: $e");
        rethrow;
      }
    }
  }
  Future<String> vote(int candidateId) async {
    try {
      print("Preparing to send transaction...");
      final voteFunction = contract.function("vote");
      print("Calling vote function with candidateId: $candidateId");

      // Log transaction details
      final transaction = Transaction.callContract(
        contract: contract,
        function: voteFunction,
        parameters: [BigInt.from(candidateId)],
      );
      print("Transaction details: $transaction");
      final txHash = await client
          .sendTransaction(
            credentials,
            transaction,
            chainId: 1337, // Ganache's default chain ID
          )
          .catchError((error) {
            print("Error during sendTransaction: $error");
            throw Exception("Failed to send transaction.");
          });
      print("Transaction sent successfully. Hash: $txHash");
      return txHash;
    } on SocketException catch (e) {
      print("Error: Unable to connect to the blockchain node. Details: $e");
      throw Exception("Connection to blockchain node failed.");
    } catch (e) {
      print("Unexpected error during vote transaction: $e");
      throw Exception("Failed to cast vote.");
    }
  }

  Future<Map<String, int>> getVoteCounts(
    List<Map<String, String>> candidates,
  ) async {
    final getVoteCountFunction = contract.function("getVoteCount");
    Map<String, int> counts = {};
    for (var candidate in candidates) {
      BigInt result =
          (await client.call(
                contract: contract,
                function: getVoteCountFunction,
                params: [BigInt.from(int.parse(candidate["id"]!))],
              ))[0]
              as BigInt;
      counts[candidate["id"]!] = result.toInt();
    }
    return counts;
  }
}
