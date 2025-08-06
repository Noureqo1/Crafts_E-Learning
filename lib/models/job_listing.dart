import 'package:flutter/foundation.dart';

enum JobType {
  fullTime,
  partTime,
  freelance,
  contract,
}

class JobListing {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final JobType type;
  final double? salary;
  final String description;
  final List<String> requirements;
  final String postedBy;
  final DateTime postedDate;
  final bool isFeatured;
  final String? companyLogo;
  final List<String>? skills;
  final String? experienceLevel;
  final bool isRemote;

  const JobListing({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.type,
    this.salary,
    required this.description,
    required this.requirements,
    required this.postedBy,
    required this.postedDate,
    this.isFeatured = false,
    this.companyLogo,
    this.skills,
    this.experienceLevel,
    this.isRemote = false,
  });

  String get typeString {
    switch (type) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.freelance:
        return 'Freelance';
      case JobType.contract:
        return 'Contract';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(postedDate);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'location': location,
      'type': type.index,
      'salary': salary,
      'description': description,
      'requirements': requirements,
      'postedBy': postedBy,
      'postedDate': postedDate.toIso8601String(),
      'isFeatured': isFeatured,
      'companyLogo': companyLogo,
      'skills': skills,
      'experienceLevel': experienceLevel,
      'isRemote': isRemote,
    };
  }

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      id: json['id'],
      title: json['title'],
      companyName: json['companyName'],
      location: json['location'],
      type: JobType.values[json['type'] as int],
      salary: json['salary']?.toDouble(),
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      postedBy: json['postedBy'],
      postedDate: DateTime.parse(json['postedDate']),
      isFeatured: json['isFeatured'] ?? false,
      companyLogo: json['companyLogo'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      experienceLevel: json['experienceLevel'],
      isRemote: json['isRemote'] ?? false,
    );
  }
}
