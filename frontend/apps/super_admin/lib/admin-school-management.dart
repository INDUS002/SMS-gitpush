import 'package:flutter/material.dart';

void main() {
  runApp(const SchoolApp());
}

// --- APP SETUP ---
class SchoolApp extends StatelessWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff007bff),
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff007bff)),
        useMaterial3: true,
      ),
      home: const SchoolDashboard(),
    );
  }
}

// --- DATA MODELS ---
class School {
  final int id;
  final String name;
  final String location;
  final String type;
  final String status;
  final int students;
  final int teachers;
  final int buses;
  final double attendance;
  final String principal;
  final String established;
  final String licenseStatus;
  final String licenseExpiry;
  final String annualRevenue;

  School({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.status,
    required this.students,
    required this.teachers,
    required this.buses,
    required this.attendance,
    required this.principal,
    required this.established,
    required this.licenseStatus,
    required this.licenseExpiry,
    required this.annualRevenue,
  });

  String get avatarLetter =>
      name.split(' ').map((n) => n[0]).take(2).join().toUpperCase();
}

class Student {
  final int id;
  final String name;
  final String grade;
  final String section;
  final String photo;

  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.photo,
  });
}

class Teacher {
  final int id;
  final String name;
  final String subject;
  final String photo;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.photo,
  });
}

class Bus {
  final int id;
  final String number;
  final String driver;
  final String route;
  final String photo;

  Bus({
    required this.id,
    required this.number,
    required this.driver,
    required this.route,
    required this.photo,
  });
}

class Report {
  final int id;
  final String title;
  final String type;
  final String date;
  final String photo;

  Report({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.photo,
  });
}

// --- MOCK DATA ---
final List<School> mockSchools = [
  School(
    id: 1,
    name: "St. Mary's High School",
    location: "New York, NY",
    type: "Private School • K-12",
    status: "active",
    students: 1250,
    teachers: 85,
    buses: 12,
    attendance: 94.5,
    principal: "Dr. Sarah Johnson",
    established: "1995",
    licenseStatus: "Active",
    licenseExpiry: "December 31, 2024",
    annualRevenue: "\$125,000",
  ),
  School(
    id: 2,
    name: "North Elementary",
    location: "Chicago, IL",
    type: "Public School • Elementary",
    status: "active",
    students: 800,
    teachers: 45,
    buses: 8,
    attendance: 92.3,
    principal: "Mr. Michael Chen",
    established: "2000",
    licenseStatus: "Active",
    licenseExpiry: "March 15, 2025",
    annualRevenue: "\$80,000",
  ),
  School(
    id: 3,
    name: "South Middle School",
    location: "Los Angeles, CA",
    type: "Public School • Middle",
    status: "pending",
    students: 950,
    teachers: 60,
    buses: 10,
    attendance: 91.8,
    principal: "Ms. Emily White",
    established: "1998",
    licenseStatus: "Pending",
    licenseExpiry: "June 30, 2024",
    annualRevenue: "\$95,000",
  ),
  School(
    id: 4,
    name: "East Academy",
    location: "Miami, FL",
    type: "Private School • K-12",
    status: "active",
    students: 600,
    teachers: 40,
    buses: 6,
    attendance: 96.2,
    principal: "Dr. Robert Brown",
    established: "2010",
    licenseStatus: "Active",
    licenseExpiry: "September 20, 2025",
    annualRevenue: "\$60,000",
  ),
  School(
    id: 5,
    name: "West Institute",
    location: "Seattle, WA",
    type: "Private School • High",
    status: "expired",
    students: 700,
    teachers: 50,
    buses: 7,
    attendance: 93.7,
    principal: "Prof. Lisa Wilson",
    established: "2005",
    licenseStatus: "Expired",
    licenseExpiry: "January 15, 2024",
    annualRevenue: "\$70,000",
  ),
  School(
    id: 6,
    name: "Riverside High",
    location: "Austin, TX",
    type: "Public School • High",
    status: "active",
    students: 1100,
    teachers: 75,
    buses: 9,
    attendance: 95.1,
    principal: "Mr. David Davis",
    established: "1992",
    licenseStatus: "Active",
    licenseExpiry: "November 10, 2024",
    annualRevenue: "\$110,000",
  ),
];

final List<Student> mockStudents = [
  Student(
    id: 1,
    name: "Alice Johnson",
    grade: "10th",
    section: "A",
    photo: "AJ",
  ),
  Student(id: 2, name: "Bob Smith", grade: "11th", section: "B", photo: "BS"),
  Student(id: 3, name: "Carol Davis", grade: "12th", section: "C", photo: "CD"),
  Student(id: 4, name: "David Wilson", grade: "9th", section: "A", photo: "DW"),
  Student(id: 5, name: "Eva Brown", grade: "10th", section: "B", photo: "EB"),
  Student(id: 6, name: "Frank Green", grade: "9th", section: "B", photo: "FG"),
  Student(id: 7, name: "Grace Hall", grade: "11th", section: "A", photo: "GH"),
];

