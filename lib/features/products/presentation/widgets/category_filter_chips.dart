import 'package:flutter/material.dart';

class CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  static const List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Food',
    'Home',
    'Sports',
  ];

  static const Map<String, Color> categoryColors = {
    'All': Colors.blue,
    'Electronics': Colors.purple,
    'Clothing': Colors.pink,
    'Food': Colors.orange,
    'Home': Colors.green,
    'Sports': Colors.red,
  };

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory ||
              (category == 'All' && selectedCategory == null);
          final color = categoryColors[category] ?? Colors.grey;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(category == 'All' ? null : category);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: color,
              checkmarkColor: Colors.white,
              elevation: isSelected ? 4 : 0,
              pressElevation: 8,
            ),
          );
        },
      ),
    );
  }
}
