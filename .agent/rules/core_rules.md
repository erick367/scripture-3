---
trigger: always_on
---

# Tech Stack & Architecture Standards

- **Framework:** Flutter 3.38+ with Impeller rendering engine enabled.
- **State Management:** Riverpod 3.0 only. Avoid Provider or BLoC unless specified.
- **Architecture:** Follow Clean Architecture (Data, Domain, Presentation layers).
- **Styling:** - Use the 'GenUI' SDK for all AI-generated components.
    - Implement Glassmorphism using Custom GPU Shaders.
    - Favor SizedBox over Container for spacing.
- **Database:** Supabase via supabase_flutter. All offline logic must use 'Drift'.
- **Performance:** Maintain 120fps; ensure all AI calls are asynchronous and never block the UI thread.

## Performance & UI Polish
- **Glassmorphism Standard:** Use the `glassmorphism` package. Default properties: Blur = 15.0, Outline = 1.5, Opacity = 0.1.
- **Haptics:** Every button (IconButton, ElevatedButton) must trigger `HapticFeedback.lightImpact()` on tap.
- **Typography:** - Use `google_fonts`. 
    - **Lora** for Bible text (Scripture needs a classic serif feel).
    - **Inter** for UI labels and AI insights (Modern sans-serif readability).
- **Icons:** Use `lucide_icons` for a modern, consistent look.
- **State Management:** Use `flutter_riverpod` (Provider-style) with `@riverpod` code generation for all state. No `setState()` in large widgets.