# SchoolMate - School Management System

## Project Overview
SchoolMate is a comprehensive School Management System built with **Flutter**. It provides a robust platform for managing school operations through three primary roles: **Admin**, **Teacher**, and **Student**. The application emphasizes modularity, ease of use, and local data persistence.

## Key Features

### 🔐 Secure Authentication
- **Role-Based Access**: Specialized workflows for Admins, Teachers, and Students.
- **Signup/Login**: Secure credential management and password toggle visibility.
- **Data Persistence**: Localized text-file storage for credentials and role-specific data.

### 🛡️ Admin Dashboard (Governance)
- **User Management**: Create student/teacher accounts, and manage user statuses (Block/Delete).
- **Academic Structure**: Manage Classes, Sections, and link them to classrooms.
- **Subject Control**: Define subjects and assign them to specific teachers and classes.
- **Financial Tracking**: Define fee structures and track payment histories.
- **System Configuration**: Manage school meta-data (Name, Address, Academic Year).

### 👨‍🏫 Teacher Dashboard (Classroom Management)
- **Profile & Subjects**: View assigned teaching modules and personal profiles.
- **Attendance Logger**: Mark, view, and edit daily student attendance with visual status indicators.
- **Assignment Hub**: Create, update, and manage student assignments and deadlines.
- **Results Processor**: Input, update, and publish exam marks and performance reviews.
- **Scheduling**: View and manage personalized weekly/daily timetables.
- **Communication**: Post and manage class-specific notices.

### 🎓 Student Dashboard (Learning Portal)
- **Academic Reports**: View real-time attendance percentages and daily status logs.
- **Assignments**: Track pending work, check statuses, and simulate submission workflows.
- **Grades Hub**: View exam results, subject-wise grades, and GPA calculations.
- **Timetable Access**: Interactive weekly view of student schedules.
- **Notice Board**: Stay updated with school-wide and class-specific announcements.
- **Fee Management**: View pending balances and transaction history.

## 🛠️ Technology Stack
- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **UI Components**: Material Design 3
- **Data Storage**: Local Text File Persistence (`path_provider`)
- **State Management**: Stateful Widgets & Service-Oriented Architecture

## 📂 Project Structure
```text
lib/
├── main.dart           # Application Entry Point
├── models/             # Data structure definitions (User, Class, Subject, etc.)
├── services/           # Business logic classes (Auth, Subject, Teacher features)
└── screens/            # UI Layer
    ├── admin/          # Administrative management modules
    ├── auth/           # Authentication screens (Login/Signup)
    ├── dashboard/      # Role-based landing hubs
    ├── student/        # Student portal features
    └── teacher/        # Teacher management features

## 🧪 Automated Testing
The project includes a comprehensive **Appium Framework** for Android automation:
- **Language**: Java
- **Build Tool**: Maven
- **Test Runner**: TestNG
- **Design Pattern**: Page Object Model (POM)
- **Location**: `/appium_tests`

Refer to the [Appium README](appium_tests/README.md) for setup and execution instructions.
```

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- An Emulator or Physical Device

### Installation
1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/AhmadR-11/SchoolMate.git
    ```
2.  **Navigate to Directory**:
    ```bash
    cd school_MS
    ```
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Launch the App**:
    ```bash
    flutter run
    ```

## 📝 Design Decisions
- **Text-Based Storage**: Chosen for simplicity and ease of portability as per the assignment requirements.
- **Modular Services**: Logic is separated from UI components to ensure maintainability and scalability.

---
**Developed by:** AhmadR-11  
**Project:** DevOps Assignment #1 - School Management System

