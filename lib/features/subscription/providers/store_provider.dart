import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../utils/app_messages.dart';
import '../domain/subscription_state.dart';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState()) {
    _init();
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Test product IDs
  static final Set<String> _productIds = Platform.isAndroid
      ? {
    'android_3months_sub',
    'android_6months_sub',
    'android_12months_sub',
  }
      : {
    'ios_3months_sub',
    'ios_6months_sub',
    'ios_12months_sub',
  };

  Future<void> _init() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          error: Platform.isAndroid
              ? AppMessages.playStoreNotAvailable
              : AppMessages.appStoreNotAvailable,
          storeStatus: StoreStatus.notAvailable,
        );
        return;
      }

      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          state = state.copyWith(
            error: error.toString(),
            isLoading: false,
            storeStatus: StoreStatus.error,
          );
        },
      );

      await loadProducts();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Initialization error: ${e.toString()}',
        storeStatus: StoreStatus.error,
      );
    }
  }

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // For development: Create test products
      if (true) { // Change this condition based on your environment
        final testProducts = [
          ProductDetails(
            id: Platform.isAndroid ? 'android_3months_sub' : 'ios_3months_sub',
            title: '3 Months Premium',
            description: 'Access all premium features for 3 months',
            price: '\$9.99',
            rawPrice: 9.99,
            currencyCode: 'USD',
            currencySymbol: '\$',
          ),
          ProductDetails(
            id: Platform.isAndroid ? 'android_6months_sub' : 'ios_6months_sub',
            title: '6 Months Premium',
            description: 'Access all premium features for 6 months',
            price: '\$17.99',
            rawPrice: 17.99,
            currencyCode: 'USD',
            currencySymbol: '\$',
          ),
          ProductDetails(
            id: Platform.isAndroid ? 'android_12months_sub' : 'ios_12months_sub',
            title: '12 Months Premium',
            description: 'Access all premium features for 12 months',
            price: '\$29.99',
            rawPrice: 29.99,
            currencyCode: 'USD',
            currencySymbol: '\$',
          ),
        ];

        state = state.copyWith(
          products: testProducts,
          isLoading: false,
          storeStatus: StoreStatus.available,
        );
        return;
      }

      // Real store products query
      final ProductDetailsResponse response =
      await _iap.queryProductDetails(_productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }

      if (response.productDetails.isEmpty) {
        state = state.copyWith(
          error: AppMessages.noProducts,
          isLoading: false,
          storeStatus: StoreStatus.noProducts,
        );
        return;
      }

      state = state.copyWith(
        products: response.productDetails,
        isLoading: false,
        storeStatus: StoreStatus.available,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        storeStatus: StoreStatus.error,
      );
    }
  }

  Future<void> purchaseProduct(ProductDetails product) async {
    try {
      state = state.copyWith(isPurchasing: true, error: null);

      // For development: Simulate purchase
      if (true) { // Change this condition based on your environment
        await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

        state = state.copyWith(
          currentPlan: product,
          isPurchasing: false,
          purchaseStatus: PurchaseStatus.purchased,
        );
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      final bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        state = state.copyWith(
          error: AppMessages.purchaseError,
          isPurchasing: false,
          purchaseStatus: PurchaseStatus.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPurchasing: false,
        purchaseStatus: PurchaseStatus.error,
      );
    }
  }

  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        state = state.copyWith(
          isPurchasing: true,
          purchaseStatus: PurchaseStatus.pending,
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        state = state.copyWith(
          error: purchaseDetails.error?.message ?? AppMessages.purchaseError,
          isPurchasing: false,
          purchaseStatus: PurchaseStatus.error,
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Find the product details for this purchase
        final product = state.products.firstWhere(
              (product) => product.id == purchaseDetails.productID,
          orElse: () => state.products.first,
        );

        state = state.copyWith(
          currentPlan: product,
          isPurchasing: false,
          purchaseStatus: PurchaseStatus.purchased,
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}