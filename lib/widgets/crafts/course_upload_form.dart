import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../services/course_service.dart';
import '../../../models/course.dart';

class CourseUploadForm extends StatefulWidget {
  const CourseUploadForm({super.key});

  @override
  _CourseUploadFormState createState() => _CourseUploadFormState();
}

class _CourseUploadFormState extends State<CourseUploadForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _instructorNameController = TextEditingController();
  
  String? _imagePath;
  String? _videoPath;
  String? _pdfPath;
  
  bool _isLoading = false;
  final List<String> _categories = [
    'Mobile Development',
    'Web Development',
    'Design',
    'Business',
    'Marketing',
    'Photography',
    'Music',
    'Lifestyle',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _instructorNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoPath = pickedFile.path;
      });
    }
  }

  Future<void> _pickPdf() async {
    // In a real app, you would use file_picker for PDFs
    // This is a simplified version
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );
    // if (result != null) {
    //   setState(() {
    //     _pdfPath = result.files.single.path;
    //   });
    // }
    
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF upload functionality would be implemented here')),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final course = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        instructorId: 'current_user_id', // In a real app, get from auth
        instructorName: _instructorNameController.text,
        rating: 0.0,
        studentCount: 0,
        isPublished: false,
        // In a real app, you would upload the files to storage and get the URLs
        imageUrl: _imagePath,
        videoUrl: _videoPath,
        pdfUrl: _pdfPath,
      );

      await context.read<CourseService>().addCourse(course);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating course: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create New Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Course Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Course Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            
            // Course Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            
            // Instructor Name
            TextFormField(
              controller: _instructorNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _categoryController.text.isEmpty ? null : _categoryController.text,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _categoryController.text = value;
                }
              },
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please select a category' : null,
            ),
            const SizedBox(height: 20),
            
            // Course Image
            const Text('Course Image:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40),
                          Text('Add Course Image'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Video Upload
            const Text('Course Video (Optional):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: Text(_videoPath != null ? 'Change Video' : 'Add Video'),
            ),
            if (_videoPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Video selected: ${_videoPath!.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            
            // PDF Upload
            const Text('Course Materials (PDF, Optional):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(_pdfPath != null ? 'Change PDF' : 'Add PDF'),
            ),
            if (_pdfPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'PDF selected: ${_pdfPath!.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 24),
            
            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Course', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
