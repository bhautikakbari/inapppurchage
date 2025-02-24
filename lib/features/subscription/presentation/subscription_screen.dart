import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:inapppurchage/features/subscription/presentation/widgets/current_plan_card.dart';
import 'package:inapppurchage/features/subscription/presentation/widgets/subscription_card.dart';
import '../../../utils/app_messages.dart';
import '../domain/subscription_state.dart';
import '../providers/store_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  void _showMessage(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionProvider);

    // Handle purchase status changes
    ref.listen<SubscriptionState>(subscriptionProvider, (previous, current) {
      if (current.error != null && current.error != previous?.error) {
        _showMessage(context, current.error!, true);
      }

      if (current.purchaseStatus != previous?.purchaseStatus) {
        switch (current.purchaseStatus) {
          case PurchaseStatus.purchased:
            _showMessage(context, AppMessages.purchaseSuccess, false);
            break;
          case PurchaseStatus.error:
            _showMessage(context, current.error ?? AppMessages.purchaseError, true);
            break;
          case PurchaseStatus.canceled:
            _showMessage(context, AppMessages.purchaseCancelled, true);
            break;
          case PurchaseStatus.pending:
            _showMessage(context, AppMessages.purchasePending, false);
            break;
          default:
            break;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        centerTitle: true,
      ),
      body: subscriptionState.isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading subscription plans...'),
          ],
        ),
      )
          : subscriptionState.storeStatus == StoreStatus.notAvailable
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              subscriptionState.error ?? AppMessages.storeKeyMissing,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(subscriptionProvider.notifier).loadProducts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          ref.read(subscriptionProvider.notifier).loadProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (subscriptionState.currentPlan != null) ...[
                CurrentPlanCard(plan: subscriptionState.currentPlan!),
                const SizedBox(height: 24),
              ],
              const Text(
                'Available Plans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (subscriptionState.products.isEmpty)
                const Center(
                  child: Text('No subscription plans available'),
                )
              else
                ...subscriptionState.products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SubscriptionCard(
                      product: product,
                      isSelected: subscriptionState.currentPlan?.id == product.id,
                      isLoading: subscriptionState.isPurchasing &&
                          subscriptionState.currentPlan?.id == product.id,
                      onTap: () {
                        if (!subscriptionState.isPurchasing) {
                          ref.read(subscriptionProvider.notifier)
                              .purchaseProduct(product);
                        }
                      },
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}