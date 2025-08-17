import 'package:flutter/material.dart';
import '../screens/DemographicsScreen.dart';
import '../screens/AllergiesScreen.dart';
import '../screens/ImmunizationsScreen.dart';
import '../screens/MedicationScreen.dart';
import '../screens/ProblemListScreen.dart';
import '../screens/ProceduresScreen.dart';
import '../screens/PlanOfCareScreen.dart';

class ScreensMenu extends StatelessWidget {
  const ScreensMenu({super.key});

  // List of menu items, each containing an icon, title, themed color of the icon and corresponding screen.
  static final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.person, 'title': 'Demographics', 'backgroundColor': Colors.purple.shade50, 'iconColor': Colors.deepPurple.shade400, 'screen': const DemographicsScreen()},
    {'icon': Icons.coronavirus_outlined, 'title': 'Allergies', 'backgroundColor': Colors.red.shade50, 'iconColor': Colors.red, 'screen': const AllergiesScreen()},
    {'icon': Icons.vaccines, 'title': 'Immunizations', 'backgroundColor': Colors.orange.shade50, 'iconColor': Colors.orange, 'screen': const ImmunizationsScreen()},
    {'icon': Icons.medication, 'title': 'Medication', 'backgroundColor': Color(0xFFE0F7FA), 'iconColor': Color(0xFF007B8A), 'screen': const MedicationScreen()},
    {'icon': Icons.health_and_safety, 'title': 'Plan of Care', 'backgroundColor': Colors.green.shade50, 'iconColor': Colors.green, 'screen': const PlanOfCareScreen()},
    {'icon': Icons.report_problem, 'title': 'Problem List', 'backgroundColor': Color(0xFFFFF0F0), 'iconColor': Color(0xFFB84A62), 'screen': const ProblemListScreen()},
    {'icon': Icons.local_hospital, 'title': 'Procedures', 'backgroundColor': Color(0xFFEDF1F8), 'iconColor': Color(0xFF60759B), 'screen': const ProceduresScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Color(0xFFFAFCFF), // soft white
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer header section with a gradient background
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top, // Same height as appBar
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade500, Colors.purple.shade200],
                begin: Alignment.topLeft, // Gradient starts from the top-left
                end: Alignment.bottomRight, // Gradient starts from the top-left
              ),
            ),
            child: Center(  // Centers the text in the header
              child: Text( 'Menu',
                style: TextStyle( color: Color(0xB6FFFFFF), fontSize: 26, fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(offset: Offset(0.0, 2.0), blurRadius: 5.0, color: Colors.black.withOpacity(0.2),), // Shadow offset,  blur radius , color with opacity
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Adds 20 pixels of vertical space after the header
          // Generate drawer menu items dynamically
          ...menuItems.map((item) => buildDrawerItem(context, item)).toList(), //Transforms every menuItem into a ListTile widget. Converts the result from Iterable<Widget> to List<Widget>. Unpacks the list and inserts each item individually inside children: [].
        ],
      ),
    );
  }

  // Builds an individual menu item for the drawer.
  Widget buildDrawerItem(BuildContext context, Map<String, dynamic> item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),  // Adds vertical and horizontal padding to each list item
      leading: Container(
        decoration: BoxDecoration(
          color: item['backgroundColor'], // same as in buildCard
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          item['icon'],
          color: item['iconColor'],
          size: 26.0,
        ),
      ),
      title: Text(
        item['title'],  // Displays the corresponding title for each menu item
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        // Navigates to the corresponding screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen']));
      },
    );
  }



  // Builds the list-based menu for displaying screens as cards.
  // This method is static, so it can be used directly from other parts of the app.
  static Widget buildListMenu(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return buildCard(context, item);
      },
    );
  }
  // Builds an individual card item for the list menu.
  // This method is static, so it can be used directly from other parts of the app.
  static Widget buildCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 1,
      //color: Colors.white,
      color: Color(0xFFFAFCFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen']));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: item['backgroundColor'],
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(item['icon'], size: 26.0, color: item['iconColor']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildCategoryDropdown({
    required String? selectedCategory,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelText: 'Select Category',
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 3),
        ),
        filled: true,
        fillColor: const Color(0xFFD2DCFF),
      ),
      dropdownColor: Colors.blue.shade100,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      value: selectedCategory,
      isExpanded: true,
      borderRadius: BorderRadius.circular(20),
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      selectedItemBuilder: (context) {
        return menuItems.map((item) {
          return Row(
            children: [
              Icon(item['icon'], color: item['iconColor']),
              const SizedBox(width: 10),
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          );
        }).toList();
      },
      items: menuItems.map((item) {
        return DropdownMenuItem<String>(
          value: item['title'],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EFFF),
              //color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(item['icon'], color: item['iconColor']),
                const SizedBox(width: 10),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
