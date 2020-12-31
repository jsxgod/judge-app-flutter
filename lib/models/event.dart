class Event {
  final int id;
  final String startDate;
  final String localization;
  final String description;
  final String judgeQR;
  final int organizer;

  Event(this.id, this.startDate, this.localization, this.description, this.judgeQR, this.organizer);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startDate = json['start_date'],
        localization = json['localization'],
        description = json['description'],
        judgeQR = json['judge_qr'],
        organizer = json['organizer'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'start_date': startDate,
        'localization': localization,
        'description': description,
        'judge_qr': judgeQR,
        'organizer': organizer
      };
}