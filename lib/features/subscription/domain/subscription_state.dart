import 'package:in_app_purchase/in_app_purchase.dart';

enum StoreStatus {
  notInitialized,
  notAvailable,
  available,
  noProducts,
  error,
}

class SubscriptionState {
  final bool isLoading;
  final List<ProductDetails> products;
  final ProductDetails? currentPlan;
  final String? error;
  final bool isPurchasing;
  final StoreStatus storeStatus;
  final PurchaseStatus purchaseStatus;

  const SubscriptionState({
    this.isLoading = true,
    this.products = const [],
    this.currentPlan,
    this.error,
    this.isPurchasing = false,
    this.storeStatus = StoreStatus.notInitialized,
    this.purchaseStatus = PurchaseStatus.pending,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    List<ProductDetails>? products,
    ProductDetails? currentPlan,
    String? error,
    bool? isPurchasing,
    StoreStatus? storeStatus,
    PurchaseStatus? purchaseStatus,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      currentPlan: currentPlan ?? this.currentPlan,
      error: error,  // Allow setting to null
      isPurchasing: isPurchasing ?? this.isPurchasing,
      storeStatus: storeStatus ?? this.storeStatus,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
    );
  }
}