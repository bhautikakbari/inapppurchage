import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../utils/app_messages.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isStoreReady = false;

  Future<bool> initializeStore() async {
    _isStoreReady = await _iap.isAvailable();
    return _isStoreReady;
  }

  bool get isStoreReady => _isStoreReady;

  String getStoreError() {
    if (!_isStoreReady) {
      if (Platform.isAndroid) {
        return AppMessages.playStoreNotAvailable;
      } else if (Platform.isIOS) {
        return AppMessages.appStoreNotAvailable;
      }
    }
    return AppMessages.storeKeyMissing;
  }

  Future<PurchaseResult> validateReceipt(PurchaseDetails purchase) async {
    // Implement your receipt validation logic here
    // This should typically communicate with your backend
    try {
      if (purchase.verificationData.serverVerificationData.isEmpty) {
        return PurchaseResult(
          success: false,
          message: 'Invalid purchase receipt',
        );
      }

      // Simulate server validation
      await Future.delayed(const Duration(seconds: 1));

      return PurchaseResult(
        success: true,
        message: AppMessages.purchaseSuccess,
      );
    } catch (e) {
      return PurchaseResult(
        success: false,
        message: 'Receipt validation failed: ${e.toString()}',
      );
    }
  }
}

class PurchaseResult {
  final bool success;
  final String message;
  final dynamic data;

  PurchaseResult({
    required this.success,
    required this.message,
    this.data,
  });
}