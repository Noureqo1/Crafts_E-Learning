class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final String? imageUrl;
  final String? videoUrl;
  final String? pdfUrl;
  final String category;
  final double rating;
  final int studentCount;
  final DateTime createdAt;
  final bool isPublished;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    this.pdfUrl,
    this.rating = 0.0,
    this.studentCount = 0,
    DateTime? createdAt,
    this.isPublished = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'category': category,
      'rating': rating,
      'studentCount': studentCount,
      'createdAt': createdAt.toIso8601String(),
      'isPublished': isPublished,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      instructorId: map['instructorId'],
      instructorName: map['instructorName'],
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      pdfUrl: map['pdfUrl'],
      category: map['category'],
      rating: (map['rating'] as num).toDouble(),
      studentCount: map['studentCount'],
      createdAt: DateTime.parse(map['createdAt']),
      isPublished: map['isPublished'] ?? false,
    );
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructorId,
    String? instructorName,
    String? imageUrl,
    String? videoUrl,
    String? pdfUrl,
    String? category,
    double? rating,
    int? studentCount,
    DateTime? createdAt,
    bool? isPublished,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      studentCount: studentCount ?? this.studentCount,
      createdAt: createdAt ?? this.createdAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
