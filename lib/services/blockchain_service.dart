// lib/services/blockchain_service.dart
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

const String rpcUrl = "HTTP://127.0.0.1:7545"; // Ganache URL
const String contractAddress = "YOUR_CONTRACT_ADDRESS_HERE";
const String contractABI = '''
[
  {
    "inputs": [{"internalType": "uint256","name": "candidateId","type": "uint256"}],
    "name": "vote",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "uint256","name": "candidateId","type": "uint256"}],
    "name": "getVoteCount",
    "outputs": [{"internalType": "uint256","name": "","type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  }
]
''';
const String privateKey = "YOUR_PRIVATE_KEY_HERE";

class BlockchainService {
  late Web3Client client;
  late EthPrivateKey credentials;
  late DeployedContract contract;

  BlockchainService() {
    client = Web3Client(rpcUrl, Client());
    credentials = EthPrivateKey.fromHex(privateKey);
    contract = DeployedContract(
      ContractAbi.fromJson(contractABI, "Voting"),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  Future<String> vote(int candidateId) async {
    final voteFunction = contract.function("vote");
    final txHash = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: voteFunction,
        parameters: [BigInt.from(candidateId)],
      ),
    );
    return txHash;
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
