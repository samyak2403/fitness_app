import 'package:fitness_app/pages/GeneratedWorkOuts/pages/AiGeneratedworkout.dart';
import 'package:fitness_app/pages/HealthCalculators/pages/HealthCalculators.dart';
import 'package:fitness_app/pages/NutritionPlans/pages/PersonelDietPlans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  final String email;

  const SearchScreen({super.key, required this.email});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'Generate Workouts',
    'Calculator',
    'Nutrition',
  ];
  List<String> _filteredCategories = []; // Start with an empty list

  @override
  void initState() {
    super.initState();
    _filteredCategories = []; // Initialize with an empty list
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = []; // Clear suggestions if the input is empty
      } else {
        // Filter categories based on user input
        _filteredCategories = _categories
            .where((category) =>
                category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Method to navigate to the appropriate page
  void _navigateToPage(String category) {
    switch (category) {
      case 'Generate Workouts':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenerateWorkoutPlanScreen()),
        );
        break;
      case 'Calculator':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HealthCalculatorsScreen(
                    userEmail: widget.email,
                  )),
        );
        break;
      case 'Nutrition':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenerateDietPlanScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
      child: Column(
        children: [
          Container(
            height: 35.h,
            width: 350.w,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF08EBE2)),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: TextField(
              cursorColor: Color(0xFF08EBE2),
              controller: _searchController,
              onChanged: _filterCategories,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(
                    color: Color(0xFF08EBE2)), // Hint text color
                prefixIcon: const Icon(
                  Icons.search_outlined,
                  color: Color(0xFF08EBE2),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            SizedBox(
              height: 50.h,
              child: _filteredCategories.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () =>
                              _navigateToPage(_filteredCategories[index]),
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: ListTile(
                              leading: _filteredCategories[index] ==
                                      "Generate Workouts"
                                  ? Image.asset(
                                      'assets/icons/dumbbell.png',
                                      scale: 20.w,
                                    )
                                  : _filteredCategories[index] == "Calculator"
                                      ? Image.asset(
                                          'assets/icons/calculator.png',
                                          scale: 20.w,
                                        )
                                      : Image.asset(
                                          'assets/icons/plan.png',
                                          scale: 20.w,
                                        ),
                              title: Text(
                                _filteredCategories[index],
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      'No results found',
                      style: GoogleFonts.ubuntu(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    )),
            ),
          ],
        ],
      ),
    );
  }
}
