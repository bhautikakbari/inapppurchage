import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionCard extends StatelessWidget {
  final ProductDetails product;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    this.isLoading = false,  // Added isLoading parameter with default value
  });

  String get _duration {
    if (product.id.contains('3months')) return '3 Months';
    if (product.id.contains('6months')) return '6 Months';
    return '12 Months';
  }

  String get _pricePerMonth {
    final price = product.rawPrice;
    final months = _duration.contains('3') ? 3 : _duration.contains('6') ? 6 : 12;
    return (price / months).toStringAsFixed(2);
  }

  List<String> get _features {
    if (_duration.contains('3')) {
      return [
        'Basic Features',
        'Email Support',
        '3 Months Access',
      ];
    } else if (_duration.contains('6')) {
      return [
        'All Basic Features',
        'Priority Support',
        '6 Months Access',
        '10% Discount',
      ];
    } else {
      return [
        'All Premium Features',
        '24/7 Priority Support',
        '12 Months Access',
        '20% Discount',
        'Exclusive Content',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: 2,
        ),
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _duration,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.currencySymbol}$_pricePerMonth/month',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.price,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ..._features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(feature),
              ],
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isSelected
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
                foregroundColor: isSelected
                    ? Colors.black
                    : Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
                  : Text(
                isSelected ? 'Current Plan' : 'Subscribe',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Active subscription',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}