final List<Teacher> mockTeachers = [
  Teacher(id: 1, name: "Dr. Sarah Miller", subject: "Mathematics", photo: "SM"),
  Teacher(id: 2, name: "Mr. John Davis", subject: "Physics", photo: "JD"),
  Teacher(id: 3, name: "Ms. Lisa Garcia", subject: "English", photo: "LG"),
  Teacher(id: 4, name: "Prof. Mike Chen", subject: "Chemistry", photo: "MC"),
  Teacher(id: 5, name: "Mrs. Anna White", subject: "History", photo: "AW"),
  Teacher(id: 6, name: "Dr. Ben King", subject: "Biology", photo: "BK"),
];

final List<Bus> mockBuses = [
  Bus(
    id: 1,
    number: "BUS-001",
    driver: "Mr. Tom Wilson",
    route: "Downtown Route",
    photo: "TW",
  ),
  Bus(
    id: 2,
    number: "BUS-002",
    driver: "Ms. Sarah Brown",
    route: "North Route",
    photo: "SB",
  ),
  Bus(
    id: 3,
    number: "BUS-003",
    driver: "Mr. James Lee",
    route: "East Route",
    photo: "JL",
  ),
  Bus(
    id: 4,
    number: "BUS-004",
    driver: "Mrs. Mary Johnson",
    route: "West Route",
    photo: "MJ",
  ),
  Bus(
    id: 5,
    number: "BUS-005",
    driver: "Mr. Sam Allen",
    route: "South Route",
    photo: "SA",
  ),
];

final List<Report> mockReports = [
  Report(
    id: 1,
    title: "Monthly Attendance Report",
    type: "Attendance",
    date: "Jan 2024",
    photo: "AR",
  ),
  Report(
    id: 2,
    title: "Academic Performance Report",
    type: "Academic",
    date: "Dec 2023",
    photo: "AP",
  ),
  Report(
    id: 3,
    title: "Transportation Report",
    type: "Transport",
    date: "Jan 2024",
    photo: "TR",
  ),
  Report(
    id: 4,
    title: "Financial Report",
    type: "Financial",
    date: "Dec 2023",
    photo: "FR",
  ),
  Report(
    id: 5,
    title: "Staffing Report",
    type: "HR",
    date: "Nov 2023",
    photo: "SR",
  ),
];

// --- MAIN DASHBOARD ---

enum ContentView {
  overview,
  detailStudents,
  detailTeachers,
  detailBuses,
  detailReports,
}

class SchoolDashboard extends StatefulWidget {
  const SchoolDashboard({super.key});

  @override
  State<SchoolDashboard> createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  int _currentSidebarIndex = 1; // School Overview is active
  int? _hoveredSidebarIndex;
  School? _selectedSchool;
  ContentView _currentView = ContentView.overview;

  @override
  void initState() {
    super.initState();
    _selectedSchool = mockSchools[0]; // Default to first school
  }

