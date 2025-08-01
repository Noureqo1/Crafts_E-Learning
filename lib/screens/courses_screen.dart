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
      builder: (context) => AlertDialog(
        title: const Text('Select Your Role'),
        content: const Text('Choose your role to continue:'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _userRole = 'student');
              Navigator.pop(context);
            },
            child: const Text('Student'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _userRole = 'teacher');
              Navigator.pop(context);
            },
            child: const Text('Teacher'),
          ),
        ],
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
