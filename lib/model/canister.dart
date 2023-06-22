import 'dart:core';

class Canister {
  int? canisterId;
  String? extra;
  String? canisterName;
  String? canisterNameLang;
  int? materialId;
  double? time;
  double? recipeTotal;
  double? recipeRemain;
  double? testResult;
  int? isBIBCan;
  String? lastCleanTime;
  int? isShowed;
  double? testCurrent;
  double? lackRemain;
  String? date;

  Canister(
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

  Canister.fromMap(Map<String, dynamic> map) {
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
