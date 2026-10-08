<h1 align="center">Rick and Morty App</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Clean%20Architecture-000000?style=for-the-badge&logo=architecture&logoColor=white" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/Cubit-000000?style=for-the-badge&logo=bloc&logoColor=white" alt="Cubit">
</p>

<p align="center">
  A Flutter application built to consume the <strong>Rick and Morty API</strong>, focusing on <strong>Clean Architecture</strong>, state management, pagination, caching, reusable components, and maintainable Flutter code.
</p>

---

## 📱 Overview

The application consumes the [Rick and Morty API](https://rickandmortyapi.com/) and displays characters in a paginated list.

The main goal of this project is to demonstrate how I structure a Flutter application using **Clean Architecture**, while implementing real-world concepts such as infinite scrolling, state management, caching, asynchronous operations, and API integration.

## 🎥 App Demo
<img width="275" height="604" alt="image" src="https://github.com/user-attachments/assets/3db1e149-7f6e-4175-8cb0-b79f3f0bb5a7" />








## ✨ Features

* Character listing
* Character information
* Infinite scroll pagination
* API integration
* Loading and error states
* Image loading and error handling
* Caching
* Scroll-based pagination with `ScrollController`
* State management with Cubit
* Reusable widgets
* Separation of responsibilities

---

## 🏗️ Architecture

The project follows **Clean Architecture**, separating responsibilities into different layers:

```text
lib/
├── data/
│   ├── data_sources/
│   │   ├── local/
│   │   └── remote/
│   ├── model/
│   └── repositories/
├── domain/
│   ├── entities/
│   │   ├── base/
│   │   └── character/
│   ├── either_of/
│   ├── error/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── bloc/
    └── ui/
```

### Data Layer

Responsible for communication with external and local data sources.

It contains:

* Remote data sources
* Local data sources
* Models
* Repository implementations

The remote layer is responsible for consuming the Rick and Morty API, while the local layer handles cached data.

### Domain Layer

Contains the core business logic and abstractions of the application.

This layer includes:

* Entities
* Repository contracts
* Use cases
* Error handling
* Result handling through `EitherOf`

The domain layer is independent from Flutter and external data sources.

### Presentation Layer

Responsible for the application UI and state management.

The project uses **Cubit** to control the different loading, success, pagination, and error states.

---

## 🔄 Pagination

The character list uses **infinite scroll pagination**.

A `ScrollController` monitors the position of the `ListView`. When the user gets close to the end of the currently loaded characters, the application requests the next page.

```text
[UI] User scrolls near the bottom of the list
     ↓
[UI] ScrollController detects the position and triggers loadNextPage()
     ↓
[Cubit] Emits CharactersLoaded(isLoadingMore: true)
     ↓
[UI] Shows a loading indicator at the bottom of the list
     ↓
[Domain] GetCharacters UseCase is called with the next page number
     ↓
[Data] CharacterRepositoryImpl.getCharactersFromRepository(page)
     ↓
     ├──> [Data] Check LocalDataSource for cached page
     │         ↓
     │    (Found) ──> Return cached PaginatedResponse
     │         ↓
     │    (Not Found) ──> [Data] Fetch from RemoteDataSource (API)
     │                        ↓
     │                   [Data] Save new page to LocalDataSource (Cache)
     │                        ↓
     │                   Return remote PaginatedResponse
     ↓
[Cubit] Appends the new characters to the existing list
     ↓
[Cubit] Emits CharactersLoaded(isLoadingMore: false, characters: updatedList)
     ↓
[UI] ListView rebuilds with new items, loader disappears
```

The application keeps the characters already displayed while the next page is being loaded.

This allows pagination to happen without replacing the current content with a full-screen loading state.

---

## 🧠 State Management

The project uses **Cubit** for state management.

The state flow separates the initial loading process from loading additional pages:

```text
CharactersLoading
        ↓
CharactersLoaded
        ↓
CharactersLoaded(isLoadingMore: true)
        ↓
CharactersLoaded(isLoadingMore: false)
```

This allows the application to:

* Display an initial loading state
* Keep existing characters visible during pagination
* Display a loading indicator at the end of the list
* Handle errors independently

---

## 💾 Caching

The application also uses **caching** to reduce unnecessary network requests and improve the user experience.

Cached data can be reused instead of downloading the same resource repeatedly, which is especially useful when displaying character images while scrolling through a large list.

The project separates local and remote data sources, keeping caching responsibility within the **Data Layer**.

---

## 🎯 ScrollController

A `ScrollController` is responsible for monitoring the user's scroll position.

Instead of waiting for the exact end of the list, the application detects when the user is approaching the bottom and starts loading the next page in advance.

This creates a smoother infinite scrolling experience and prevents unnecessary interruptions while browsing the characters.

---

## 🌐 API

The project uses the public **Rick and Morty API**:

https://rickandmortyapi.com/

The character information displayed includes:

* Name
* Status
* Species
* Gender
* Origin
* Current location
* Image

---

## 🎨 UI

The interface was built with reusable Flutter widgets.

Character information is divided into smaller components rather than placing all UI responsibilities inside a single widget.

This keeps the presentation layer easier to read, maintain, and extend.

---

## 🧪 Technical Focus

This project demonstrates practical experience with:

* **Flutter**
* **Dart**
* **Clean Architecture**
* **Cubit / flutter_bloc**
* **Infinite Scroll Pagination**
* **ScrollController**
* **Caching**
* **REST API integration**
* **Repository Pattern**
* **Use Cases**
* **Asynchronous programming**
* **Loading and error states**
* **Reusable widgets**
* **Separation of responsibilities**

---

## 🚀 Running the Project

```bash
git clone <repository-url>
cd rick_and_morty
flutter pub get
flutter run
```

---

## 📚 Purpose

This project was created as a practical demonstration of Flutter development, focusing on architecture, code organization, API integration, state management, pagination, caching, and reusable components.

Rather than simply consuming an API, the application demonstrates how these concepts can be organized into a maintainable Flutter project using **Clean Architecture**.

---

## 👨‍💻 Author

**Yuri Mota Silva**

Flutter & Dart Developer

GitHub: [@MadMaxMota](https://github.com/MadMaxMota)


