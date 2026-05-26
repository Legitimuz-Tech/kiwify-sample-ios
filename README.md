# Kiwify Banking Demo — iOS

Sample app demonstrating the [Legitimuz SDK](https://github.com/Legitimuz-Tech/legitimuz-sdk-ios-dist) banking KYC flow on iOS.

## Requirements

- Xcode 16+
- iOS 16.0+
- Swift 5.9+

## Setup

1. Clone this repository
2. Copy the config file and fill in your credentials:
   ```bash
   cp KiwifyBankingDemo/AppConfig.swift.example KiwifyBankingDemo/AppConfig.swift
   ```
3. Open `KiwifyBankingDemo.xcodeproj` in Xcode
4. Xcode will resolve the `LegitimuzSDK` Swift Package automatically
5. Set your **Development Team** in *Signing & Capabilities*
6. Build and run

## Flow

The app presents a single screen with a CPF field and an **Iniciar** button. On tap it:

1. Creates a `kyc-banking` session via the Legitimuz API
2. Launches the SDK verification flow
3. Shows the result (Aprovado / Reprovado / Erro)

## SDK Dependency

Pulled via Swift Package Manager from:

```
https://github.com/Legitimuz-Tech/legitimuz-sdk-ios-dist
```
