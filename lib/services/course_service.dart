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
          title: 'Introduction to Flutter',
          description: 'Learn the basics of Flutter development',
          instructorId: 'instructor1',
          instructorName: 'Jane Smith',
          category: 'Mobile Development',
          rating: 4.5,
          studentCount: 1245,
          isPublished: true,
        ),
        Course(
          id: '2',
          title: 'Advanced Flutter Patterns',
          description: 'Master state management and architecture in Flutter',
          instructorId: 'instructor2',
          instructorName: 'John Doe',
          category: 'Mobile Development',
          rating: 4.8,
          studentCount: 876,
          isPublished: true,
        ),
        // Add more mock courses as needed
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
