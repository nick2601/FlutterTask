# Flutter User Management App
A Flutter application that demonstrates user, post, comment, todo, and album management using JSONPlaceholder API. The app is built with Bloc for state management, follows Clean Architecture principles, and supports responsive UI with animations and interactivity.

## Features
### User Management
- View a list of users and their details.
- Dynamically fetch user data from the API.

### Posts
- Display posts for a specific user.
- Navigate to view comments for a specific post.

### Comments
- Fetch and display comments for a post.
- Add new comments dynamically with form validation.

### Todos
- View and manage a user's todos.
- Mark todos as completed or uncompleted.

### Albums
- Fetch and display a user's albums with their photos.

### Interactive Design
- Clean and modern UI with hover effects for desktop.
- Ripple effects and animations for mobile.
- Gradient backgrounds and color themes.
- Responsive Design with list and grid layouts for phones and tablets.

## Architecture
The app is built following Clean Architecture principles, separating the codebase into three layers:

1. **Presentation Layer**
   - UI Components: Screens, widgets, and custom components.
   - State Management: Managed using flutter_bloc.
2. **Domain Layer**
   - Entities: Core business objects like UserEntity, PostEntity, TodoEntity.
   - Use Cases: Encapsulate application-specific business rules.
3. **Data Layer**
   - Repositories: Interfaces for abstracting data sources.
   - Data Sources: Handle REST API calls and offline caching.

## Screenshots
| User List | User Posts | Comments | Todos |
|-----------|------------|----------|-------|
|           |            |          |       |

## Installation
### Prerequisites
- **Flutter SDK**: Install the Flutter SDK from the official Flutter website.
- **Dart**: Dart SDK is included with Flutter.
- **JSONPlaceholder API**: No setup required. The app uses the free JSONPlaceholder API.

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/flutter-user-management.git
   cd flutter-user-management
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure
```plaintext
lib
├── data
│   ├── datasources    # Remote and local data sources
│   ├── models         # JSON-to-Dart models
│   ├── repositories   # Repository implementations
├── domain
│   ├── entities       # Core business models (UserEntity, PostEntity, etc.)
│   ├── repositories   # Abstract repository interfaces
│   ├── usecases       # Business logic (e.g., AddCommentUseCase)
├── presentation
│   ├── bloc           # Bloc classes for state management
│   ├── pages          # UI screens (UsersPage, CommentsPage, etc.)
│   ├── widgets        # Reusable UI components
├── di                 # Dependency injection setup (GetIt)
├── main.dart          # App entry point
```

## API Integration
This app integrates with the JSONPlaceholder API for dynamic data. Below are the endpoints used:

| Endpoint | Description |
|----------|-------------|
| /users   | Fetch all users. |
| /posts   | Fetch posts for a specific user. |
| /comments| Fetch and add comments on a post. |
| /todos   | Fetch todos for a specific user. |
| /albums  | Fetch user albums. |
| /photos  | Fetch photos in an album. |

## Key Packages
| Package               | Description |
|----------------------|-------------|
| flutter_bloc         | State management using Bloc/Cubit pattern. |
| get_it               | Dependency injection for clean architecture. |
| http                 | HTTP client for REST API integration. |
| shared_preferences    | Offline data caching. |
| equatable            | Simplifies equality comparison in states. |

## How It Works
### Users Page
- Displays a list of users fetched from /users.
- Tapping a user navigates to their posts page.

### User Posts
- Displays a list of posts for the selected user (/posts?userId=<id>).
- Tapping a post navigates to its comments page.

### Comments
- Displays comments for the selected post (/comments?postId=<id>). 
- Users can add a comment using the form at the bottom.

### Todos
- Displays todos for a user (/todos?userId=<id>). 
- Users can mark todos as complete or incomplete.

### Albums
- Displays albums for a user (/albums?userId=<id>). 
- Photos in the album are fetched dynamically.

## Contribution
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature
   ```
5. Open a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contact
For inquiries or suggestions, feel free to reach out to:
📧 youremail@example.com
