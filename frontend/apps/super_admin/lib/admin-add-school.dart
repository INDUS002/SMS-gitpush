import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management',
      home: const AddSchoolScreen(),
    ),
  );
}

class AddSchoolScreen extends StatefulWidget {
  const AddSchoolScreen({super.key});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  // --- 1. State & Controllers ---
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Text Controllers (Matching all HTML inputs)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();

  // Dropdown Value
  String? _selectedSchoolType;

  // --- Design Colors (Exact matches from CSS) ---
  final Color _gradStart = const Color(0xFF667eea);
  final Color _gradMid = const Color(0xFF764ba2);
  final Color _gradEnd = const Color(0xFFf093fb);
  final Color _bgColor = const Color(0xFFf8f9fa);
  final Color _inputBorder = const Color(0xFFe9ecef);

  // --- 2. Logic (API Call) ---
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 1. Prepare Data (Matching JS structure)
    final Map<String, dynamic> schoolData = {
      'name': _nameController.text,
      'type': _selectedSchoolType,
      'address': _addressController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipCode': _zipController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'principal': _principalController.text,
      'capacity': int.tryParse(_capacityController.text) ?? 0,
      'description': _descController.text,
      'facilities': _facilitiesController.text,
    };

    // 2. API Configuration
    const String apiUrl =
        'https://your-backend-domain.com/api/admin/schools'; // Update this

    // Mock Token retrieval (In real app, use SharedPreferences)
    const String token = "YOUR_STORED_TOKEN";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(schoolData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          _showSnackBar('School added successfully!', isError: false);
          _clearForm();
          // Navigation removed: no automatic redirect after submit
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add school');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          e.toString().replaceAll("Exception: ", ""),
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _addressController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();
    _phoneController.clear();
    _emailController.clear();
    _principalController.clear();
    _capacityController.clear();
    _descController.clear();
    _facilitiesController.clear();
    setState(() => _selectedSchoolType = null);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: isError
            ? const Color(0xFFff6b6b)
            : const Color(0xFF51cf66), // CSS Colors
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _principalController.dispose();
    _capacityController.dispose();
    _descController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

  // --- 3. UI Construction ---
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 768; // Media query breakpoint

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        // Gradient Header
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradStart, _gradMid, _gradEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          '🏫 School Management System',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Navigate back to dashboard
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to Dashboard')),
                );
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            label: const Text(
              "Back to Dashboard",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ), // .container max-width
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title with Gradient Text
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [_gradStart, _gradMid],
                  ).createShader(bounds),
                  child: const Text(
                    'Add New School',
                    style: TextStyle(
                      fontSize: 32, // 2.5rem approx
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter school information to add to the system',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 16),
                ),
                const SizedBox(height: 30),

                // Form Container Card
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Row 1
                        _buildResponsiveRow(isDesktop, [
                          _buildInput(
                            label: 'School Name *',
                            controller: _nameController,
                            hint: 'Enter school name',
                          ),
                          _buildDropdown(isDesktop),
                        ]),

                        // Row 2
                        _buildResponsiveRow(isDesktop, [
                          _buildInput(
                            label: 'Address *',
                            controller: _addressController,
                            hint: 'Enter school address',
                          ),
                          _buildInput(
                            label: 'City *',
                            controller: _cityController,
                            hint: 'Enter city',
                          ),
                        ]),

                        // Row 3
                        _buildResponsiveRow(isDesktop, [
                          _buildInput(
                            label: 'State *',
                            controller: _stateController,
                            hint: 'Enter state',
                          ),
                          _buildInput(
                            label: 'ZIP Code *',
                            controller: _zipController,
                            hint: 'Enter ZIP code',
                          ),
                        ]),

                        // Row 4
                        _buildResponsiveRow(isDesktop, [
                          _buildInput(
                            label: 'Phone Number *',
                            controller: _phoneController,
                            hint: 'Enter phone number',
                            type: TextInputType.phone,
                          ),
                          _buildInput(
                            label: 'Email *',
                            controller: _emailController,
                            hint: 'Enter email address',
                            type: TextInputType.emailAddress,
                          ),
                        ]),

                        // Row 5
                        _buildResponsiveRow(isDesktop, [
                          _buildInput(
                            label: 'Principal Name *',
                            controller: _principalController,
                            hint: 'Enter principal name',
                          ),
                          _buildInput(
                            label: 'Student Capacity *',
                            controller: _capacityController,
                            hint: 'Enter student capacity',
                            type: TextInputType.number,
                          ),
                        ]),

                        const SizedBox(height: 25),

                        // Description (Full width)
                        _buildInput(
                          label: 'School Description',
                          controller: _descController,
                          hint: 'Enter school description',
                          maxLines: 4,
                          isRequired: false,
                        ),

                        const SizedBox(height: 25),

                        // Facilities (Full width)
                        _buildInput(
                          label: 'Facilities',
                          controller: _facilitiesController,
                          hint: 'Enter available facilities',
                          maxLines: 3,
                          isRequired: false,
                        ),

                        const SizedBox(height: 40),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [_gradStart, _gradMid],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _gradStart.withValues(alpha: 0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        "Processing...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Add School",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 4. Helper Widgets (DRY Principles) ---

  // Handles the Grid behavior (Row on Desktop, Column on Mobile)
  Widget _buildResponsiveRow(bool isDesktop, List<Widget> children) {
    if (isDesktop) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 20), // Gap
            Expanded(child: children[1]),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: children[0],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: children[1],
          ),
        ],
      );
    }
  }

  // Standard Input Field
  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          validator: isRequired
              ? (value) => (value == null || value.isEmpty) ? 'Required' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _inputBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _gradStart,
                width: 2,
              ), // Focus color
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFff6b6b), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFff6b6b), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // Dropdown Field
  Widget _buildDropdown(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "School Type *",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedSchoolType,
          items: const [
            DropdownMenuItem(value: 'primary', child: Text('Primary School')),
            DropdownMenuItem(value: 'middle', child: Text('Middle School')),
            DropdownMenuItem(value: 'high', child: Text('High School')),
            DropdownMenuItem(
              value: 'comprehensive',
              child: Text('Comprehensive School'),
            ),
          ],
          onChanged: (val) => setState(() => _selectedSchoolType = val),
          validator: (val) => val == null ? 'Select school type' : null,
          decoration: InputDecoration(
            hintText: "Select school type",
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _inputBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _gradStart, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFff6b6b), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
