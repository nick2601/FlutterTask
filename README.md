# FlutterTask
This Flutter application demonstrates a Clean Architecture + SOLID approach to consuming data from JSONPlaceholder using BLoC for state management, GetIt for dependency injection, Dio for networking, and SharedPreferences for basic offline caching.

It covers:

Users → Display user info
Albums → Display user albums and photos
Posts → Display user posts and comments
Todos → Display user todos (check/uncheck)
Each feature is interactive and responsive, with a modern, gradient‐based design for multiple screens (mobile + tablet).

Table of Contents
Features
Architecture Overview
Project Structure
Dependencies
Getting Started
Screenshots
Testing
License
Features
User List: Filter and sort by username. Tap user → see details (albums, posts, todos).
Albums: Hover effect (desktop/web), click album → see photos (grid view).
Posts: List or grid layout (depending on screen size), click post → see or add comments.
Todos: Check/uncheck items, displayed in a list (or grid).
Offline Caching: Some data is cached in SharedPreferences for offline usage.
Responsive UI: Switches between list and grid on tablet vs. phone.
BLoC: Each feature has a dedicated BLoC (e.g. UserBloc, AlbumBloc, etc.).
Architecture Overview
The project follows a Clean Architecture pattern with SOLID principles:

Domain Layer

Entities (e.g. UserEntity, PostEntity)
Use Cases (business logic, e.g. FetchUsersUseCase, AddCommentUseCase)
Repository Interfaces (abstract contracts)
Data Layer

Models (DTOs, e.g. UserModel extends UserEntity)
Data Sources
Remote (uses Dio to call JSONPlaceholder)
Local (uses SharedPreferences for caching)
Repository Implementations (implements the domain repository interfaces)
Presentation Layer

BLoC classes (e.g. UserBloc, AlbumBloc) managing UI state
UI/Widgets (Flutter pages & widgets)
Dependency Injection

GetIt registers data sources, repositories, use cases, and BLoCs.
Project Structure
kotlin
Copy
Edit
lib/
 ┣ domain/
 ┃ ┣ entities/
 ┃ ┣ repositories/
 ┃ ┗ usecases/
 ┣ data/
 ┃ ┣ datasources/
 ┃ ┣ models/
 ┃ ┗ repositories/
 ┣ presentation/
 ┃ ┣ bloc/
 ┃ ┗ pages/
 ┣ service_locator.dart
 ┗ main.dart

test/
 ┣ domain/
 ┣ data/
 ┣ presentation/
 ┗ ...
Dependencies
Primary packages:

flutter_bloc (BLoC state management)
dio (HTTP client)
get_it (Dependency injection)
shared_preferences (Offline caching)
Optional:

equatable (For state equality checks in BLoC)
mocktail or mockito for testing
Please see the pubspec.yaml for exact versions.
