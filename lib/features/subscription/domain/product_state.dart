import 'package:in_app_purchase/in_app_purchase.dart';

class ProductState {
  final bool isLoading;
  final bool isAvailable;
  final List<ProductDetails> products;
  final String? error;

  const ProductState({
    this.isLoading = true,
    this.isAvailable = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    bool? isAvailable,
    List<ProductDetails>? products,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      isAvailable: isAvailable ?? this.isAvailable,
      products: products ?? this.products,
      error: error ?? this.error,
    );
  }
}