  // Helper functions for status colors
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xff28a745);
      case 'pending':
        return const Color(0xffffc107);
      case 'expired':
        return const Color(0xffdc3545);
      default:
        return const Color(0xff6c757d);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xff28a745).withValues(alpha: 0.1);
      case 'pending':
        return const Color(0xffffc107).withValues(alpha: 0.1);
      case 'expired':
        return const Color(0xffdc3545).withValues(alpha: 0.1);
      default:
        return const Color(0xff6c757d).withValues(alpha: 0.1);
    }
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xffe9ecef), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff007bff), Color(0xff0056b3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    '🏫 SMS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'School Management System',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            _buildNavItem('📊', 'Dashboard', 0),
            _buildNavItem('🏫', 'School Overview', 1),
            _buildNavItem('👥', 'Students', 2),
            _buildNavItem('👨‍🏫', 'Teachers', 3),
            _buildNavItem('🚌', 'Buses', 4),
            _buildNavItem('📊', 'Attendance', 5),
            _buildNavItem('📈', 'Reports', 6),
            _buildNavItem('⚙️', 'Settings', 7),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String title, int index) {
    final bool isActive = _currentSidebarIndex == index;
    final bool isHovered = _hoveredSidebarIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hoveredSidebarIndex = index),
        onExit: (_) => setState(() => _hoveredSidebarIndex = null),
        child: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _currentSidebarIndex = index;
              _currentView = ContentView.overview; // Reset view on nav change
            });
            // Close drawer on mobile
            if (Scaffold.of(context).hasDrawer) {
              Navigator.of(context).pop();
            }
            // Show navigation feedback
            final titles = ['Dashboard', 'School Overview', 'Students', 'Teachers', 'Buses', 'Attendance', 'Reports', 'Settings'];
            if (index < titles.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Navigated to ${titles[index]}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(isHovered ? 5.0 : 0.0, 0.0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: isActive ? null : const Color(0xfff8f9fa),
              gradient: isActive || isHovered
                  ? const LinearGradient(
                      colors: [Color(0xff007bff), Color(0xff0056b3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive || isHovered
                    ? const Color(0xff007bff)
                    : const Color(0xffe9ecef),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  icon,
                  style: TextStyle(
                    fontSize: 18,
                    color: isActive || isHovered
                        ? Colors.white
                        : const Color(0xff333333),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive || isHovered
                        ? Colors.white
                        : const Color(0xff333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xffe9ecef), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedSchool?.name ?? 'School Management',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333),
            ),
          ),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.5),
                  gradient: const LinearGradient(
                    colors: [Color(0xff007bff), Color(0xff0056b3)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin User',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'System Administrator',
                    style: TextStyle(fontSize: 12, color: Color(0xff666666)),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              // Conditional display for detail views
              if (_currentView != ContentView.overview)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentView = ContentView.overview;
                    });
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back to Overview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6c757d),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              if (_currentView != ContentView.overview)
                const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to schools list
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigating to Schools List')),
                    );
                  }
                },
                icon: const Icon(Icons.school, size: 16),
                label: const Text('Back to Schools'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff007bff),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolInfo() {
    if (_selectedSchool == null) return const SizedBox();

    final school = _selectedSchool!;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xffe9ecef), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    colors: [Color(0xff007bff), Color(0xff0056b3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    school.avatarLetter,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      school.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                    Text(
                      school.type,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(school.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  school.licenseStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(school.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2,
            children: [
              _buildStatItem(school.students.toString(), 'Students'),
              _buildStatItem(school.teachers.toString(), 'Teachers'),
              _buildStatItem(school.buses.toString(), 'Buses'),
              _buildStatItem(
                '${school.attendance.toStringAsFixed(1)}%',
                'Attendance',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xfff8f9fa),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffe9ecef), width: 1),
            ),
            child: Column(
              children: [
                _buildLicenseRow('License Status:', school.licenseStatus),
                _buildLicenseRow('Expiry Date:', school.licenseExpiry),
                _buildLicenseRow('Annual Revenue:', school.annualRevenue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffe9ecef), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff007bff),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff333333),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff007bff),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Modified _buildSection to handle 'View All' clicks
  Widget _buildSection<T>(
    String icon,
    String title,
    List<T> items,
    String Function(T) getSubtitle,
    ContentView detailView,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xffe9ecef), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentView =
                        detailView; // Set state to the specific detail view
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff007bff),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View All'),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: items.length < 5
                  ? items.length
                  : 5, // Show max 5 on overview
              itemBuilder: (context, index) {
                final item = items[index];
                String name;
                String avatar;
                if (item is Student) {
                  name = item.name;
                  avatar = item.photo;
                } else if (item is Teacher) {
                  name = item.name;
                  avatar = item.photo;
                } else if (item is Bus) {
                  name = item.number;
                  avatar = item.photo;
                } else if (item is Report) {
                  name = item.title;
                  avatar = item.photo;
                } else {
                  name = '';
                  avatar = '';
                }
                return _buildListItem(
                  avatar,
                  name,
                  getSubtitle(item),
                  () {
                    // View action for overview list item
                    _showActionDialog(
                      'View ${name.split(' ').first}',
                      'Displaying the detailed information for $name. (Not fully implemented in this sample)',
                    );
                  },
                  () {
                    // Edit action for overview list item
                    _showActionDialog(
                      'Edit ${name.split(' ').first}',
                      'Opening edit form for $name. (Not fully implemented in this sample)',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    String avatar,
    String name,
    String subtitle,
    VoidCallback onView,
    VoidCallback onEdit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe9ecef), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xff007bff), Color(0xff0056b3)],
              ),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff666666),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onView, // Use callback for View
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff007bff),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('View', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onEdit, // Use callback for Edit
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffc107),
                  foregroundColor: const Color(0xff333333),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Edit', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementSections() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width >= 1200 ? 2 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: MediaQuery.of(context).size.width >= 1200 ? 1.2 : 1.5,
      children: [
        _buildSection(
          '👥',
          'Recent Students',
          mockStudents,
          (student) => '${(student).grade} • Section ${(student).section}',
          ContentView.detailStudents,
        ),
        _buildSection(
          '👨‍🏫',
          'Recent Teachers',
          mockTeachers,
          (teacher) => (teacher).subject,
          ContentView.detailTeachers,
        ),
        _buildSection(
          '🚌',
          'Bus Routes',
          mockBuses,
          (bus) => '${(bus).driver} • ${(bus).route}',
          ContentView.detailBuses,
        ),
        _buildSection(
          '📊',
          'Quick Reports',
          mockReports,
          (report) => '${(report).type} • ${(report).date}',
          ContentView.detailReports,
        ),
      ],
    );
  }

  Widget _buildSchoolOverviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildSchoolInfo(),
        const SizedBox(height: 30),
        _buildManagementSections(),
      ],
    );
  }

  // New: Generic Detail View
  Widget _buildDetailView<T>(
    String title,
    List<T> items,
    String Function(T) getSubtitle,
    String Function(T) getName,
    String Function(T) getAvatar,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Text(
          'Detailed $title List',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xff333333),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xffe9ecef), width: 1),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildListItem(
                getAvatar(item),
                getName(item),
                getSubtitle(item),
                () {
                  // View action
                  _showActionDialog(
                    'View ${getName(item).split(' ').first}',
                    'Displaying the detailed information for ${getName(item)}. (Not fully implemented in this sample)',
                  );
                },
                () {
                  // Edit action
                  _showActionDialog(
                    'Edit ${getName(item).split(' ').first}',
                    'Opening edit form for ${getName(item)}. (Not fully implemented in this sample)',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // New: Action Dialog
  void _showActionDialog(String title, String content) {
    // Dialog removed; show a SnackBar instead to avoid navigation
    ScaffoldMessenger.of(
      this.context,
    ).showSnackBar(SnackBar(content: Text('$title — $content')));
  }

  Widget _buildPlaceholderContent(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          '$title Content (Coming Soon)',
          style: const TextStyle(fontSize: 20, color: Color(0xff666666)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    Widget currentContent;

    // First check the sidebar index
    if (_currentSidebarIndex != 1) {
      switch (_currentSidebarIndex) {
        case 0:
          currentContent = _buildPlaceholderContent('Dashboard');
          break;
        case 2:
          currentContent = _buildPlaceholderContent('Students');
          break;
        case 3:
          currentContent = _buildPlaceholderContent('Teachers');
          break;
        case 4:
          currentContent = _buildPlaceholderContent('Buses');
          break;
        case 5:
          currentContent = _buildPlaceholderContent('Attendance');
          break;
        case 6:
          currentContent = _buildPlaceholderContent('Reports');
          break;
        case 7:
          currentContent = _buildPlaceholderContent('Settings');
          break;
        default:
          currentContent = _buildSchoolOverviewContent();
      }
    } else {
      // If sidebar is School Overview, check the sub-view state
      switch (_currentView) {
        case ContentView.overview:
          currentContent = _buildSchoolOverviewContent();
          break;
        case ContentView.detailStudents:
          currentContent = _buildDetailView<Student>(
            'Students',
            mockStudents,
            (s) => '${s.grade} • Section ${s.section}',
            (s) => s.name,
            (s) => s.photo,
          );
          break;
        case ContentView.detailTeachers:
          currentContent = _buildDetailView<Teacher>(
            'Teachers',
            mockTeachers,
            (t) => t.subject,
            (t) => t.name,
            (t) => t.photo,
          );
          break;
        case ContentView.detailBuses:
          currentContent = _buildDetailView<Bus>(
            'Buses',
            mockBuses,
            (b) => '${b.driver} • ${b.route}',
            (b) => b.number,
            (b) => b.photo,
          );
          break;
        case ContentView.detailReports:
          currentContent = _buildDetailView<Report>(
            'Reports',
            mockReports,
            (r) => '${r.type} • ${r.date}',
            (r) => r.title,
            (r) => r.photo,
          );
          break;
      }
    }

    Widget mainContent = Padding(
      padding: EdgeInsets.all(isDesktop ? 30 : 15),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: isDesktop ? 0 : 120),
        child: currentContent,
      ),
    );

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('School Management'),
              backgroundColor: const Color(0xff007bff),
              foregroundColor: Colors.white,
            ),
      resizeToAvoidBottomInset: false,
      body: isDesktop
          ? Row(
              children: [
                _buildSidebar(),
                Expanded(child: mainContent),
              ],
            )
          : mainContent,
      drawer: isDesktop ? null : Drawer(child: _buildSidebar()),
    );
  }
}
