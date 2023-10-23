// import 'dart:isolate';

// import 'package:test_task/models/isolate_pool.dart';

// class PrimeChecker {
//   final int _id;
//   final SendPort _sendPort;
//   bool _isLocked = false;

//   bool get isLocked => _isLocked;

//   PrimeChecker._(this._id, this._sendPort);

//   static Future<PrimeChecker> createIsolate({required int id}) async {
//     final ReceivePort receivePort = ReceivePort();
//     await Isolate.spawn(primeCheckerFunc, receivePort.sendPort);
//     final SendPort sendPort = await receivePort.first;
//     return PrimeChecker._(id, sendPort);
//   }

//   void sendNum(int num) {
//     _sendPort.send(
//       {
//         "num": num,
//         "id": _id,
//         "receiver": IsolatesPool.instance.receivePort.sendPort
//       },
//     );
//   }
// }

// void primeCheckerFunc(SendPort sendPort) {
//   ReceivePort receivePort = ReceivePort();
//   sendPort.send(receivePort.sendPort);

//   bool isPrime(int num) {
//     if (num <= 1) {
//       return false;
//     }
//     for (int i = 2; i * i <= num; i++) {
//       if (num % i == 0) {
//         return false;
//       }
//     }
//     return true;
//   }

//   receivePort.listen(
//     (message) {
//       if (message is Map) {
//         SendPort sendPort = message['receiver'] as SendPort;
//         final num = message['num'];
//         sendPort.send(
//           {
//             "id": message['id'],
//             "num": num,
//             "result": isPrime(num),
//           },
//         );
//       } else if (message is bool) {
//         receivePort.close();
//       } else {
//         print("Unknown message type of message: $message");
//       }
//     },
//   );
// }
