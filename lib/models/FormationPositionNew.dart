class FormationPositionNew {
  int? position;
  String? name;
  String? documentID;
  String? imageUrl;

  FormationPositionNew(
      this.name, this.position, this.documentID, this.imageUrl);

  FormationPositionNew.empty();

  @override
  String toString() {
    return "Name: $name \t Position: $position";
  }
}
