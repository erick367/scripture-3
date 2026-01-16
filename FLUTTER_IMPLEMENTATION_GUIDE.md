# Scripture Lens 2.0 - Complete Flutter Implementation Guide

## 📚 Table of Contents

1. [App Architecture Overview](#app-architecture-overview)
2. [Design System](#design-system)
3. [Navigation Architecture](#navigation-architecture)
4. [Page Components Breakdown](#page-components-breakdown)
5. [Reusable Components](#reusable-components)
6. [Animations & Transitions](#animations--transitions)
7. [State Management](#state-management)
8. [Flutter Implementation Examples](#flutter-implementation-examples)

---

## App Architecture Overview

### 🏛️ **4-Tab Architecture**

The app uses a sophisticated 4-tab navigation system with the following pages:

| Tab ID      | Name    | Icon        | Purpose                                          |
| ----------- | ------- | ----------- | ------------------------------------------------ |
| `sanctuary` | Home    | Home Icon   | Dashboard with verse of the day, stats, streaks  |
| `lens`      | Read    | Book Open   | Bible reading interface with advanced typography |
| `plans`     | Plans   | Book Marked | Reading plans with progress tracking             |
| `mentor`    | Journal | Sparkles    | AI-powered journaling and spiritual insights     |

### 📱 **App Structure**

```
App.tsx (Root)
├── TimeOfDay Detection (morning/day/evening/night)
├── Page State Management
├── Profile Overlay
├── Search Overlay
└── DynamicIslandNav (Bottom Navigation)
```

### 🎨 **Theme System**

- **Light Mode**: Active 5am-8pm (morning/day/evening)
- **Dark Mode**: Active 8pm-5am (night)
- **Manual Override**: Force light mode toggle available

---

## Design System

### 🎨 **Color Palette**

#### Primary Colors (Warm Earthy Theme)

```css
/* Light Mode Colors */
--spiritual-gold: #c17d4a /* Primary accent */
  --spiritual-gold-light: #d4a574 /* Secondary accent */
  --spiritual-cream: #faf8f5 /* Background tint */
  --spiritual-brown: #8b7355 /* Secondary brown */
  --spiritual-sage: #a3b18a /* Complementary green */
  --spiritual-dark: #2c2416 /* Dark accent */
  /* Dark Mode Base */ --background-dark: #0a0a0a
  /* Pure dark */ --foreground-dark: #fafaf9
  /* Off-white text */ /* Gradients - Light Mode */
  from-slate-50 via-blue-50 to-indigo-50 /* App background */
  from-orange-400 via-pink-500 to-purple-500 /* Logo gradient */
  from-amber-500 via-orange-500 to-red-600
  /* Reading progress */ from-violet-500 via-purple-500
  to-fuchsia-600 /* Plans */ from-blue-500 via-cyan-500
  to-teal-600 /* Lens */ /* Gradients - Dark Mode */
  from-orange-500/20 via-pink-500/20 to-purple-500/20
  /* Ambient orbs */ from-blue-500/20 via-cyan-500/20
  to-teal-500/20 /* Ambient orbs */;
```

### Flutter Implementation:

```dart
class AppColors {
  // Primary Spiritual Theme
  static const Color spiritualGold = Color(0xFFC17D4A);
  static const Color spiritualGoldLight = Color(0xFFD4A574);
  static const Color spiritualCream = Color(0xFFFAF8F5);
  static const Color spiritualBrown = Color(0xFF8B7355);
  static const Color spiritualSage = Color(0xFFA3B18A);
  static const Color spiritualDark = Color(0xFF2C2416);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color foregroundDark = Color(0xFFFAFAF9);

  // Gradients
  static const LinearGradient appBackgroundLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8FAFC), // slate-50
      Color(0xFFEBF8FF), // blue-50
      Color(0xFFEEF2FF), // indigo-50
    ],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFB923C), // orange-400
      Color(0xFFEC4899), // pink-500
      Color(0xFFA855F7), // purple-500
    ],
  );

  static const LinearGradient streakGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B), // amber-500
      Color(0xFFF97316), // orange-500
      Color(0xFFDC2626), // red-600
    ],
  );
}
```

### 📝 **Typography**

#### Font Families

- **UI Text**: `Inter` (400, 500, 600, 700, 800, 900 weights)
- **Scripture**: `Crimson Text` (400, 400i, 600, 600i, 700)

#### Font Sizes

```css
--text-xs: 0.75rem (12px) --text-sm: 0.875rem (14px)
  --text-base: 1rem (16px) --text-lg: 1.125rem (18px)
  --text-xl: 1.25rem (20px) --text-2xl: 1.5rem (24px)
  --text-3xl: 1.875rem (30px) --text-[120px]: Giant numbers for
  streaks;
```

### Flutter Implementation:

```dart
class AppTextStyles {
  // Font Families
  static const String uiFont = 'Inter';
  static const String scriptureFont = 'Crimson Text';

  // UI Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: uiFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: uiFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: uiFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: uiFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Scripture Styles
  static const TextStyle scripture = TextStyle(
    fontFamily: scriptureFont,
    fontSize: 26,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle scriptureItalic = TextStyle(
    fontFamily: scriptureFont,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.6,
  );

  // Giant streak numbers
  static const TextStyle streakNumber = TextStyle(
    fontFamily: uiFont,
    fontSize: 120,
    fontWeight: FontWeight.w900,
    height: 1.0,
  );
}
```

### 🎭 **Glassmorphism Effects**

All cards use:

- **Backdrop Blur**: `backdrop-filter: blur(24px)`
- **Opacity Layers**: 5-10% white overlays
- **Border**: 1px with 10-20% opacity
- **Shadow**: Multi-layer shadows for depth

### Flutter Implementation:

```dart
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.10),
                    ]
                  : [
                      Colors.white,
                      Color(0xFFEBF8FF).withOpacity(0.3),
                      Color(0xFFF3E8FF).withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### 🔘 **Border Radius System**

- **Extra Large Cards**: `40px` (Main content cards)
- **Large Cards**: `36px` (Activity stats)
- **Medium Cards**: `24px` (Buttons, badges)
- **Small Cards**: `16-18px` (Icons, mini buttons)
- **Pills**: `9999px` (Full rounded)

### Flutter Implementation:

```dart
class AppRadius {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 36.0;
  static const double xl = 40.0;
  static const double pill = 9999.0;
}
```

---

## Navigation Architecture

### 🧭 **Dynamic Island Navigation**

#### Component: `DynamicIslandNav.tsx`

**Visual Behavior:**

- **Collapsed State**: Single circular button (80x56px) showing current page icon
- **Expanded State**: Horizontal pill (320x64px) showing all 4 navigation icons
- **Position**: Fixed bottom, centered, 32px from bottom
- **Interaction**: Tap to expand, tap outside to collapse

#### States:

**Collapsed (Default):**

```
┌─────────────┐
│   [Icon]    │  Single icon with gradient background
└─────────────┘
```

**Expanded:**

```
┌──────────────────────────────────────────────┐
│  [Home] [Read] [Plans] [Journal]            │
└──────────────────────────────────────────────┘
```

#### Visual Details:

- **Active Tab**: Full gradient circle background with white icon
- **Inactive Tabs**: Semi-transparent icon only
- **Hover State**: Scale 1.15, lift -4px, show label tooltip
- **Tap Animation**: Scale 0.9
- **Transition**: Spring animation (stiffness: 300, damping: 30)

### Flutter Implementation:

```dart
class DynamicIslandNav extends StatefulWidget {
  final String currentPage;
  final Function(String) onPageChange;
  final bool isDark;

  @override
  _DynamicIslandNavState createState() => _DynamicIslandNavState();
}

class _DynamicIslandNavState extends State<DynamicIslandNav>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: 80.0,
      end: 320.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _heightAnimation = Tween<double>(
      begin: 56.0,
      end: 64.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return GestureDetector(
              onTap: !isExpanded ? toggleExpanded : null,
              child: Container(
                width: _widthAnimation.value,
                height: _heightAnimation.value,
                decoration: BoxDecoration(
                  color: isExpanded
                      ? (widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.2))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: isExpanded
                      ? Border.all(
                          color: widget.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.3),
                        )
                      : null,
                  boxShadow: isExpanded
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 40,
                            offset: Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: isExpanded
                    ? _buildExpandedNav()
                    : _buildCollapsedNav(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsedNav() {
    final navItems = _getNavItems();
    final currentItem = navItems.firstWhere(
      (item) => item['id'] == widget.currentPage,
      orElse: () => navItems[0],
    );

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: currentItem['gradient'] as LinearGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        currentItem['icon'] as IconData,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildExpandedNav() {
    final navItems = _getNavItems();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: navItems.map((item) {
        final isActive = item['id'] == widget.currentPage;

        return GestureDetector(
          onTap: () {
            widget.onPageChange(item['id'] as String);
            Future.delayed(Duration(milliseconds: 300), () {
              toggleExpanded();
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: isActive ? item['gradient'] as LinearGradient : null,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item['icon'] as IconData,
              color: isActive
                  ? Colors.white
                  : (widget.isDark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.grey[600]),
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getNavItems() {
    return [
      {
        'id': 'sanctuary',
        'icon': Icons.home,
        'label': 'Home',
        'gradient': LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEC4899)],
        ),
      },
      {
        'id': 'lens',
        'icon': Icons.menu_book,
        'label': 'Read',
        'gradient': LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
        ),
      },
      {
        'id': 'plans',
        'icon': Icons.bookmark,
        'label': 'Plans',
        'gradient': LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
        ),
      },
      {
        'id': 'mentor',
        'icon': Icons.auto_awesome,
        'label': 'Journal',
        'gradient': LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
      },
    ];
  }
}
```

---

## Page Components Breakdown

### 🏠 **HOME PAGE (Sanctuary)**

**File**: `HomePage.tsx` (1,052 lines)

#### Layout Structure:

```
┌──────────────────────────────────┐
│  Header (Dynamic Island Pill)   │
│  - Logo + Greeting              │
│  - Notifications + Search       │
├──────────────────────────────────┤
│  Spiritual Carousel (Stacked)   │
│  - Verse of the Day (Front)     │
│  - Prayer of the Day (Back)     │
├──────────────────────────────────┤
│  Streak Card (Giant Number)     │
│  - 47 days                       │
│  - Progress bar to 100           │
├──────────────────────────────────┤
│  Today's Activity (3 Circles)   │
│  - Chapters Read                 │
│  - Minutes Spent                 │
│  - Goals Achieved                │
├──────────────────────────────────┤
│  Continue Reading (3 Cards)     │
│  - Psalms 23                     │
│  - Proverbs 31                   │
│  - John 15                       │
├──────────────────────────────────┤
│  Achievements Grid               │
│  - Milestone badges              │
└──────────────────────────────────┘
```

#### Components Breakdown:

##### 1. **Dynamic Island Header**

```typescript
Properties:
- Width: full, rounded-full
- Padding: 24px horizontal, 16px vertical
- Background: Glassmorphic white/10 (dark) or white (light)
- Border: 1px white/20 or gray/20
- Shadow: xl

Elements:
- Left Side:
  - Animated logo (11x11, rounded-16px, gradient shimmer)
  - Greeting text (Good Morning/Afternoon/Evening/Night)
  - User name (Erick)

- Right Side:
  - Notification bell (badge with count "3", pulsing)
  - Search icon button
  - Profile avatar (gradient, online dot indicator)
```

**Flutter Implementation:**

```dart
class DynamicIslandHeader extends StatelessWidget {
  final String greeting;
  final VoidCallback onProfileClick;
  final VoidCallback onSearchClick;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Logo
          _buildAnimatedLogo(),

          SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[500],
                  ),
                ),
                Text(
                  'Erick',
                  style: AppTextStyles.heading2.copyWith(
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),

          // Notification Button with Badge
          _buildNotificationButton(),

          SizedBox(width: 8),

          // Search Button
          _buildIconButton(Icons.search, onSearchClick),

          SizedBox(width: 8),

          // Profile Button
          _buildProfileButton(onProfileClick),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 3),
      builder: (context, double value, child) {
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.logoGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Shimmer effect
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 3),
                    transform: Matrix4.translationValues(
                      (value * 300) - 100,
                      0,
                      0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

##### 2. **Spiritual Carousel** (Stacked Cards)

```typescript
Component: SpiritualCarousel.tsx

State:
- carouselIndex: 0 (Verse) or 1 (Prayer)

Visual Design:
- Height: 520px container
- Cards: 480px height each
- Back card: Positioned 12px down, scale 0.96, opacity 0.6
- Front card: Full size, scale 1.0, opacity 1.0
- Interaction: Tap entire card to flip

Card 1 (Verse of the Day):
├─ Header: Icon (Sparkles) + "Verse of the Day" + Category
├─ Scripture Text: 26px Crimson Text, line-height 1.6
├─ Reference Badge: Orange gradient pill
└─ Read More Button: Animated arrow

Card 2 (Prayer of the Day):
├─ Header: Icon (Heart) + "Prayer of the Day" + Theme
├─ Prayer Title: 24px bold
└─ Prayer Text: 24px Crimson Text italic

Indicators:
- 2 dots below cards
- Active: 32px wide, full opacity
- Inactive: 8px wide, 30% opacity
- Button below: "Tap for prayer" / "Tap for verse"
```

**Flutter Implementation:**

```dart
class SpiritualCarousel extends StatefulWidget {
  final bool isDark;
  final VerseOfDay verseOfTheDay;
  final PrayerOfDay prayerOfTheDay;

  @override
  _SpiritualCarouselState createState() => _SpiritualCarouselState();
}

class _SpiritualCarouselState extends State<SpiritualCarousel> {
  int carouselIndex = 0;

  void switchCard() {
    setState(() {
      carouselIndex = carouselIndex == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stacked Cards Container
        Container(
          height: 520,
          child: Stack(
            children: [
              // Prayer Card (Back)
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                top: carouselIndex == 1 ? 0 : 12,
                left: 0,
                right: 0,
                child: AnimatedScale(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  scale: carouselIndex == 1 ? 1.0 : 0.96,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: carouselIndex == 1 ? 1.0 : 0.6,
                    child: GestureDetector(
                      onTap: carouselIndex == 1 ? switchCard : null,
                      child: _buildPrayerCard(),
                    ),
                  ),
                ),
              ),

              // Verse Card (Front)
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                top: carouselIndex == 0 ? 0 : 12,
                left: 0,
                right: 0,
                child: AnimatedScale(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  scale: carouselIndex == 0 ? 1.0 : 0.95,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: carouselIndex == 0 ? 1.0 : 0.6,
                    child: GestureDetector(
                      onTap: carouselIndex == 0 ? switchCard : null,
                      child: _buildVerseCard(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Card Indicators
        _buildIndicators(),

        SizedBox(height: 16),

        // Switch Button
        _buildSwitchButton(),
      ],
    );
  }

  Widget _buildVerseCard() {
    return Container(
      height: 480,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: widget.isDark
            ? LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.05),
                ],
              )
            : LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFEBF8FF).withOpacity(0.5),
                ],
              ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFB923C), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verse of the Day',
                    style: AppTextStyles.heading2.copyWith(
                      color: widget.isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    widget.verseOfTheDay.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Scripture Text
          Text(
            '"${widget.verseOfTheDay.verse}"',
            style: AppTextStyles.scripture.copyWith(
              color: widget.isDark ? Colors.white : Colors.grey[900],
            ),
          ),

          Spacer(),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reference Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: widget.isDark
                      ? LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Color(0xFFFEF3C7), // orange-50
                            Color(0xFFFCE7F3), // pink-50
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.2)
                        : Color(0xFFFED7AA), // orange-200
                  ),
                ),
                child: Text(
                  widget.verseOfTheDay.reference,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.isDark
                        ? Color(0xFFFDBA74) // orange-300
                        : Color(0xFFEA580C), // orange-600
                  ),
                ),
              ),

              // Read More Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Read More',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: widget.isDark ? Colors.white : Colors.grey[900],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [0, 1].map((index) {
        final isActive = carouselIndex == index;
        return GestureDetector(
          onTap: () => setState(() => carouselIndex = index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isActive ? 32 : 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withOpacity(isActive ? 1.0 : 0.3)
                  : Colors.grey[900]!.withOpacity(isActive ? 1.0 : 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
```

##### 3. **Streak Card** (Giant Number Display)

```typescript
Design:
- Height: ~300px
- Background: Deep brown gradient
  - Light: from-[#8B5A3C] via-[#7A4E33] to-[#6B432A]
  - Dark: from-[#5C2E1F] via-[#4A2418] to-[#3D1F14]
- Border: orange-900/40
- Border Radius: 40px
- Padding: 32px

Content:
├─ Label: "DAY STREAK" (uppercase, tracking-widest, orange-200/80)
├─ Subtitle: "Keep the momentum going!" (white/50)
├─ Giant Number: "47"
│  - Font Size: 120px
│  - Font Weight: 900
│  - Gradient: from-orange-200 via-red-300 to-pink-400
│  - Text fill: gradient clip
├─ Unit: "days" (text-3xl, white/40)
├─ Inspirational Quote: Crimson Text italic, text-xl, white/80
│  "Every day you spend in His Word builds a foundation that cannot be shaken."
├─ Days Remaining: "53 more days to reach your 100-day goal 🎯"
└─ Progress Bar: Animated from 0% to 47%
   - Background: black/30
   - Fill: from-orange-500 via-red-500 to-pink-600
   - Shimmer effect sliding across
```

**Flutter Implementation:**

```dart
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int goalStreak;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final percentage = (currentStreak / goalStreak * 100).toInt();
    final remaining = goalStreak - currentStreak;

    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color(0xFF5C2E1F),
                  Color(0xFF4A2418),
                  Color(0xFF3D1F14),
                ]
              : [
                  Color(0xFF8B5A3C),
                  Color(0xFF7A4E33),
                  Color(0xFF6B432A),
                ],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Color(0xFF7C2D12).withOpacity(0.4), // orange-900
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'DAY STREAK',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFFED7AA).withOpacity(0.8), // orange-200
            ),
          ),

          SizedBox(height: 4),

          Text(
            'Keep the momentum going!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),

          SizedBox(height: 24),

          // Giant Number
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFFFED7AA), // orange-200
                    Color(0xFFFCA5A5), // red-300
                    Color(0xFFF9A8D4), // pink-400
                  ],
                ).createShader(bounds),
                child: Text(
                  '$currentStreak',
                  style: TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    color: Colors.white, // This gets masked by gradient
                  ),
                ),
              ),

              SizedBox(width: 12),

              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'days',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Inspirational Quote
          Text(
            '"Every day you spend in His Word builds a foundation that cannot be shaken."',
            style: TextStyle(
              fontFamily: 'Crimson Text',
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),

          SizedBox(height: 16),

          // Days Remaining
          Text(
            '$remaining more days to reach your $goalStreak-day goal 🎯',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.6),
            ),
          ),

          SizedBox(height: 16),

          // Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: percentage / 100),
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF97316), // orange-500
                          Color(0xFFEF4444), // red-500
                          Color(0xFFEC4899), // pink-600
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

##### 4. **Today's Activity** (Circular Progress Indicators)

```typescript
Design:
- 3 circular progress rings (Chapters, Minutes, Goals)
- Each ring: 96px diameter (24 * 4)
- Ring thickness: 6px
- Animated from 0% to target %
- Icon + Number in center
- Label + "X to goal" below

Chapters Circle:
- Gradient: from-blue-500 to-cyan-600
- Icon: BookOpen
- Progress: 2/5 (40%)

Minutes Circle:
- Gradient: from-purple-500 to-pink-600
- Icon: Clock
- Progress: 23/30 (77%)

Goals Circle:
- Gradient: from-green-500 to-emerald-600
- Icon: Target
- Progress: 12/15 (80%)

Floating Sparkles:
- 3 small dots per circle
- Animate up and fade out
- Staggered delay
```

**Flutter Implementation:**

```dart
class CircularProgress extends StatelessWidget {
  final IconData icon;
  final int current;
  final int target;
  final List<Color> gradientColors;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final percentage = current / target;

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          child: Stack(
            children: [
              // Background Circle
              CustomPaint(
                size: Size(96, 96),
                painter: CirclePainter(
                  progress: 1.0,
                  colors: [
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                  ],
                  strokeWidth: 6,
                ),
              ),

              // Animated Progress Circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: percentage),
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return CustomPaint(
                    size: Size(96, 96),
                    painter: CirclePainter(
                      progress: value,
                      colors: gradientColors,
                      strokeWidth: 6,
                    ),
                  );
                },
              ),

              // Center Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: gradientColors[0],
                      size: 20,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$current',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[900],
          ),
        ),

        SizedBox(height: 4),

        Text(
          '${target - current} to goal',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Circular Progress
class CirclePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  CirclePainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress, // Progress angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

##### 5. **Continue Reading Cards** (Horizontal Scroll)

```typescript
Design:
- 3 cards in horizontal scrollable row
- Each card: ~300px width, 180px height
- Glassmorphic with gradient accents
- Hover effect: lift -8px, scale 1.03

Card Structure:
├─ Gradient Accent Bar (left border, 4px)
├─ Book Name: Bold, large
├─ Chapter: "Chapter X"
├─ Progress Ring: Small circular (40px)
├─ Next Verse: "Continue from Verse Y"
└─ Arrow Button

Gradients:
- Psalms: from-amber-500 via-orange-500 to-red-600
- Proverbs: from-violet-500 via-purple-500 to-fuchsia-600
- John: from-blue-500 via-cyan-500 to-teal-600
```

**Flutter Implementation:**

```dart
class ContinueReadingCard extends StatelessWidget {
  final String book;
  final String chapter;
  final int progress;
  final List<Color> gradientColors;
  final String nextVerse;
  final int totalVerses;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 180,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient Accent Bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  bottomLeft: Radius.circular(28),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Book info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.grey[900],
                          ),
                        ),
                        Text(
                          'Chapter $chapter',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white.withOpacity(0.6)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Progress Ring
                    Container(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(40, 40),
                            painter: CirclePainter(
                              progress: progress / 100,
                              colors: gradientColors,
                              strokeWidth: 3,
                            ),
                          ),
                          Center(
                            child: Text(
                              '$progress%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: gradientColors[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Spacer(),

                // Next verse info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nextVerse,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.grey[500],
                      ),
                    ),

                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 📖 **READ PAGE (Lens)**

**File**: `ReadPage.tsx` (1,026 lines)

#### Layout Structure:

```
┌──────────────────────────────────┐
│  Floating Header (Transparent)   │
│  - Book Selector                 │
│  - Chapter Navigation            │
│  - Settings Menu                 │
├──────────────────────────────────┤
│                                  │
│  Verse 1 (Card)                  │
│  Verse 2 (Card)                  │
│  Verse 3 (Card)                  │
│  ...                             │
│  Verse N (Card)                  │
│                                  │
│  [Verses fade in as scrolled]    │
│                                  │
├──────────────────────────────────┤
│  Chapter Complete Card           │
│  - Celebration animation         │
│  - Next Chapter button           │
└──────────────────────────────────┘
```

#### Key Features:

##### 1. **Floating Header**

```typescript
Design:
- Position: Fixed top, glassmorphic
- Background: Backdrop blur 24px
- Opacity: Fades in/out on scroll
- Height: 72px

Left Section:
- Back button (arrow)
- Book name (Genesis, Exodus, etc.)

Center Section:
- Chapter selector dropdown
- Previous/Next chapter arrows

Right Section:
- Font size adjuster (A- / A+)
- Reading mode toggle (Day/Night)
- More options menu (...)
```

**Flutter Implementation:**

```dart
class ReadPageHeader extends StatelessWidget {
  final String currentBook;
  final int currentChapter;
  final VoidCallback onBack;
  final VoidCallback onPreviousChapter;
  final VoidCallback onNextChapter;
  final VoidCallback onFontSizeDecrease;
  final VoidCallback onFontSizeIncrease;
  final VoidCallback onToggleMode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Row(
          children: [
            // Back Button
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBack,
              color: isDark ? Colors.white : Colors.grey[900],
            ),

            SizedBox(width: 12),

            // Book Name
            Text(
              currentBook,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),

            Spacer(),

            // Chapter Navigation
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: onPreviousChapter,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600],
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Chapter $currentChapter',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
            ),

            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: onNextChapter,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600],
            ),

            Spacer(),

            // Font Size Controls
            IconButton(
              icon: Icon(Icons.text_decrease),
              onPressed: onFontSizeDecrease,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600],
            ),

            IconButton(
              icon: Icon(Icons.text_increase),
              onPressed: onFontSizeIncrease,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600],
            ),

            // Mode Toggle
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: onToggleMode,
              color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
```

##### 2. **Verse Cards**

```typescript
Design:
- Each verse is a card
- Default state: opacity 0.6, translateY(10px), scale(0.98)
- In-view state: opacity 1.0, translateY(0), scale(1.0)
- Transition: Smooth ease-out, 400ms

Visual:
- Padding: 32px
- Border Radius: 24px
- Background: Glassmorphic white/5 (dark) or white (light)
- Font: Crimson Text, 22-26px (adjustable)
- Line Height: 1.8
- Verse Number: Small superscript, gradient color

Interaction:
- Tap verse: Show context menu (Copy, Highlight, Note, Share)
- Long press: Enter highlight mode
- Double tap: Quick bookmark
```

**Flutter Implementation:**

```dart
class VerseCard extends StatefulWidget {
  final int verseNumber;
  final String verseText;
  final bool isDark;
  final double fontSize;

  @override
  _VerseCardState createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Trigger animation when verse comes into view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: _buildVerseContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerseContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: widget.isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          children: [
            // Verse Number
            TextSpan(
              text: '${widget.verseNumber} ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: widget.fontSize * 0.6,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [
                      Color(0xFFC17D4A),
                      Color(0xFFD4A574),
                    ],
                  ).createShader(Rect.fromLTWH(0, 0, 50, 20)),
              ),
            ),

            // Verse Text
            TextSpan(
              text: widget.verseText,
              style: TextStyle(
                fontFamily: 'Crimson Text',
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w400,
                height: 1.8,
                color: widget.isDark ? Colors.white : Color(0xFF1C1917),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

##### 3. **Chapter Complete Card**

```typescript
Design:
- Appears after last verse
- Animated confetti/celebration effect
- Glassmorphic with gradient accent

Content:
├─ Celebration Icon (Party Popper emoji or animation)
├─ "Chapter Complete!" heading
├─ Chapter stats:
│  - Verses read: X
│  - Time spent: Y minutes
│  - Streak maintained: Z days
├─ "What did you learn?" quick note input
└─ Action Buttons:
   - Next Chapter (Primary gradient button)
   - Back to Plans (Secondary)
   - Journal Reflection (Tertiary)
```

**Flutter Implementation:**

```dart
class ChapterCompleteCard extends StatefulWidget {
  final int versesRead;
  final int minutesSpent;
  final int currentStreak;
  final VoidCallback onNextChapter;
  final VoidCallback onBackToPlans;
  final VoidCallback onJournalReflection;
  final bool isDark;

  @override
  _ChapterCompleteCardState createState() => _ChapterCompleteCardState();
}

class _ChapterCompleteCardState extends State<ChapterCompleteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDark
                      ? [
                          Colors.purple.shade900.withOpacity(0.6),
                          Colors.blue.shade900.withOpacity(0.6),
                        ]
                      : [
                          Color(0xFFF3E8FF),
                          Color(0xFFEBF8FF),
                        ],
                ),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.purple.shade200,
                ),
              ),
              child: Column(
                children: [
                  // Celebration Icon
                  Text(
                    '🎉',
                    style: TextStyle(fontSize: 80),
                  ),

                  SizedBox(height: 24),

                  // Heading
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFFA855F7),
                        Color(0xFF06B6D4),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Chapter Complete!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        Icons.menu_book,
                        '${widget.versesRead}',
                        'Verses',
                      ),
                      _buildStat(
                        Icons.access_time,
                        '${widget.minutesSpent}',
                        'Minutes',
                      ),
                      _buildStat(
                        Icons.local_fire_department,
                        '${widget.currentStreak}',
                        'Day Streak',
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Quick Note Input
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'What did you learn? (Optional)',
                      filled: true,
                      fillColor: widget.isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),

                  SizedBox(height: 32),

                  // Action Buttons
                  ElevatedButton(
                    onPressed: widget.onNextChapter,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF06B6D4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        child: Text(
                          'Next Chapter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: widget.onBackToPlans,
                        child: Text('Back to Plans'),
                      ),
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: widget.onJournalReflection,
                        child: Text('Journal Reflection'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Color(0xFFA855F7),
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: widget.isDark
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
```

---

### 📅 **PLANS PAGE**

**File**: `PlansPage.tsx` (2,439 lines)

#### Layout Structure:

```
┌──────────────────────────────────┐
│  Header with Search              │
├──────────────────────────────────┤
│  Featured Plans (Horizontal)     │
│  - 3-5 hero cards with images    │
├──────────────────────────────────┤
│  My Active Plans                 │
│  - In-progress plan cards        │
│  - Progress circles              │
├──────────────────────────────────┤
│  Recommended Plans Grid          │
│  - Category filters              │
│  - Plan cards with tags          │
├──────────────────────────────────┤
│  Create Custom Plan Button       │
└──────────────────────────────────┘
```

#### Key Features:

##### 1. **Plan Card**

```typescript
Design:
- Glassmorphic card
- Gradient accent (left border 4px)
- Plan thumbnail/icon
- Progress ring (if active)
- Duration badge
- Difficulty badge
- Category tags

Content Structure:
├─ Plan thumbnail (gradient background)
├─ Plan title (bold, 20px)
├─ Plan subtitle (description, 14px, 2 lines)
├─ Progress (if active):
│  - Circular progress ring
│  - "Day X of Y"
│  - Continue button
├─ Plan Details:
│  - Duration: "21 Days"
│  - Difficulty: "Beginner/Intermediate/Advanced"
│  - Readings: "X chapters, Y verses"
└─ Action Button: "Start Plan" or "Continue"

Gradients by Category:
- Faith Foundations: from-amber-500 to-orange-600
- Prayer & Worship: from-purple-500 to-pink-600
- Biblical Characters: from-blue-500 to-cyan-600
- Life & Purpose: from-green-500 to-emerald-600
```

**Flutter Implementation:**

```dart
class PlanCard extends StatelessWidget {
  final String planTitle;
  final String planSubtitle;
  final String duration;
  final String difficulty;
  final List<String> tags;
  final int? currentDay;
  final int? totalDays;
  final List<Color> gradientColors;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = currentDay != null && totalDays != null;
    final progress = isActive ? (currentDay! / totalDays!) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Gradient accent bar
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(width: 16),

                // Plan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        planSubtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Progress ring (if active)
                if (isActive)
                  Container(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(60, 60),
                          painter: CirclePainter(
                            progress: progress,
                            colors: gradientColors,
                            strokeWidth: 4,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: gradientColors[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16),

            // Progress text (if active)
            if (isActive)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Day $currentDay of $totalDays',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

            SizedBox(height: 16),

            // Badges row
            Row(
              children: [
                _buildBadge(duration, Icons.calendar_today),
                SizedBox(width: 8),
                _buildBadge(difficulty, Icons.signal_cellular_alt),
              ],
            ),

            SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => _buildTag(tag)).toList(),
            ),

            SizedBox(height: 16),

            // Action button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isActive ? 'Continue Reading' : 'Start Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? Colors.white.withOpacity(0.6)
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[300]!,
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 10,
          color: isDark
              ? Colors.white.withOpacity(0.6)
              : Colors.grey[600],
        ),
      ),
    );
  }
}
```

---

### 📝 **JOURNAL PAGE (Mentor)**

**File**: `MentorPage.tsx` (2,412 lines)

#### Layout Structure:

```
┌──────────────────────────────────┐
│  Welcome Header                  │
│  - Personalized greeting         │
│  - Spiritual growth score        │
├──────────────────────────────────┤
│  Quick Reflection Card           │
│  - "How are you feeling today?"  │
│  - Mood selector (5 emojis)      │
│  - Quick note input              │
├──────────────────────────────────┤
│  AI Spiritual Insights           │
│  - Based on reading patterns     │
│  - Personalized recommendations  │
├──────────────────────────────────┤
│  Recent Journal Entries          │
│  - Timeline view                 │
│  - Search & filter               │
├──────────────────────────────────┤
│  Spiritual Growth Chart          │
│  - Weekly activity visualization │
│  - Streak calendar               │
└──────────────────────────────────┘
```

#### Key Components:

##### 1. **Mood Selector**

```typescript
Design:
- 5 emoji buttons in row
- Selected emoji: scale 1.2, bounce animation
- Gradient background when selected

Moods:
😞 Struggling | 😐 Neutral | 🙂 Good | 😊 Blessed | 🤩 Overflowing

Colors:
- Struggling: Red gradient
- Neutral: Gray
- Good: Blue gradient
- Blessed: Purple gradient
- Overflowing: Gold gradient
```

**Flutter Implementation:**

```dart
class MoodSelector extends StatefulWidget {
  final Function(int) onMoodSelected;
  final bool isDark;

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int? selectedMood;

  final moods = [
    {'emoji': '😞', 'label': 'Struggling', 'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)]},
    {'emoji': '😐', 'label': 'Neutral', 'gradient': [Color(0xFF9CA3AF), Color(0xFF6B7280)]},
    {'emoji': '🙂', 'label': 'Good', 'gradient': [Color(0xFF3B82F6), Color(0xFF2563EB)]},
    {'emoji': '😊', 'label': 'Blessed', 'gradient': [Color(0xFFA855F7), Color(0xFF9333EA)]},
    {'emoji': '🤩', 'label': 'Overflowing', 'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)]},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.grey[900],
          ),
        ),

        SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(moods.length, (index) {
            final mood = moods[index];
            final isSelected = selectedMood == index;

            return GestureDetector(
              onTap: () {
                setState(() => selectedMood = index);
                widget.onMoodSelected(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.2 : 1.0),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: mood['gradient'] as List<Color>,
                              )
                            : null,
                        color: !isSelected
                            ? (widget.isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[100])
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          mood['emoji'] as String,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      mood['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: widget.isDark
                            ? Colors.white.withOpacity(isSelected ? 1.0 : 0.6)
                            : Colors.grey[isSelected ? 900 : 600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
```

##### 2. **Journal Entry Card**

```typescript
Design:
- Timeline layout with date marker
- Entry card with preview
- Tags and mood indicator
- Linked scripture references

Content:
├─ Date (sticky left sidebar)
├─ Entry Preview Card:
│  ├─ Mood emoji
│  ├─ Entry title (if provided)
│  ├─ Entry preview (first 3 lines)
│  ├─ Linked scriptures (badges)
│  ├─ Tags
│  └─ Edit/Share/Delete actions
└─ Expand button
```

---

## Animations & Transitions

### 🎬 **Core Animations**

#### 1. **Page Transitions**

```dart
class PageTransitionAnimation {
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.02);
        var end = Offset.zero;
        var curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        var opacityTween = Tween<double>(begin: 0.0, end: 1.0);
        var opacityAnimation = animation.drive(opacityTween);

        var scaleTween = Tween<double>(begin: 0.98, end: 1.0);
        var scaleAnimation = animation.drive(scaleTween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
```

#### 2. **Shimmer Effect**

```dart
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
```

#### 3. **Floating Animation** (For ambient orbs)

```dart
class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double distance;

  @override
  _FloatingAnimationState createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, widget.distance),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
```

#### 4. **Pulse Animation** (For notification badges)

```dart
class PulseAnimation extends StatefulWidget {
  final Widget child;

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
```

---

## State Management

### 📦 **Recommended: Riverpod**

```dart
// lib/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Time of Day Provider
final timeOfDayProvider = StateProvider<TimeOfDay>((ref) {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return TimeOfDay.morning;
  if (hour >= 12 && hour < 17) return TimeOfDay.day;
  if (hour >= 17 && hour < 20) return TimeOfDay.evening;
  return TimeOfDay.night;
});

enum TimeOfDay { morning, day, evening, night }

// Current Page Provider
final currentPageProvider = StateProvider<String>((ref) => 'sanctuary');

// Reading Context Provider
final readingContextProvider = StateProvider<ReadingContext?>((ref) => null);

class ReadingContext {
  final String book;
  final String chapter;
  final String? planTitle;

  ReadingContext({
    required this.book,
    required this.chapter,
    this.planTitle,
  });
}

// Dark Mode Provider
final isDarkModeProvider = Provider<bool>((ref) {
  final timeOfDay = ref.watch(timeOfDayProvider);
  return timeOfDay == TimeOfDay.night || timeOfDay == TimeOfDay.evening;
});

// Streak Data Provider
final streakDataProvider = StateProvider<StreakData>((ref) {
  return StreakData(current: 47, goal: 100);
});

class StreakData {
  final int current;
  final int goal;

  StreakData({required this.current, required this.goal});

  int get percentage => (current / goal * 100).toInt();
  int get remaining => goal - current;
}

// Today's Stats Provider
final todayStatsProvider = StateProvider<TodayStats>((ref) {
  return TodayStats(
    versesRead: 12,
    minutesSpent: 23,
    chaptersCompleted: 2,
  );
});

class TodayStats {
  final int versesRead;
  final int minutesSpent;
  final int chaptersCompleted;

  TodayStats({
    required this.versesRead,
    required this.minutesSpent,
    required this.chaptersCompleted,
  });
}
```

---

## Complete Flutter App Structure

```
lib/
├── main.dart
├── providers/
│   ├── app_providers.dart
│   ├── reading_providers.dart
│   ├── plans_providers.dart
│   └── journal_providers.dart
├── models/
│   ├── verse.dart
│   ├── plan.dart
│   ├── journal_entry.dart
│   └── user_progress.dart
├── screens/
│   ├── home_page.dart
│   ├── read_page.dart
│   ├── plans_page.dart
│   └── journal_page.dart
├── widgets/
│   ├── navigation/
│   │   ├── dynamic_island_nav.dart
│   │   └── floating_header.dart
│   ├── cards/
│   │   ├── spiritual_carousel.dart
│   │   ├── streak_card.dart
│   │   ├── verse_card.dart
│   │   ├── plan_card.dart
│   │   └── journal_entry_card.dart
│   ├── progress/
│   │   ├── circular_progress.dart
│   │   └── progress_bar.dart
│   └── common/
│       ├── glassmorphic_card.dart
│       ├── gradient_button.dart
│       └── animated_badge.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_theme.dart
└── utils/
    ├── animations.dart
    └── constants.dart
```

---

## Summary

This Flutter implementation guide covers:

✅ **Complete Design System**: All colors, fonts, spacing, and visual effects
✅ **All 4 Main Pages**: Home (Sanctuary), Read (Lens), Plans, Journal (Mentor)
✅ **Navigation**: Dynamic Island bottom navigation with animations
✅ **Reusable Widgets**: Cards, progress indicators, buttons
✅ **Animations**: Page transitions, shimmer, floating, pulse effects
✅ **State Management**: Riverpod providers for app state
✅ **Glassmorphism**: Backdrop blur and layered transparency effects

Each component has been broken down with:

- Visual specifications (sizes, colors, spacing)
- Animation details (duration, curves, easing)
- Flutter code implementation examples
- State management integration

The warm earthy theme with premium glassmorphic effects creates a unique spiritual reading experience optimized for both light and dark modes. 🙏✨