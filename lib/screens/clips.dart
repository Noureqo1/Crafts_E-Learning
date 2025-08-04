import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ClipsScreen extends StatefulWidget {
  const ClipsScreen({super.key});

  @override
  _ClipsScreenState createState() => _ClipsScreenState();
}

class _ClipsScreenState extends State<ClipsScreen> {
  final List<Map<String, dynamic>> _clips = [
    {
      'title': 'Dovetail Joint Masterclass',
      'description': 'Learn how to create perfect dovetail joints with hand tools',
      'likes': 1243,
      'comments': 87,
      'shares': 45,
      'videoUrl': 'assets/videos/dovetail_joint.mp4',
      'isPlaying': false,
      'user': 'MasterCarpenter',
      'userAvatar': 'https://example.com/avatars/master_carpenter.jpg',
      'duration': '2:45',
      'views': '45.2K',
    },
    {
      'title': 'Sharpening Chisels Like a Pro',
      'description': 'Step-by-step guide to getting razor-sharp chisels',
      'likes': 987,
      'comments': 56,
      'shares': 32,
      'videoUrl': 'assets/videos/sharpening_chisels.mp4',
      'isPlaying': false,
      'user': 'WoodWorksPro',
      'userAvatar': 'https://example.com/avatars/woodworks_pro.jpg',
      'duration': '3:12',
      'views': '32.8K',
    },
    {
      'title': 'Building a Rustic Coffee Table',
      'description': 'From rough lumber to finished piece in one day',
      'likes': 2456,
      'comments': 134,
      'shares': 89,
      'videoUrl': 'assets/videos/coffee_table_build.mp4',
      'isPlaying': false,
      'user': 'RusticCrafts',
      'userAvatar': 'https://example.com/avatars/rustic_crafts.jpg',
      'duration': '4:30',
      'views': '78.5K',
    },
    {
      'title': 'Japanese Joinery Techniques',
      'description': 'Traditional Japanese woodworking joinery explained',
      'likes': 1789,
      'comments': 92,
      'shares': 67,
      'videoUrl': 'assets/videos/japanese_joinery.mp4',
      'isPlaying': false,
      'user': 'EasternWoodcraft',
      'userAvatar': 'https://example.com/avatars/eastern_woodcraft.jpg',
      'duration': '5:18',
      'views': '92.3K',
    },
  ];
  final PageController _pageController = PageController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _pageController.dispose();
    for (var clip in _clips) {
      if (clip['controller'] != null) {
        clip['controller'].dispose();
      }
      if (clip['chewieController'] != null) {
        clip['chewieController'].dispose();
      }
    }
    super.dispose();
  }

  Future<void> _uploadClip() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );

    if (pickedFile == null) return;

    // Show dialog to get title and description
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final shouldUpload = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Clip Details'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (shouldUpload != true) return;

    // In a real app, you would upload the video to a server here
    // For now, we'll just add it to our local list
    setState(() {
      _clips.insert(0, {
        'title': titleController.text,
        'description': descriptionController.text,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'videoUrl': pickedFile.path,
        'isPlaying': false,
      });
    });
  }

  Widget _buildVideoPlayer(String videoUrl) {
    return FutureBuilder<ChewieController>(
      future: _initializePlayer(File(videoUrl)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Chewie(controller: snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<ChewieController> _initializePlayer(File videoFile) async {
    final videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    
    return ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowMuting: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
      placeholder: Container(color: Colors.black),
    );
  }

  Widget _buildSideBar(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(Icons.favorite_border, '${_clips[index]['likes']}', () {
          setState(() {
            _clips[index]['likes']++;
          });
        }),
        const SizedBox(height: 20),
        _buildActionButton(Icons.comment_outlined, '${_clips[index]['comments']}', () {
          // Show comments
          _showComments(index);
        }),
        const SizedBox(height: 20),
        _buildActionButton(Icons.share, '${_clips[index]['shares']}', () {
          // Share functionality
          _shareClip(index);
        }),
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String count, VoidCallback onTap) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showComments(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 0, // Replace with actual comments count
                itemBuilder: (context, i) => const ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text('User Name'),
                  subtitle: Text('This is a sample comment'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Handle send comment
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareClip(int index) {
    // In a real app, you would implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing clip...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clips.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.video_library, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No clips yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _uploadClip,
                    child: const Text('Upload Your First Clip'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: _clips.length,
                  onPageChanged: (index) {
                    // Pause previous video
                    if (_clips.isNotEmpty) {
                      final previousIndex = index > 0 ? index - 1 : index + 1;
                      if (previousIndex >= 0 &&
                          previousIndex < _clips.length &&
                          _clips[previousIndex]['chewieController'] != null) {
                        _clips[previousIndex]['chewieController'].pause();
                      }
                    }
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Video Player
                        _buildVideoPlayer(_clips[index]['videoUrl']),
                        
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        
                        // Clip info
                        Positioned(
                          bottom: 60,
                          left: 16,
                          right: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _clips[index]['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _clips[index]['description'],
                                style: const TextStyle(color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Sidebar with actions
                        Positioned(
                          right: 16,
                          bottom: 100,
                          child: _buildSideBar(index),
                        ),
                      ],
                    );
                  },
                ),
                // Upload button
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: FloatingActionButton(
                    onPressed: _uploadClip,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
    );
  }
}
