# 🧠 Counsel Bot - Flutter

A Flutter-based mobile application for interacting with the **Counsel Bot** backend. The application allows users to configure the backend server, authenticate, and communicate with the counseling system through a simple and intuitive interface.

> **Note:** This repository contains the Flutter frontend. It is designed to work with a compatible backend server running on port **8000**.

---

## ✨ Features

- 📱 Modern Flutter-based mobile application
- 🌐 Dynamic backend IP configuration
- 🔐 User authentication
- 💾 Stores server configuration locally using SharedPreferences
- ⚡ Easy connection to locally hosted backend server
- 🎯 Simple and clean user interface

---

## 🛠 Tech Stack

- **Flutter**
- **Dart**
- **HTTP**
- **Shared Preferences**
- **Image Picker**
- **Flutter Toast**

---

## 📂 Project Structure

```
lib/
├── main.dart          # Application entry point
├── ipst.dart          # Backend IP configuration screen
├── login.dart         # Login screen
├── ...                # Other application screens
```

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

- Flutter SDK (3.x or above)
- Android Studio / VS Code
- Android Emulator or Physical Device
- A running Counsel Bot backend server

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/nozarash1/counsel-bot-flutter.git
```

### 2. Navigate to the project directory

```bash
cd counsel-bot-flutter
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

---

## Backend Configuration

When the application starts, it asks for the backend server's IP address.

Example:

```
192.168.1.100
```

The app automatically configures:

```
API Base URL:
http://192.168.1.100:8000/myapp

Image URL:
http://192.168.1.100:8000
```

These values are stored locally using **SharedPreferences**, so they do not need to be entered every time.

---

## Dependencies

The project uses the following packages:

- `http`
- `shared_preferences`
- `image_picker`
- `fluttertoast`

---

## Building the APK

Debug APK:

```bash
flutter build apk
```

Release APK:

```bash
flutter build apk --release
```

---

## Future Improvements

- Secure authentication
- HTTPS support
- Automatic server discovery
- Better error handling
- Dark mode
- Chat history
- Push notifications
- Profile management

---

## Contributing

Contributions are welcome!

1. Fork the repository
2. Create a new feature branch

```bash
git checkout -b feature-name
```

3. Commit your changes

```bash
git commit -m "Add feature"
```

4. Push the branch

```bash
git push origin feature-name
```

5. Open a Pull Request

---

## License

This project is intended for educational and academic purposes.

If you plan to use it in production, consider adding an appropriate open-source license such as the MIT License.

---

## Author

Developed by **Zain Muhammed** , **Mohammed Rashin K** , **Sagar p** and **Vignesh V Manoj**

GitHub: https://github.com/nozarash1
