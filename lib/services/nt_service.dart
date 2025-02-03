
import 'package:nt4/nt4.dart';

class NTService {
  late NT4Client client;

  NTService(String ip) {
    createCleint(ip);
  }

  void createCleint(String ip) {
    client = NT4Client(
    serverBaseAddress: ip,
    onConnect: () {
      print('connected');
    },
    onDisconnect: () {
      print('disconnected');
    }
  );
  }

  NT4Topic createNTValue(String ntPath, String type) {
    NT4Topic pub = client.publishNewTopic(ntPath, type);
    return pub;
  }

  void postValue(NT4Topic topic, dynamic value) {
    client.addSample(topic, value);
  }
}
