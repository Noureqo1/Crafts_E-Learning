import 'package:flutter/foundation.dart';
import '../models/course.dart';

class CourseService extends ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Course> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load courses from Firestore (mock implementation for now)
  Future<void> loadCourses({String? category}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would be a Firestore query
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Mock data
      _courses = [
        Course(
          id: '1',
          title: 'Woodworking Fundamentals',
          description: 'Master essential woodworking techniques, from measuring and cutting to joinery and finishing.',
          instructorId: 'instructor1',
          instructorName: 'James Woodcraft',
          category: 'Carpentry',
          rating: 4.7,
          studentCount: 2456,
          isPublished: true,
          imageUrl: 'https://example.com/courses/woodworking-fundamentals.jpg',
        ),
        Course(
          id: '2',
          title: 'Fine Furniture Making',
          description: 'Learn to design and build heirloom-quality furniture using traditional joinery techniques.',
          instructorId: 'instructor2',
          instructorName: 'Sarah Carpenter',
          category: 'Furniture Making',
          rating: 4.9,
          studentCount: 1892,
          isPublished: true,
          imageUrl: 'https://example.com/courses/fine-furniture.jpg',
        ),
        Course(
          id: '3',
          title: 'Japanese Joinery Masterclass',
          description: 'Explore traditional Japanese woodworking techniques and create stunning joinery without nails or screws.',
          instructorId: 'instructor3',
          instructorName: 'Hiroshi Tanaka',
          category: 'Woodworking',
          rating: 4.8,
          studentCount: 1543,
          isPublished: true,
          imageUrl: 'https://example.com/courses/japanese-joinery.jpg',
        ),
        Course(
          id: '4',
          title: 'Woodturning for Beginners',
          description: 'Get started with woodturning and learn to create beautiful bowls, pens, and other turned objects.',
          instructorId: 'instructor4',
          instructorName: 'Mike Turner',
          category: 'Woodturning',
          rating: 4.6,
          studentCount: 2105,
          isPublished: true,
          imageUrl: 'https://example.com/courses/woodturning.jpg',
        ),
        Course(
          id: '5',
          title: 'Cabinet Making Techniques',
          description: 'Learn professional cabinet making skills, from design to installation.',
          instructorId: 'instructor5',
          instructorName: 'Robert Johnson',
          category: 'Cabinetry',
          rating: 4.7,
          studentCount: 1789,
          isPublished: true,
          imageUrl: 'https://example.com/courses/cabinet-making.jpg',
        ),
        Course(
          id: '6',
          title: 'Hand Tool Workshop',
          description: 'Master the use of hand tools for precise and satisfying woodworking.',
          instructorId: 'instructor6',
          instructorName: 'Thomas Handley',
          category: 'Woodworking',
          rating: 4.8,
          studentCount: 1654,
          isPublished: true,
          imageUrl: 'https://example.com/courses/hand-tools.jpg',
        ),
        Course(
          id: '7',
          title: 'Outdoor Furniture Building',
          description: 'Create beautiful and durable outdoor furniture that will last for years.',
          instructorId: 'instructor7',
          instructorName: 'Emily Woodson',
          category: 'Outdoor Furniture',
          rating: 4.9,
          studentCount: 1987,
          isPublished: true,
          imageUrl: 'https://example.com/courses/outdoor-furniture.jpg',
        ),
      ];

      // Filter by category if provided
      if (category != null) {
        _courses = _courses.where((course) => course.category == category).toList();
      }
    } catch (e) {
      _error = 'Failed to load courses: $e';
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new course
  Future<void> addCourse(Course course) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would save to Firestore
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      _courses = [course, ..._courses];
    } catch (e) {
      _error = 'Failed to add course: $e';
      debugPrint('Error adding course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing course
  Future<void> updateCourse(Course updatedCourse) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would update in Firestore
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _courses.indexWhere((c) => c.id == updatedCourse.id);
      if (index != -1) {
        _courses[index] = updatedCourse;
      }
    } catch (e) {
      _error = 'Failed to update course: $e';
      debugPrint('Error updating course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would delete from Firestore
      await Future.delayed(const Duration(milliseconds: 500));
      
      _courses.removeWhere((course) => course.id == courseId);
    } catch (e) {
      _error = 'Failed to delete course: $e';
      debugPrint('Error deleting course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get courses by instructor
  List<Course> getCoursesByInstructor(String instructorId) {
    return _courses.where((course) => course.instructorId == instructorId).toList();
  }

  // Get courses by category
  List<Course> getCoursesByCategory(String category) {
    return _courses.where((course) => course.category == category).toList();
  }

  // Search courses
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return [];
    final lowercaseQuery = query.toLowerCase();
    return _courses.where((course) {
      return course.title.toLowerCase().contains(lowercaseQuery) ||
          course.description.toLowerCase().contains(lowercaseQuery) ||
          course.instructorName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
