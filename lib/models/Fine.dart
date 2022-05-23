class Fine {
  String? name;
  DateTime? date;
  String? reason;
  bool? payed;
  double? amount;
  int? id;

  Fine.from(Fine other)
      : amount = other.amount,
        name = other.name,
        date = other.date,
        reason = other.reason,
        payed = other.payed,
        id = other.id;

  Fine();

  @override
  String toString() {
    return "Name: ${this.name} Betrag: ${this.amount}";
  }
}
