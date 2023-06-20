import 'dart:core';

class Step {
  int? canisterId;
  String? extra;
  String? canisterName;
  String? canisterNameLang;
  int? materialId;
  String? time;
  String? recipeTotal;
  String? recipeRemain;
  String? testResult;
  int? isBIBCan;
  String? lastCleanTime;
  int? isShowed;
  String? testCurrent;
  String? lackRemain;
  String? date;

  Step(
      this.canisterId,
      this.extra,
      this.canisterName,
      this.canisterNameLang,
      this.materialId,
      this.time,
      this.recipeTotal,
      this.recipeRemain,
      this.testResult,
      this.isBIBCan,
      this.lastCleanTime,
      this.isShowed,
      this.testCurrent,
      this.lackRemain,
      this.date);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['canisterId'] = canisterId;
    map['extra'] = extra;
    map['canisterName'] = canisterName;
    map['canisterNameLang'] = canisterNameLang;
    map['materialId'] = materialId;
    map['time'] = time;
    map['recipeTotal'] = recipeTotal;
    map['recipeRemain'] = recipeRemain;
    map['testResult'] = testResult;
    map['isBIBCan'] = isBIBCan;
    map['lastCleanTime'] = lastCleanTime;
    map['isShowed'] = isShowed;
    map['testCurrent'] = testCurrent;
    map['lackRemain'] = lackRemain;
    map['date'] = date;
    return map;
  }

  Step.fromMap(Map<String, dynamic> map) {
    canisterId = map['canisterId'];
    extra = map['extra'];
    canisterName = map['canisterName'];
    canisterNameLang = map['canisterNameLang'];
    materialId = map['materialId'];
    time = map['time'];
    recipeTotal = map['recipeTotal'];
    recipeRemain = map['recipeRemain'];
    testResult = map['testResult'];
    isBIBCan = map['isBIBCan'];
    lastCleanTime = map['lastCleanTime'];
    isShowed = map['isShowed'];
    testCurrent = map['testCurrent'];
    lackRemain = map['lackRemain'];
    date = map['date'];
  }
}