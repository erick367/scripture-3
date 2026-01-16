# 📦 Scripture Lens 2.0 - Deployment Guide

## ⚠️ Important Note

Due to the large size of the complete application (70+ files, 15,000+ lines of code), this repository contains the core structure and documentation. To get the full working application:

1. **Download from Figma Make** - Export the complete project from your Figma Make workspace
2. **Clone this repository** - Get the documentation and configuration files
3. **Merge them together** - Combine the exported code with this repository

## 📁 Complete File Structure

```
scripture-lens-2/
├── src/
│   ├── main.tsx                    # Application entry point
│   ├── app/
│   │   ├── App.tsx                 # Main app component
│   │   └── components/
│   │       ├── HomePage.tsx        # Sanctuary (Home) - 800+ lines
│   │       ├── ReadPage.tsx        # Lens (Reading) - 1000+ lines
│   │       ├── PlansPage.tsx       # Reading plans - 1200+ lines
│   │       ├── MentorPage.tsx      # Journal/AI - 1000+ lines
│   │       ├── DynamicIslandNav.tsx # Navigation
│   │       ├── PlanReadingView.tsx  # Plan reader
│   │       ├── SpiritualCarousel.tsx # Hero carousel
│   │       ├── MeScreen.tsx        # Profile
│   │       ├── ProfilePage.tsx     # Search overlay
│   │       └── ui/                 # shadcn/ui components (50+ files)
│   └── styles/
│       ├── fonts.css               # Google Fonts imports
│       ├── index.css               # Main stylesheet
│       ├── tailwind.css            # Tailwind configuration
│       └── theme.css               # Design tokens
├── ARCHITECTURE_MAPPING.md         # Flutter migration guide
├── DESIGN_SHOWCASE.md             # Features documentation
├── PREMIUM_DESIGN_SYSTEM.md       # Design specifications
├── WOW_FACTOR.md                  # Unique features
├── package.json                    # Dependencies
├── vite.config.ts                  # Vite configuration
├── tsconfig.json                   # TypeScript config
├── index.html                      # HTML entry
├── .gitignore                      # Git ignore rules
└── README.md                       # Project documentation
```

## 🔧 Setup Instructions

### 1. Clone this Repository

```bash
git clone https://github.com/erick367/scripture-lens-2.git
cd scripture-lens-2
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Add Missing Source Files

The following large component files need to be added to `/src/app/components/`:

- **HomePage.tsx** (800+ lines) - Complete home dashboard
- **ReadPage.tsx** (1000+ lines) - Full reading experience  
- **PlansPage.tsx** (1200+ lines) - Reading plans system
- **MentorPage.tsx** (1000+ lines) - Journal/AI system
- **PlanReadingView.tsx** - Dedicated plan reader
- **SpiritualCarousel.tsx** - Hero card carousel
- **MeScreen.tsx** - Profile screen
- **ProfilePage.tsx** - Search overlay

And `/src/app/components/ui/` (50+ shadcn/ui components)

### 4. Run Development Server

```bash
npm run dev
```

### 5. Build for Production

```bash
npm run build
```

## 📦 Dependencies Overview

### Core Framework
- React 18.3.1 + TypeScript
- Vite 6.3.5
- Tailwind CSS 4.1.12

### Animation & UI
- motion/react 12.23.24 (Framer Motion)
- lucide-react 0.487.0 (Icons)
- @radix-ui/* (UI primitives)
- @mui/material 7.3.5 (Material UI)

### Utilities
- react-hook-form 7.55.0
- date-fns 3.6.0
- recharts 2.15.2
- sonner 2.0.3 (Toast notifications)

## 🎨 Key Features Included

✅ 4-tab architecture (Sanctuary, Lens, Plans, Mentor)
✅ Time-adaptive ambient backgrounds
✅ Glassmorphic design system
✅ 3D tilt effects on hero cards
✅ Animated gradient orbs
✅ Multiple reading themes (Light/Sepia/Dark/OLED)
✅ Immersive reading mode
✅ Visual progress tracking
✅ Journal system with AI insights
✅ Reading plans with bookmark system
✅ Search overlay
✅ Profile with stats and heatmap

## 📱 Responsive Design

- Mobile-first approach
- Touch targets minimum 44x44px
- Adaptive grid layouts
- OLED-optimized dark mode

## 🚀 Performance

- GPU-accelerated animations
- Tree-shaken bundle
- Lazy-loaded components
- Optimized font loading
- 60fps target

## 🔄 Flutter Migration

See `ARCHITECTURE_MAPPING.md` for detailed Flutter conversion guide.

## 📄 License

MIT License

## 🙏 Credits

- UI Components: shadcn/ui (MIT)
- Icons: Lucide (ISC)
- Images: Unsplash

---

**For the complete working application, export from Figma Make and merge with this repository structure.**
