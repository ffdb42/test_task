import 'dart:math';

import 'package:test_task/isolate_pool.dart';

void main(List<String> arguments) {
  List<int> nums = [];
  int numsLength = 20;
  int numOfIsoalates = 5;

  for (int i = 0; i < numsLength; i++) {
    nums.add(Random().nextInt(100000));
  }

  IsolatesPool pool = IsolatesPool(numOfIsoalates: numOfIsoalates);

  pool.checkNums(nums);
}
