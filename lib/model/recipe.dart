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
