import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    super.key, 
    required this.product 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Todo image

        Text( product.title )
      ],
    );
  }
}