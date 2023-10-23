import 'dart:collection';
import 'dart:isolate';

class IsolatesPool {
  late int _numOfIsoalates;

  IsolatesPool({int numOfIsoalates = 5}) {
    _numOfIsoalates = numOfIsoalates;
  }

  Future<void> checkNums(List<int> nums) async {
    if (nums.isEmpty) {
      print("WARNING: nums list is empty");
      return;
    }

    if (nums.length < _numOfIsoalates) {
      _numOfIsoalates = nums.length;
    }

    Queue<int> numsQueue = Queue.from(nums);

    for (int i = 0; i < _numOfIsoalates; i++) {
      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(_primeCheckerFunc, receivePort.sendPort);
      SendPort? sendPort;
      int? sentNum;

      receivePort.listen((message) {
        if (message is SendPort && sendPort == null) {
          sendPort = message;
          if (numsQueue.isNotEmpty) {
            sentNum = numsQueue.removeFirst();

            sendPort!.send(sentNum);
          } else {
            sendPort!.send(true);
          }
        } else if (message is bool) {
          print(
              "Message from $i isolate: Num $sentNum is${message ? " " : " not"} prime");
          if (numsQueue.isNotEmpty) {
            sentNum = numsQueue.removeFirst();
            sendPort!.send(sentNum);
          } else {
            print("Queue is empty, closing $i isolate");
            sendPort!.send(true);
            receivePort.close();
          }
        } else {
          print("WARNING: received unknown message from isolate $message");
        }
      });
    }
  }

  void _primeCheckerFunc(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    Future<bool> isPrime(int num) async {
      // Имитируем "тяжелую" логику
      await Future.delayed(Duration(milliseconds: 250));
      if (num <= 1) {
        return false;
      }
      for (int i = 2; i * i <= num; i++) {
        if (num % i == 0) {
          return false;
        }
      }
      return true;
    }

    receivePort.listen(
      (message) async {
        if (message is int) {
          final res = await isPrime(message);
          sendPort.send(res);
        } else if (message is bool) {
          receivePort.close();
        } else {
          print("Unknown message type of message: $message");
        }
      },
    );
  }
}
