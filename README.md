# Valuta - Currency Converter & Exchange Rates

**Valuta** is a modern Android application built with Flutter that provides real-time exchange rate information and seamless currency conversion. Featuring a clean **Material 3** design, the app is designed to be fast, responsive, and user-friendly.

<div align="center">
  <image src="assets/mockup.png", width=800, alt="Valuta Android App Mockup">
</div>

This project was developed as a final submission for the Dicoding course: *"Belajar Membuat Aplikasi Flutter untuk Pemula"*.

## 🌟 Features

* **Live Exchange Rates:** View up-to-date exchange rates for hundreds of currencies based on a customizable base currency.
* **Instant Converter:** A dedicated calculator to convert values between any two global currencies instantly.
* **Smart Search:** Easily find currencies by their code (e.g., USD, IDR) or full name using the integrated search filter.
* **Responsive UI:** The interface adapts to various screen sizes and orientations, ensuring a consistent experience on phones and tablets.
* **Reliable Data Fetching:** Utilizes a primary and fallback API mechanism to ensure data availability even if one server is down.
* **Modern Typography:** Integrated with Google Fonts for a premium look and feel.

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev) (v3.38.5)
* **Language:** [Dart](https://dart.dev) (v3.10.4)
* **UI Design:** Material 3
* **Key Libraries:**
  * `http`: For handling API requests.
  * `intl`: For number and currency formatting.
  * `google_fonts`: For custom typography.
* **API Source:** [fawazahmed0/exchange-api](https://github.com/fawazahmed0/exchange-api)

## 🚀 Installation & Setup

Ensure you have the Flutter SDK installed and configured on your machine.

1. **Clone the Repository**

    ```bash
    git clone https://github.com/yourusername/valuta.git
    cd valuta
    ```

2. **Install Dependencies**
    Fetch the required packages defined in `pubspec.yaml`:

    ```bash
    flutter pub get
    ```

3. **Run the Application**
    Connect an Android device or start an emulator, then run:

    ```bash
    flutter run
    ```

## 📦 Building the APK

To generate a production-ready APK file, follow these steps:

1. Open your terminal in the project root directory.
2. Run the build command:

    ```bash
    flutter build apk --release
    ```

3. Once the process is complete, you can find the APK file at:
    `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Project Structure

* `lib/services/`: Contains the API logic and data fetching service (`currency_api.dart`).
* `lib/screens/`: Contains the UI for Home (Rates), Converter, and About pages.
* `lib/theme.dart`: Global theme configuration including colors, fonts, and component styles.
* `lib/main.dart`: The entry point of the application and navigation logic.

## ⚠️ Disclaimer

This application is intended for **educational purposes only**. The exchange rate data is sourced from a free public API and may not be 100% accurate or reflect real-time market rates used by official financial institutions. It should not be used as a primary reference for actual financial transactions.
