# ScriptureLens AI - Web to Flutter Architecture Mapping

> **Design system reference for implementing the warm earthy aesthetic in Flutter**

---

## 🎨 Color Palette Migration

### Primary Colors
```dart
// Replace your current cyan (#00F2FF) theme with warm earthy tones

class AppColors {
  // Primary - Gold
  static const Color spiritualGold = Color(0xFFC17D4A);
  static const Color spiritualGoldLight = Color(0xFFD4A574);
  
  // Secondary - Browns
  static const Color spiritualBrown = Color(0xFF8B7355);
  static const Color spiritualBrownDark = Color(0xFF6B5D45);
  
  // Accent - Sage Green
  static const Color spiritualSage = Color(0xFFA3B18A);
  static const Color spiritualSageLight = Color(0xFF8B9A6F);
  
  // Backgrounds - Dark Earthy
  static const Color spiritualDark = Color(0xFF2C2416);
  static const Color spiritualDarkBase = Color(0xFF1A1611);
  static const Color spiritualDarkCard = Color(0xFF3D2F1F);
  
  // Neutrals
  static const Color spiritualCream = Color(0xFFFAF8F5);
}
```

---

## 📱 Navigation Architecture Mapping

### Current Flutter (4 Tabs)
```
Tab 0: Sanctuary (Home)
Tab 1: Lens (Read/Discover)  
Tab 2: Plans
Tab 3: Mentor (Journal/DBS)
```

### Web Preview (Matches Your Architecture)
```
✅ Sanctuary - HomePage with profile avatar + search icon
✅ Lens - ReadPage with READ/DISCOVER sub-tabs
✅ Plans - PlansPage
✅ Mentor - JournalPage with JOURNAL/DBS sub-tabs
```

---

## 🏗️ Component Mapping

### 1. Sanctuary (Home Screen)

**Web Component:** `/src/app/components/HomePage.tsx`  
**Flutter File:** `lib/features/sanctuary/presentation/sanctuary_screen.dart`

**Key Features:**
- Header with circular profile avatar (gradient: gold to brown)
- Search icon button (glassmorphic style)
- Verse of the Day card (large serif font - Crimson Text equivalent)
- Last Note preview card
- Prayer prompt card
- Horizontal scrolling reading plans
- Quick stats (Day Streak, Verses, Notes)

**Design Specifications:**
```dart
// Header Avatar
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.spiritualGold, AppColors.spiritualBrown],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
  ),
)

// Glassmorphic Cards
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.spiritualDarkCard.withOpacity(0.6),
        AppColors.spiritualDark.withOpacity(0.6),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
    child: // your content
  ),
)
```

---

### 2. Lens (Read Screen)

**Web Component:** `/src/app/components/ReadPage.tsx`  
**Flutter File:** `lib/features/lens/presentation/lens_screen.dart`

**Key Features:**
- Sub-tabs: READ | DISCOVER (segmented control style)
- Dramatic typography for chapter titles (large, stacked letters)
- Verse-by-verse layout with verse numbers
- Cream/white reading card with rounded corners
- Hover actions: Audio, Bookmark buttons
- Bottom actions: Share, Continue buttons

**Sub-Tab Implementation:**
```dart
Container(
  padding: EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  ),
  child: Row(
    children: [
      Expanded(
        child: TabButton(
          label: 'READ',
          isActive: activeTab == 'read',
          onTap: () => setState(() => activeTab = 'read'),
        ),
      ),
      Expanded(
        child: TabButton(
          label: 'DISCOVER',
          icon: Icons.auto_awesome,
          isActive: activeTab == 'discover',
          onTap: () => setState(() => activeTab = 'discover'),
        ),
      ),
    ],
  ),
)

// Active tab style
Container(
  decoration: BoxDecoration(
    color: AppColors.spiritualGold,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
  ),
)
```

---

### 3. Plans Screen

**Web Component:** `/src/app/components/PlansPage.tsx`  
**Flutter File:** `lib/features/discovery/presentation/bible_plans_screen.dart`

**Key Features:**
- Mix of AI-generated and curated plans
- Progress indicators for active plans
- Glassmorphic cards with gradients
- Tag system for categorization

---

### 4. Mentor (Journal/DBS)

**Web Component:** `/src/app/components/JournalPage.tsx`  
**Flutter File:** `lib/features/mentor/presentation/mentor_screen_unified.dart`

**Key Features:**
- Sub-tabs: JOURNAL | DBS
- "New Prayer Entry" prominent gradient button
- Quick stats: Total, This Week, Answered
- Journal entry cards with tags and verse references
- Gradient backgrounds per entry

---

### 5. Me Screen (Profile)

**Web Component:** `/src/app/components/MeScreen.tsx`  
**Flutter File:** `lib/features/me/presentation/me_screen.dart`

**Key Features:**
- 3D Soul Sphere (large gradient circle with glow effects)
- Stats grid: Day Streak, Verses Read, Notes, Prayers
- Progress section with animated bar
- Achievements list (locked/unlocked states)
- Activity calendar heatmap (4 weeks grid)
- Settings icon in top right

