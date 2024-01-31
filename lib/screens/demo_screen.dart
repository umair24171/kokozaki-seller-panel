import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int? _selectedCategoryIndex;
  String? _selectedProduct;

  List<String> categories = [
    'Popular',
    'New',
    'Fashion &Cosmetics',
    'Food &Drinks',
    'Sport',
    'Kids',
    'Electronics',
    'Home'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    categories[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Hind',
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    _selectedCategoryIndex == index
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex =
                          _selectedCategoryIndex == index ? null : index;
                    });
                  },
                ),
              ),
              if (_selectedCategoryIndex == index)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Products:',
                        style: TextStyle(
                          fontFamily: 'Hind',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedProduct,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProduct = newValue;
                          });
                        },
                        items: List.generate(
                          5,
                          (index) => DropdownMenuItem<String>(
                            value: 'Product $index',
                            child: Text('Product $index'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
