class Recipe {
  int? id;
  String? extra;
  String? canisterIds;
  String? recipeName;
  String? stepses;
  String? esAttr;
  String? instantAttr;
  String? date;

  Recipe(this.id, this.extra, this.canisterIds, this.recipeName, this.stepses,
      this.esAttr, this.instantAttr, this.date);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    id = map['id'];
    map['extra'] = extra;
    map['canisterIds'] = canisterIds;
    map['recipeName'] = recipeName;
    map['stepses'] = stepses;
    map['esAttr'] = esAttr;
    map['instantAttr'] = instantAttr;
    map['date'] = date;
    return map;
  }


  Recipe.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    extra = map['extra'];
    canisterIds = map['canisterIds'];
    recipeName = map['recipeName'];
    stepses = map['stepses'];
    esAttr = map['esAttr'];
    instantAttr = map['instantAttr'];
    date = map['date'];
  }
}