**3D Soul Sphere Implementation:**
```dart
Stack(
  alignment: Alignment.center,
  children: [
    // Outer glow
    Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.spiritualGold.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    ),
    // Main sphere
    Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.spiritualGold,
            AppColors.spiritualGoldLight,
            AppColors.spiritualBrown,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      // Add highlight overlay
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.transparent,
              Colors.black.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
  ],
)
```

---

### 6. Search Screen

**Web Component:** `/src/app/components/ProfilePage.tsx`  
**Flutter File:** `lib/features/search/presentation/search_screen.dart`

**Key Features:**
- Glassmorphic search bar with icon
- Recent searches (chips with clock icon)
- Trending topics (gradient cards)
- Popular verses list
- Quick action buttons

---

## 🎭 Typography System

### Font Families
```dart
// Replace Lora with Crimson Text for scripture
const TextTheme scriptureTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Crimson Text',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Crimson Text',
    fontSize: 18,
    height: 1.7,
  ),
);

// Keep Inter for UI elements
const TextTheme uiTheme = TextTheme(
  labelMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  ),
);
```

---

## 🌟 Glassmorphism Standard

### Card Background
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.white.withOpacity(0.05),
        Colors.white.withOpacity(0.02),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withOpacity(0.1),
      width: 1.5,
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: EdgeInsets.all(20),
        child: // your content
      ),
    ),
  ),
)
```

---

## 🔄 Bottom Navigation Design

### Glassmorphic Dock Style
```dart
Container(
  margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
  decoration: BoxDecoration(
    color: AppColors.spiritualDark.withOpacity(0.95),
    borderRadius: BorderRadius.circular(32),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(32),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.spiritualGold.withOpacity(0.05),
              Colors.transparent,
              AppColors.spiritualGold.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.map((item) => NavButton(item)).toList(),
        ),
      ),
    ),
  ),
)

// Active indicator (small dot above icon)
if (isActive)
  Positioned(
    top: -4,
    child: Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.spiritualGoldLight,
      ),
    ),
  )
```

---

## ✨ Animation Guidelines

### Motion Principles (using Flutter's animations)

**Page Transitions:**
```dart
PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 250),
  pageBuilder: (context, animation, secondaryAnimation) => YourPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(0.05, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  },
)
```

**Card Entrance:**
```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 400),
  curve: Curves.easeOut,
  builder: (context, value, child) {
    return Transform.translate(
      offset: Offset(0, 20 * (1 - value)),
      child: Opacity(
        opacity: value,
        child: child,
      ),
    );
  },
  child: YourCard(),
)
```

---

## 🎯 Quick Implementation Checklist

- [ ] Update color constants to warm earthy palette
- [ ] Replace Lora font with Crimson Text for scripture
- [ ] Update glassmorphism blur values to sigma: 15
- [ ] Change cyan accents (#00F2FF) to gold (#C17D4A, #D4A574)
- [ ] Implement new bottom nav glassmorphic dock style
- [ ] Add sub-tabs to Lens screen (READ/DISCOVER)
- [ ] Add sub-tabs to Mentor screen (JOURNAL/DBS)
- [ ] Update Sanctuary header with profile avatar + search icon
- [ ] Implement 3D Soul Sphere in Me screen
- [ ] Add activity calendar heatmap to Me screen

---

## 📦 Asset Requirements

### Fonts to Add
- **Crimson Text** (Regular, Italic, SemiBold) - for scripture
- **Inter** (Regular, Medium, SemiBold) - for UI (already using)

### Icons
- Continue using **Lucide Icons** (web equivalent of your current icon set)
- Match icon sizes: w-5 h-5 (20px) for nav, w-4 h-4 (16px) for inline

---

## 🔗 Data Integration Points

### Vector Memory System (Pinecone)
- Journal entries → Enable in Journal tab (toggle for ai_access_enabled)
- Show "Related" insights in Lens > DISCOVER tab
- Display past reflections when reading verses

### On-Device Intent Classification (Qwen 2.5)
- Use in Search screen for query classification
- Route to appropriate handlers based on intent

---

## 📸 Preview Screenshots Reference

Use the web preview to capture exact:
- Spacing values (px to dp conversion)
- Border radius values
- Shadow blur amounts
- Gradient angle directions
- Card overlap amounts

**Conversion Reference:**
- Web `px` → Flutter `dp` (1:1 ratio on standard displays)
- Web `rounded-3xl` (24px) → Flutter `BorderRadius.circular(24)`
- Web `blur-xl` → Flutter `ImageFilter.blur(sigmaX: 15, sigmaY: 15)`

---

## 🚀 Next Steps

1. **Phase 1:** Update theme colors and typography
2. **Phase 2:** Redesign bottom navigation dock
3. **Phase 3:** Update Sanctuary screen layout
4. **Phase 4:** Add sub-tabs to Lens and Mentor screens
5. **Phase 5:** Implement Me screen with 3D Soul Sphere
6. **Phase 6:** Update Search screen styling
7. **Phase 7:** Test glassmorphism performance and optimize

---

**Note:** This web preview serves as your design reference. The architecture remains identical to your existing Flutter app - we're just applying the new visual aesthetic! 🎨
