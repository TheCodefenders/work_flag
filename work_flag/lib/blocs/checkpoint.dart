class CheckpointBloc {
  final int id;
  final DateTime date;
  final DateTime start;
  DateTime stop;
  final String address;

  CheckpointBloc({this.id, this.date, this.start, this.stop, this.address});

  @override
  String toString() {
    return 'CheckpointBloc{id: $id, date: $date, start: $start, stop: $stop, address: $address}';
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "date" : date.toString(),
      "start" : start.toString(),
      "stop" : stop.toString(),
      "address" : address
    };
  }
}