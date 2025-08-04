import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/crafts/course_list.dart';
import '../widgets/crafts/course_upload_form.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String? _userRole;
  bool _isLoading = true;
  List<Course> _courses = [];

  bool _isRoleDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourses();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userRole == null && !_isRoleDialogShown) {
      _isRoleDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRoleSelectionDialog();
      });
    }
  }

  Future<void> _loadCourses() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final courseService = context.read<CourseService>();
      await courseService.loadCourses();
      
      if (mounted) {
        setState(() {
          _courses = courseService.courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load courses')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _showRoleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              const Icon(
                Icons.school_rounded,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to Courses!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Please select your role to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Student Card
              _buildRoleCard(
                context,
                title: 'I\'m a Student',
                subtitle: 'Browse and enroll in courses',
                icon: Icons.school_rounded,
                color: Colors.blue,
                onTap: () => _selectRole('student'),
              ),
              const SizedBox(height: 16),
              
              // Teacher Card
              _buildRoleCard(
                context,
                title: 'I\'m a Teacher',
                subtitle: 'Create and manage courses',
                icon: Icons.person_outline_rounded,
                color: Colors.green,
                onTap: () => _selectRole('teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectRole(String role) {
    setState(() => _userRole = role);
    Navigator.pop(context);
    // Show welcome message based on role
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          role == 'student' 
              ? 'Welcome, Student! Start exploring courses.' 
              : 'Welcome, Teacher! Ready to create amazing courses?',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: role == 'student' ? Colors.blue : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCourses,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _courses.isEmpty
                ? const Center(child: Text('No courses available'))
                : CourseList(courses: _courses),
      ),
      floatingActionButton: _userRole == 'teacher'
          ? FloatingActionButton(
              onPressed: () => _showCourseUploadForm(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showCourseUploadForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CourseUploadForm(),
    ).then((_) => _loadCourses());
  }
}
