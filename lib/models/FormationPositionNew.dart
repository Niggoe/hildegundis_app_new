class FormationPositionNew {
  int? position;
  String? user_id;
  String? documentID;

  FormationPositionNew(this.position, this.user_id, this.documentID);

  FormationPositionNew.empty();

  @override
  String toString() {
    return "Name: $user_id \t Position: $position";
  }
}
