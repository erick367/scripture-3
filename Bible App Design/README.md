# 📖 Scripture Lens 2.0

> A revolutionary Bible reading app with warm earthy aesthetic, glassmorphic design, and Apple/Tesla-level polish

## 🎨 Design Philosophy

**Premium Playfulness** - The perfect balance between Calm app and Duolingo, Apple Music and Notion. Professional yet playful, peaceful yet powerful.

### Key Features

✨ **4-Tab Architecture**
- 🏛️ **Sanctuary** - Home dashboard with dynamic verse of the day
- 📖 **Lens** - Immersive reading experience with multiple themes
- 📚 **Plans** - Visual reading plans with progress tracking
- ✍️ **Mentor** - Journal entries with AI-powered insights

🎨 **Premium Design Elements**
- Time-adaptive ambient backgrounds (changes throughout the day)
- Glassmorphic cards with backdrop blur effects
- Animated gradient orbs and particles
- 3D tilt effects on hero cards
- Magnetic bubble navigation

📚 **Revolutionary Reading Experience**
- 4 reading themes: Light, Sepia, Dark, OLED
- 3 reading modes: Comfortable, Immersive, Study
- Interactive verse highlighting and actions
- Adjustable font sizing (14px-28px)
- Crimson Text serif font for scripture

## 🚀 Technology Stack

- **Framework:** React 18.3.1 + TypeScript
- **Styling:** Tailwind CSS v4
- **Animations:** Motion/React (Framer Motion)
- **Icons:** Lucide React
- **Build Tool:** Vite
- **Font System:** Google Fonts (Crimson Text + Inter)

## 📦 Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## 🎯 Project Structure

```
scripture-lens-2/
├── src/
│   ├── app/
│   │   ├── App.tsx                 # Main application component
│   │   └── components/
│   │       ├── HomePage.tsx        # Sanctuary (Home)
│   │       ├── ReadPage.tsx        # Lens (Reading)
│   │       ├── PlansPage.tsx       # Reading plans
│   │       ├── MentorPage.tsx      # Journal/AI Mentor
│   │       ├── DynamicIslandNav.tsx # Navigation bar
│   │       ├── MeScreen.tsx        # Profile
│   │       ├── ProfilePage.tsx     # Search overlay
│   │       └── ui/                 # shadcn/ui components
│   └── styles/
│       ├── fonts.css               # Font imports
│       ├── theme.css               # Design tokens
│       ├── tailwind.css            # Tailwind config
│       └── index.css               # Main styles
├── ARCHITECTURE_MAPPING.md         # Flutter migration guide
├── DESIGN_SHOWCASE.md             # Feature documentation
├── PREMIUM_DESIGN_SYSTEM.md       # Design specifications
├── WOW_FACTOR.md                  # Unique features guide
└── package.json
```

## 🎨 Design System

### Color Palette (Warm Earthy)

- **Primary Gold:** #C17D4A
- **Secondary Brown:** #8B7355  
- **Accent Sage:** #A3B18A
- **Dark Base:** #2C2416
- **Cream:** #FAF8F5

### Typography

- **Scripture:** Crimson Text (Serif) - 18px base, 1.8 line-height
- **UI Elements:** Inter (Sans-serif) - 16px base

### Glassmorphism Formula

```css
/* Dark Mode */
background: white/5
backdrop-blur: xl
border: white/10

/* Light Mode */
background: white/70
backdrop-blur: xl  
border: white/50
```

## 🌟 Unique Features

1. **Time-Adaptive Themes** - UI automatically adjusts based on time of day (morning/day/evening/night)
2. **3D Tilt Hero Cards** - Interactive card tilting based on mouse movement
3. **Animated Gradient Orbs** - Living background with morphing gradients
4. **Bento Grid Layout** - Apple-style asymmetric card arrangement
5. **Magnetic Navigation** - Bubble-morphing tab bar with physics animations
6. **AI-Powered Insights** - Smart reflections on journal entries (coming soon)
7. **Immersive Reading Mode** - Distraction-free scripture reading
8. **Visual Progress Tracking** - Streak gamification and achievement system

## 📱 Responsive Design

- Mobile-first approach
- Touch targets minimum 44x44px
- Swipe gestures for navigation
- Adaptive grid layouts (1→2→3 columns)
- OLED-optimized dark mode

## 🔄 Flutter Migration

This React/TypeScript version serves as the design reference for the Flutter mobile app. See `ARCHITECTURE_MAPPING.md` for detailed component mapping and implementation guidelines.

### Quick Migration Checklist

- [ ] Update color palette to warm earthy tones
- [ ] Replace Lora with Crimson Text font
- [ ] Implement glassmorphic navigation dock
- [ ] Add sub-tabs to Lens (READ/DISCOVER)
- [ ] Add sub-tabs to Mentor (JOURNALS/AI)
- [ ] Implement 3D Soul Sphere in profile
- [ ] Create activity heatmap calendar

## 🏆 Premium Details

### Micro-Interactions
- Button press: scale(0.95)
- Card hover: lift + glow
- Icon animations: rotate, bounce
- Loading states: skeleton screens
- Success feedback: checkmark animation

### Performance Optimizations
- GPU-accelerated animations (transform/opacity only)
- Tree-shaken bundle (only imported code ships)
- Lazy-loaded components
- Optimized font loading (swap display)
- 60fps target throughout

## 📄 License

MIT License - See LICENSE file for details

## 🙏 Attributions

- UI Components: [shadcn/ui](https://ui.shadcn.com/) (MIT License)
- Images: [Unsplash](https://unsplash.com) (Unsplash License)
- Icons: [Lucide](https://lucide.dev/) (ISC License)

## 💬 About

Scripture Lens 2.0 is designed to make Bible reading captivating, comfortable, and truly unique. With sophisticated design elements, smooth animations, and AI-powered insights, it's a premium app that respects the sacred content while embracing modern technology.

---

*Built with love, precision, and a deep respect for scripture* 💛
