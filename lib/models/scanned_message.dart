class ScannedMessage {
  final String address;
  final String body;
  final DateTime date;
  final bool isSpam;

  ScannedMessage({
    required this.address,
    required this.body,
    required this.date,
    required this.isSpam,
  });

  factory ScannedMessage.fromMap(Map<String, dynamic> map) {
    return ScannedMessage(
      address: map['address'] ?? '',
      body: map['body'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      isSpam: map['isSpam'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'body': body,
      'date': date.millisecondsSinceEpoch,
      'isSpam': isSpam,
    };
  }
}
