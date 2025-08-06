import 'package:flutter/material.dart';
import 'package:flutter_ai_chatbot/models/job_listing.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  JobType? _selectedJobType;
  bool _showFilters = false;

  final List<JobListing> _jobListings = [
    // Carpenter Jobs
    JobListing(
      id: '1',
      title: 'Master Carpenter',
      companyName: 'Fine Woodworks Ltd',
      location: 'Riyadh, Saudi Arabia',
      type: JobType.fullTime,
      salary: 180000,
      description: 'We are seeking an experienced Master Carpenter to lead our custom furniture and cabinetry team. You will be responsible for creating high-quality custom woodwork, mentoring junior carpenters, and ensuring all projects meet our quality standards.',
      requirements: [
        '10+ years of professional carpentry experience',
        'Expertise in custom furniture and cabinetry',
        'Strong knowledge of woodworking tools and techniques',
        'Ability to read and interpret blueprints',
        'Experience with both traditional and modern woodworking methods'
      ],
      postedBy: 'hr@finewoodworks.com',
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
      isFeatured: true,
      isRemote: false,
      skills: ['Woodworking', 'Cabinetry', 'Furniture Making', 'Blueprint Reading', 'Team Leadership'],
      experienceLevel: 'Expert',
      companyLogo: 'https://example.com/woodworks-logo.jpg',
    ),
    
    JobListing(
      id: '2',
      title: 'Furniture Maker (Freelance)',
      companyName: 'Heritage Interiors',
      location: 'Jeddah, Saudi Arabia',
      type: JobType.freelance,
      salary: 80000,
      description: 'Looking for a skilled furniture maker to create custom pieces for high-end residential projects. This is a freelance position with flexible hours and the opportunity for ongoing work.',
      requirements: [
        '5+ years of furniture making experience',
        'Portfolio of previous work',
        'Own workshop and tools',
        'Ability to work with various wood types',
        'Attention to detail'
      ],
      postedBy: 'careers@heritage-interiors.com',
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
      isFeatured: false,
      isRemote: true,
      skills: ['Furniture Making', 'Wood Finishing', 'Design Interpretation', 'Custom Woodworking'],
      experienceLevel: 'Mid-Level',
    ),
    
    JobListing(
      id: '3',
      title: 'Carpentry Instructor',
      companyName: 'Saudi Vocational Training Institute',
      location: 'Dammam, Saudi Arabia',
      type: JobType.partTime,
      salary: 120000,
      description: 'Part-time position for an experienced carpenter to teach evening classes in our vocational training program. Share your expertise with the next generation of craftsmen.',
      requirements: [
        '7+ years of professional carpentry experience',
        'Teaching or mentoring experience preferred',
        'Excellent communication skills',
        'Patience and passion for teaching',
        'Certification in carpentry (preferred)'
      ],
      postedBy: 'hr@svti.edu.sa',
      postedDate: DateTime.now().subtract(const Duration(days: 7)),
      isFeatured: true,
      isRemote: false,
      skills: ['Teaching', 'Carpentry', 'Mentoring', 'Workshop Safety', 'Curriculum Development'],
      experienceLevel: 'Senior',
    ),
    
    JobListing(
      id: '4',
      title: 'Site Carpenter',
      companyName: 'Al-Bawani Construction',
      location: 'Neom, Saudi Arabia',
      type: JobType.contract,
      salary: 150000,
      description: 'Immediate opening for experienced site carpenters for a large-scale construction project in NEOM. Contract position with potential for extension.',
      requirements: [
        '5+ years of site carpentry experience',
        'Experience with formwork and concrete',
        'Ability to work in a team environment',
        'Valid driver\'s license',
        'Willingness to work in remote locations'
      ],
      postedBy: 'careers@albawani.com',
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
      isFeatured: true,
      isRemote: false,
      skills: ['Formwork', 'Concrete', 'Construction Carpentry', 'Blueprint Reading', 'Power Tools'],
      experienceLevel: 'Mid-Level to Senior',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<JobListing> get _filteredJobs {
    return _jobListings.where((job) {
      final matchesSearch = job.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedJobType == null || job.type == _selectedJobType;
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Hub'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Jobs'),
            Tab(text: 'Training'),
            Tab(text: 'My Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Jobs Tab
          _buildJobsTab(),
          // Training Tab
          _buildTrainingTab(),
          // Profile Tab
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement job posting
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildJobsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        if (_showFilters) _buildFilters(),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredJobs.length,
            itemBuilder: (context, index) {
              final job = _filteredJobs[index];
              return _buildJobCard(job);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by job type:', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: JobType.values.map((type) {
              final isSelected = _selectedJobType == type;
              return FilterChip(
                label: Text(type.toString().split('.').last),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedJobType = selected ? type : null;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobListing job) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: job.companyLogo != null
            ? CircleAvatar(backgroundImage: NetworkImage(job.companyLogo!))
            : const CircleAvatar(child: Icon(Icons.business)),
        title: Text(
          job.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.companyName),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(job.typeString),
                const SizedBox(width: 8),
                if (job.isRemote) const Text('🌍 Remote')
              ],
            ),
            if (job.salary != null) Text('\$${job.salary!.toStringAsFixed(0)}/year'),
            Text(job.timeAgo, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          // TODO: Navigate to job details
        },
      ),
    );
  }

  Widget _buildTrainingTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.school, size: 40),
            title: Text('Company Training Programs'),
            subtitle: Text('Access training programs provided by top companies'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.workspace_premium, size: 40),
            title: Text('Certification Courses'),
            subtitle: Text('Get certified in high-demand skills'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text('Profile and application status will be shown here'),
    );
  }
}