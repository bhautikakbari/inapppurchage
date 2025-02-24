# Flutter In-App Subscription Implementation

A Flutter application demonstrating in-app subscription implementation with a clean architecture approach and modern UI design. This project showcases how to handle in-app purchases for both iOS and Android platforms.

<div align="center">
  <img src="https://i.imgur.com/YourScreenshotURL.png" alt="Subscription Plans" width="300"/>
</div>

## 🌟 Features

- ✅ In-App Purchase integration
- 🔄 Multiple subscription plans (3, 6, and 12 months)
- 💳 Secure purchase handling
- 🎨 Modern UI design with Material 3
- ⚡ Real-time status updates
- 🔒 Error handling and validation
- 📱 Cross-platform (iOS & Android)
- 🔄 Purchase restoration support

### Project Structure

<div align="left">
  <table>
    <tr>
      <th>Project Structure</th>
    </tr>
    <tr>
      <td>
        <pre>
lib/
├── features/
│   └── store/
│       ├── domain/          # State management models
│       │   ├── product_state.dart
│       │   └── purchase_state.dart
│       ├── providers/       # Riverpod providers
│       │   └── subscription_provider.dart
│       └── presentation/
            ├── screens/
│           │   └── subscription_screen.dart
│           └── widgets/
│               ├── subscription_card.dart
│               └── current_plan_card.dart
├── utils/
│   └── app_messages.dart
└── main.dart</pre>
      </td>
    </tr>
  </table>
</div>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (2.0 or higher)
- Xcode (for iOS)
- Android Studio (for Android)
- Paid Apple Developer account (for iOS)
- Google Play Developer account (for Android)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/flutter_subscription_app.git


## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
