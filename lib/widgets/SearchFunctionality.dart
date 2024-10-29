import 'package:fitness_app/pages/GeneratedWorkOuts/pages/AiGeneratedworkout.dart';
import 'package:fitness_app/pages/HealthCalculators/pages/HealthCalculators.dart';
import 'package:fitness_app/pages/NutritionPlans/pages/PersonelDietPlans.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

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
  List<String> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = []; // Initialize with an empty list
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = [];
      } else {
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
        changeScreen(context, GenerateWorkoutPlanScreen(),
            PageTransitionType.leftToRight, 200);
        break;
      case 'Calculator':
        changeScreen(
            context,
            HealthCalculatorsScreen(
              userEmail: widget.email,
            ),
            PageTransitionType.leftToRight,
            200);

        break;
      case 'Nutrition':
        changeScreen(context, GenerateDietPlanScreen(),
            PageTransitionType.leftToRight, 200);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 16.w,
        left: 16.w,
      ),
      child: Column(
        children: [
          Container(
            height: 40.h,
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
                hintStyle: const TextStyle(color: Color(0xFF08EBE2)),
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
          SizedBox(height: 10.h), // Add some spacing
          if (_filteredCategories.isNotEmpty) ...[
            Column(
              children: _filteredCategories.map((category) {
                return InkWell(
                  onTap: () => _navigateToPage(category),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: ListTile(
                        leading: category == "Generate Workouts"
                            ? Image.asset(
                                'assets/icons/dumbbell.png',
                                scale: 20.w,
                              )
                            : category == "Calculator"
                                ? Image.asset(
                                    'assets/icons/calculator.png',
                                    scale: 20.w,
                                  )
                                : Image.asset(
                                    'assets/icons/plan.png',
                                    scale: 20.w,
                                  ),
                        trailing: const ClipOval(
                            child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                        )),
                        title: Text(
                          category,
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else if (_searchController.text.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                'No results found',
                style: GoogleFonts.ubuntu(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
