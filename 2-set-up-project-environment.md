### Merge Description:

This merge introduces the following features:

- **Landing Splash Screen**: The initial splash screen (`Splashscreen1`) is displayed with an animated transition, powered by the `flutter_animated_splash` package.
- **Homepage Navigation**: Upon completion of the animation (after 5 seconds), the user is automatically navigated to the `Homepage`.
- **Future Enhancement**: In upcoming updates, the `Homepage` will be replaced by a second splash screen, enabling a multi-stage splash sequence.

**Dependencies Installed:**
1. **`flutter_animated_splash`**: This package facilitates the creation of animated splash screens with customizable transitions, including size changes, curves, and durations.
2. **`flutter_riverpod`**: A state management solution used to handle app states, such as determining if the user is new and managing persistence. It provides a scalable and flexible approach to state management.

This commit establishes the foundational splash flow and homepage transition. Future iterations will replace the homepage with a second splash screen as part of the enhanced splash sequence.

---

### Explanation of Installed Dependencies:

1. **`flutter_animated_splash`**:
   - A package designed to create animated splash screens with customizable effects. It was utilized here to implement a splash screen with smooth transitions and to navigate to the homepage after the animation concludes.

2. **`flutter_riverpod`**:
   - A state management library that offers a straightforward and efficient way to manage and access app states. It is employed in this project to track user status (e.g., new user) and control navigation flows based on that state. Riverpod is chosen for its scalability and flexibility in handling complex app states.

---

### Folder Structure:

```
lib:
  - Splash: [Contains all splash screens]
  - Widget: [Contains shared widgets and reusable designs]
  - Pages: [Contains all pages]
  - state_provider: [Contains all state configurations using flutter_riverpod]

assets:
  - logos: [Contains all logo assets]
```