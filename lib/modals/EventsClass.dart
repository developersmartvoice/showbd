class Event {
  final int id;
  final int userId;
  final String name;
  final String image;
  final String description;
  final String startDate;
  final String startDateTime;
  final String endDate;
  final String location;
  final int sliderView;
  final List<int>? interested;
  final List<int>? going;
  final List<int>? notGoing;

  Event({
    required this.id,
    required this.userId,
    required this.name,
    required this.image,
    required this.description,
    required this.startDate,
    required this.startDateTime,
    required this.endDate,
    required this.location,
    required this.sliderView,
    this.interested,
    this.going,
    this.notGoing,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      image: json['image_url'],
      description: json['description'],
      startDate: json['start_date'],
      startDateTime: json['start_date_time'],
      endDate: json['end_date'],
      location: json['location'],
      sliderView: json['slider_view'],
      interested: json['interested'] != null
          ? (json['interested'] as String)
              .split(',')
              .where((id) => id.isNotEmpty)
              .map((id) => int.parse(id))
              .toList()
          : null,
      going: json['going'] != null
          ? (json['going'] as String)
              .split(',')
              .where((id) => id.isNotEmpty)
              .map((id) => int.parse(id))
              .toList()
          : null,
      notGoing: json['not_going'] != null
          ? (json['not_going'] as String)
              .split(',')
              .where((id) => id.isNotEmpty)
              .map((id) => int.parse(id))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'image_url': image,
      'description': description,
      'start_date': startDate,
      'start_date_time': startDateTime,
      'end_date': endDate,
      'location': location,
      'slider_view': sliderView,
      'interested': interested?.join(','),
      'going': going?.join(','),
      'not_going': notGoing?.join(','),
    };
  }
}

class EventResponseClass {
  final bool success;
  final List<Event> events;

  EventResponseClass({required this.success, required this.events});

  factory EventResponseClass.fromJson(Map<String, dynamic> json) {
    var eventList = json['events'] as List;
    List<Event> events = eventList.map((i) => Event.fromJson(i)).toList();

    return EventResponseClass(
      success: json['success'],
      events: events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
