# Personal Project - Android - Movie APP

# TO - DO

## BLoC Architecture Implementation for Infinite Scroll Movie List

### 1. Define Events
- [ ] Create `MovieEvent` as the base abstract class for all movie-related events.
  - [ ] Add `MovieFetched` event to trigger the fetching of movies from the API.

### 2. Define States
- [ ] Create `MovieState` as the base abstract class for all movie-related states.
  - [ ] Add `MovieInitial` state for the initial state of the BLoC.
  - [ ] Add `MovieLoading` state to indicate that movies are being loaded.
  - [ ] Add `MovieSuccess` state to store the list of movies and the current page.
  - [ ] Add `MovieFailure` state to handle errors during movie fetching.

### 3. Implement the BLoC
- [ ] Create `MovieBloc` class extending `Bloc<MovieEvent, MovieState>`.
  - [ ] Implement the `MovieBloc` constructor to initialize with a `MovieRepository`.
  - [ ] Implement the `_onMovieFetched` method to handle `MovieFetched` event.
    - [ ] Check if the current state is `MovieLoading` to prevent duplicate API calls.
    - [ ] Fetch movies using the `MovieRepository`.
    - [ ] Emit `MovieSuccess` state with the updated list of movies and current page.
    - [ ] Handle and emit `MovieFailure` state in case of errors.

### 4. Create the Repository
- [ ] Create `MovieRepository` class.
  - [ ] Implement `fetchMovies` method to interact with the API and return a list of movies.

### 5. Connect BLoC to the UI
- [ ] Create `MovieListView` widget to display the list of movies.
  - [ ] Use `BlocBuilder<MovieBloc, MovieState>` to build the UI based on the current state.
  - [ ] Add a `ScrollController` to detect when the user has scrolled near the end of the list.
  - [ ] Trigger the `MovieFetched` event when the scroll threshold is reached.
  - [ ] Display a loading indicator while fetching more movies.
  - [ ] Display an error message if `MovieFailure` state is emitted.

### 6. Setup the Main Application
- [ ] Update `main.dart` to initialize the `MovieRepository` and provide the `MovieBloc` to the `MovieListView`.
  - [ ] Use `BlocProvider` to inject `MovieBloc` into the widget tree.


