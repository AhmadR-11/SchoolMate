# SchoolMate Appium Automation Framework (Java)

This folder contains a Maven-based Java project for automating the SchoolMate Android application using Appium.

## Prerequisites
1.  **JDK 11** or higher.
2.  **Maven** installed.
3.  **Appium Server** installed and running (`npm install -g appium`, then run `appium`).
4.  **UIAutomator2 Driver** installed (`appium driver install uiautomator2`).
5.  **Android Emulator** or Physical Device with USB Debugging enabled.

## Project Structure
- `src/main/java/com/schoolmate/base`: Contains the `BaseTest.java` for driver setup.
- `src/main/java/com/schoolmate/pages`: Page Object Model (POM) classes.
- `src/test/java/com/schoolmate/tests`: Test scripts using TestNG.
- `src/test/resources`: Configuration files like `testng.xml`.

## Configuration
Update the `BaseTest.java` file with your specific device details:
- `setDeviceName`: Your emulator/device name.
- `setApp`: Path to the generated APK (ensure you've run `flutter build apk --debug`).

## Running Tests
To run the automated tests via terminal, navigate to this directory and execute:
```bash
mvn test
```

## Implementation Notes
- The framework uses the **Page Object Model (POM)** for better maintainability.
- ** TestNG** is used as the test runner and for assertions.
- WebElements are identified using XPath as a reliable fallback for Flutter components.
