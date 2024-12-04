class Notice {
   String? id;
   String? title;
   String? date;
   String? imageUrl;
   String? description;
   String? type;
   int? color;

  Notice({
    this.id,
    this.title,
    this.date,
    this.imageUrl,
    this.description,
    this.type,
    this.color,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'imageUrl': imageUrl,
      'description': description,
      'type': type,
      'color': color,
    };
  }
}