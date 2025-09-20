import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Data Models for Waste Classification ---

class WasteItem {
  final String name;
  final IconData icon;
  WasteItem(this.name, this.icon);
}

class WasteCategory {
  final String name;
  final IconData icon;
  final String binInfo;
  final Color color1;
  final Color color2;
  final List<WasteItem> items;

  WasteCategory({
    required this.name,
    required this.icon,
    required this.binInfo,
    required this.color1,
    required this.color2,
    required this.items,
  });
}

// --- Main Screen Widget ---

class GarbageDetailsScreen
    extends StatefulWidget {
  const GarbageDetailsScreen({super.key});

  @override
  State<GarbageDetailsScreen> createState() =>
      _GarbageDetailsScreenState();
}

class _GarbageDetailsScreenState
    extends State<GarbageDetailsScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController
  _backgroundAnimationController;
  late AnimationController _contentController;
  late Animation<Color?> _color1Animation;
  late Animation<Color?> _color2Animation;

  // State Management
  int _selectedCategoryIndex = 0;

  // --- "Database" of Waste Information ---
  final List<WasteCategory> _wasteCategories = [
    WasteCategory(
      name: 'Dry Waste',
      icon: Icons.recycling,
      binInfo: 'Blue Bin',
      color1: const Color(
        0xFF0077B6,
      ), // Ocean Blue
      color2: const Color(0xFF00B4D8), // Sky Blue
      items: [
        WasteItem(
          'Plastic Bottles',
          Icons.local_drink_outlined,
        ),
        WasteItem(
          'Paper & Cardboard',
          Icons.article_outlined,
        ),
        WasteItem(
          'Glass Jars',
          Icons.wine_bar_outlined,
        ),
        WasteItem(
          'Metal Cans',
          Icons.view_in_ar_outlined,
        ),
      ],
    ),
    WasteCategory(
      name: 'Wet Waste',
      icon: Icons.eco,
      binInfo: 'Green Bin',
      color1: const Color(
        0xFFD95500,
      ), // Earthy Orange
      color2: const Color(
        0xFFBF880B,
      ), // Muddy Yellow
      items: [
        WasteItem(
          'Food Scraps',
          Icons.restaurant_outlined,
        ),
        WasteItem(
          'Fruit & Veggie Peels',
          Icons.apple_outlined,
        ),
        WasteItem(
          'Garden Waste',
          Icons.park_outlined,
        ),
        WasteItem(
          'Tea Bags & Coffee Grounds',
          Icons.coffee_outlined,
        ),
      ],
    ),
    WasteCategory(
      name: 'Other Waste',
      icon: Icons.layers,
      binInfo: 'Black Bin',
      color1: const Color(
        0xFF495057,
      ), // Dark Grey
      color2: const Color(
        0xFF6C757D,
      ), // Medium Grey
      items: [
        WasteItem(
          'Used Masks',
          Icons.masks_outlined,
        ),
        WasteItem(
          'Sanitary Waste',
          Icons.sanitizer_outlined,
        ),
        WasteItem(
          'Electronics',
          Icons.electrical_services_outlined,
        ),
        WasteItem(
          'Ceramics',
          Icons.broken_image_outlined,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _backgroundAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1),
        );

    _updateColorAnimations(
      _wasteCategories[0],
      _wasteCategories[0],
    );
    _contentController.forward();
  }

  void _updateColorAnimations(
    WasteCategory oldCategory,
    WasteCategory newCategory,
  ) {
    _color1Animation = ColorTween(
      begin: oldCategory.color1,
      end: newCategory.color1,
    ).animate(_backgroundAnimationController);
    _color2Animation = ColorTween(
      begin: oldCategory.color2,
      end: newCategory.color2,
    ).animate(_backgroundAnimationController);
    _backgroundAnimationController.forward(
      from: 0.0,
    );
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WasteCategory selectedCategory =
        _wasteCategories[_selectedCategoryIndex];

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimationController,
        builder: (context, child) {
          return Stack(
            children: [
              AnimatedWaveBackground(
                color1:
                    _color1Animation.value ??
                    selectedCategory.color1,
                color2:
                    _color2Animation.value ??
                    selectedCategory.color2,
              ),
              child!,
            ],
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                child: _buildSegmentedControl(),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  transitionBuilder:
                      (child, animation) =>
                          FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                  child: _buildCategoryDetails(
                    selectedCategory,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSegmentedControl<int>(
        // FIX: The text color now changes based on selection.
        children: {
          for (
            var i = 0;
            i < _wasteCategories.length;
            i++
          )
            i: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: Text(
                _wasteCategories[i].name,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color:
                      _selectedCategoryIndex == i
                      ? _wasteCategories[i]
                            .color1 // Use theme color for selected text
                      : Colors
                            .white, // White for unselected text
                ),
              ),
            ),
        },
        groupValue: _selectedCategoryIndex,
        onValueChanged: (int newIndex) {
          setState(() {
            _updateColorAnimations(
              _wasteCategories[_selectedCategoryIndex],
              _wasteCategories[newIndex],
            );
            _selectedCategoryIndex = newIndex;
            _contentController.forward(from: 0.0);
          });
        },
        selectedColor: Colors.white,
        unselectedColor: Colors.transparent,
        borderColor: Colors.white,
        pressedColor: Colors.white.withValues(
          alpha: 0.2,
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(
    WasteCategory category,
  ) {
    return ListView(
      key: ValueKey<String>(category.name),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      children: [
        const SizedBox(height: 20),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _contentController,
            curve: const Interval(
              0.1,
              0.7,
              curve: Curves.elasticOut,
            ),
          ),
          child: Icon(
            category.icon,
            size: 80,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.2, 0.8),
          ),
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.3, 0.9),
          ),
          child: Text(
            'Dispose in the ${category.binInfo}',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.white.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Examples",
          style: TextStyle(
            color: Colors.white.withValues(
              alpha: 0.8,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(category.items.length, (
          index,
        ) {
          return _buildListItem(
            category.items[index],
            index,
          );
        }),
      ],
    );
  }

  Widget _buildListItem(
    WasteItem item,
    int index,
  ) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _contentController,
              curve: Interval(
                0.4 + (index * 0.1),
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _contentController,
          curve: Interval(
            0.4 + (index * 0.1),
            1.0,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.15,
            ),
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Animated Background Widgets (No changes needed here) ---
class AnimatedWaveBackground
    extends StatelessWidget {
  final Color color1;
  final Color color2;
  const AnimatedWaveBackground({
    super.key,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(
        color1: color1,
        color2: color2,
      ),
      child: Container(),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  BackgroundPainter({
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color1
      ..style = PaintingStyle.fill;
    final paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.5);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.5,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      Paint()
        ..color = color1.withValues(alpha: 0.3),
    );
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(
    covariant BackgroundPainter oldDelegate,
  ) {
    return oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2;
  }
}
