class FormationPosition {
  int? position;
  String? name;
  int? formation;
  String? documentID;

  FormationPosition(this.formation, this.name, this.position, this.documentID);

  FormationPosition.empty();

  @override
  String toString() {
    return "Formation: $formation -reihe \t Name: $name \t Position: $position";
  }
}
