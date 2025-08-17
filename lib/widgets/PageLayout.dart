import 'package:flutter/material.dart';

// PageLayout is a custom AppBar widget that implements PreferredSizeWidget so it's compatible with AppBar
class PageLayout extends StatelessWidget implements PreferredSizeWidget {
  final String title;        // Title text that will be displayed in the AppBar.
  final bool centerTitle;    // Whether to center the title text in the AppBar or not (default is true).
  final Widget? leading;     // Widget for the leading part of the AppBar (like a back button or menu icon).
  final bool automaticallyImplyLeading; // Whether to automatically add a leading widget (like back button) when possible.
  final bool isTitleBold;    // Determines whether the title text should be bold or not.

  // Constructor for the PageLayout with the parameters we need
  const PageLayout({
    Key? key,
    required this.title, // Title is required.
    this.centerTitle = true, // Centering the title by default.
    this.leading,  // Optionally pass a custom leading widget.
    this.automaticallyImplyLeading = false,  // Disabled so that we can manually control the leading widget
    this.isTitleBold = true, // Title boldness, default is true.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading, // Automatically add a leading widget (like back button) if true, otherwise not.
      leading: leading, // Custom widget to place at the start of the AppBar. If null and automaticallyImplyLeading is false, nothing appears.
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal, // Set the font weight dynamically based on isTitleBold
          color: const Color(0xB6FFFFFF),
        ),
      ),
      centerTitle: centerTitle,  // Centers the title horizontally if true.
      elevation: 8, // Adds a shadow under the AppBar to give a sense of depth.

      // Creates a background gradient that fills the entire AppBar area.
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade500, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      // Apply white icon theme to the leading widget and all icons in the AppBar
      iconTheme: const IconThemeData(
        color: Colors.white,  // Set all icons' color to white by default
      ),
    );
  }

  // Return the preferred size needed by AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
