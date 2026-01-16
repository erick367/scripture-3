# 🚀 Git Setup & Repository Push Guide

## 📋 Pre-Push Checklist

✅ GitHub account connected  
✅ Repository created: `scripture-lens-2`  
✅ .gitignore file created  
✅ README.md updated  

---

## 🎯 Step-by-Step Git Commands

### Step 1: Initialize Git Repository (if not already done)

```bash
# Navigate to your project directory
cd /path/to/scripture-lens-2

# Initialize git (skip if already initialized)
git init

# Check current status
git status
```

### Step 2: Configure Git (First Time Setup)

```bash
# Set your username
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list
```

### Step 3: Add Remote Repository

```bash
# Add your GitHub repository as remote origin
git remote add origin https://github.com/YOUR_USERNAME/scripture-lens-2.git

# Verify remote was added
git remote -v
```

### Step 4: Stage All Files

```bash
# Add all files to staging area
git add .

# Or add specific files/directories
git add src/
git add package.json
git add README.md
git add *.md
git add *.json
git add *.tsx
git add *.css

# Check what's staged
git status
```

### Step 5: Create Initial Commit

```bash
# Commit with descriptive message
git commit -m "Initial commit: Complete React/TypeScript Bible app with premium design system

- Implemented 4-tab architecture (Sanctuary, Lens, Plans, Mentor)
- Added glassmorphic design with animated gradient orbs
- Integrated warm earthy aesthetic color palette
- Created immersive reading experience with 4 themes
- Built dynamic reading plans with visual progress tracking
- Developed dual-tab journal system with AI mentor architecture
- Implemented time-adaptive ambient backgrounds
- Added comprehensive UI component library (shadcn/ui)
- Configured Motion/React for smooth animations
- Set up Crimson Text for scripture, Inter for UI
- Created premium stat cards with circular progress indicators
- Built bookmark and highlight system
- Added search overlay with glassmorphic design
- Implemented DynamicIsland navigation with expand/collapse
- Created comprehensive documentation (ARCHITECTURE_MAPPING, DESIGN_SHOWCASE, etc.)
"
```

### Step 6: Push to GitHub

```bash
# Push to main branch (first time)
git push -u origin main

# If your default branch is 'master', use:
git push -u origin master

# For subsequent pushes (after first time):
git push
```

---

## 🔧 Alternative: If Using SSH Instead of HTTPS

### Setup SSH Key (One-time)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard (Mac)
pbcopy < ~/.ssh/id_ed25519.pub

# Or display it (Linux/Windows)
cat ~/.ssh/id_ed25519.pub
```

Then add the SSH key to GitHub:
1. Go to GitHub → Settings → SSH and GPG keys
2. Click "New SSH Key"
3. Paste your public key
4. Click "Add SSH Key"

### Use SSH Remote URL

```bash
# Remove HTTPS remote
git remote remove origin

# Add SSH remote
git remote add origin git@github.com:YOUR_USERNAME/scripture-lens-2.git

# Push
git push -u origin main
```

---

## 📦 What's Being Pushed

### Core Application Files
- ✅ `/src/app/App.tsx` - Main application
- ✅ `/src/app/components/` - All React components
  - HomePage.tsx (Sanctuary)
  - ReadPage.tsx (Lens)
  - PlansPage.tsx (Plans)
  - MentorPage.tsx (Journal/AI)
  - DynamicIslandNav.tsx
  - SpiritualCarousel.tsx
  - PlanReadingView.tsx
  - ProfilePage.tsx (Search)
  - MeScreen.tsx (Profile)
  - All UI components (40+ shadcn/ui components)

### Styles
- ✅ `/src/styles/fonts.css` - Crimson Text & Inter
- ✅ `/src/styles/theme.css` - Design tokens
- ✅ `/src/styles/tailwind.css` - Tailwind v4 config
- ✅ `/src/styles/index.css` - Main styles

### Configuration
- ✅ `package.json` - Dependencies
- ✅ `tsconfig.json` - TypeScript config
- ✅ `vite.config.ts` - Vite config
- ✅ `postcss.config.mjs` - PostCSS config
- ✅ `index.html` - Entry HTML

### Documentation
- ✅ `README.md` - Project overview
- ✅ `ARCHITECTURE_MAPPING.md` - Flutter migration guide
- ✅ `DESIGN_SHOWCASE.md` - Feature documentation
- ✅ `PREMIUM_DESIGN_SYSTEM.md` - Design specs
- ✅ `WOW_FACTOR.md` - Unique features
- ✅ `ATTRIBUTIONS.md` - Credits
- ✅ `DEPLOYMENT.md` - Deployment guide
- ✅ `GIT_SETUP_GUIDE.md` - This file

### What's IGNORED (.gitignore)
- ❌ `node_modules/` - Dependencies (too large)
- ❌ `/dist/` - Build output
- ❌ `.env*` - Environment variables
- ❌ `*.log` - Log files
- ❌ `.DS_Store` - OS files
- ❌ `.vscode/` - Editor config

---

## 🎨 Repository Structure on GitHub

```
scripture-lens-2/
├── 📁 src/
│   ├── 📁 app/
│   │   ├── App.tsx
│   │   └── 📁 components/
│   │       ├── HomePage.tsx
│   │       ├── ReadPage.tsx
│   │       ├── PlansPage.tsx
│   │       ├── MentorPage.tsx
│   │       ├── DynamicIslandNav.tsx
│   │       ├── SpiritualCarousel.tsx
│   │       ├── PlanReadingView.tsx
│   │       ├── ProfilePage.tsx
│   │       ├── MeScreen.tsx
│   │       ├── JournalPage.tsx
│   │       ├── RadialNavigation.tsx
│   │       └── 📁 ui/ (40+ components)
│   ├── 📁 styles/
│   │   ├── fonts.css
│   │   ├── theme.css
│   │   ├── tailwind.css
│   │   └── index.css
│   └── main.tsx
├── 📄 index.html
├── 📄 package.json
├── 📄 tsconfig.json
├── 📄 vite.config.ts
├── 📄 postcss.config.mjs
├── 📄 .gitignore
├── 📄 README.md
├── 📄 ARCHITECTURE_MAPPING.md
├── 📄 DESIGN_SHOWCASE.md
├── 📄 PREMIUM_DESIGN_SYSTEM.md
├── 📄 WOW_FACTOR.md
├── 📄 ATTRIBUTIONS.md
├── 📄 DEPLOYMENT.md
└── 📄 GIT_SETUP_GUIDE.md
```

---

## 🔄 Making Future Updates

### After Making Changes

```bash
# Check what changed
git status

# See specific changes
git diff

# Stage changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push
```

### Example Commit Messages

```bash
# Feature additions
git commit -m "Add verse highlighting feature to ReadPage"

# Bug fixes
git commit -m "Fix navigation animation jank on iOS Safari"

# Design updates
git commit -m "Update color palette to warmer earth tones"

# Performance improvements
git commit -m "Optimize gradient orb animations for 60fps"
```

---

## 🌿 Branch Strategy (Optional)

### Create Feature Branches

```bash
# Create and switch to new branch
git checkout -b feature/flutter-migration

# Make changes, then commit
git add .
git commit -m "Start Flutter migration: Create project structure"

# Push branch to GitHub
git push -u origin feature/flutter-migration

# Switch back to main
git checkout main

# Merge feature branch (after testing)
git merge feature/flutter-migration
```

---

## 🚨 Troubleshooting

### Problem: "Remote origin already exists"
```bash
# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/YOUR_USERNAME/scripture-lens-2.git
```

### Problem: "Failed to push - rejected"
```bash
# Pull latest changes first
git pull origin main --rebase

# Then push
git push
```

### Problem: "Large files won't push"
```bash
# Check file sizes
find . -type f -size +50M

# Add large files to .gitignore
echo "path/to/large/file" >> .gitignore

# Remove from git tracking (keeps local file)
git rm --cached path/to/large/file

# Commit and push
git commit -m "Remove large files from tracking"
git push
```

### Problem: "Merge conflicts"
```bash
# See conflicted files
git status

# Open files and resolve conflicts manually
# Look for <<<<<<< HEAD markers

# After resolving, stage files
git add .

# Complete the merge
git commit -m "Resolve merge conflicts"
git push
```

---

## 📊 Verify Push Success

After pushing, verify on GitHub:

1. Go to `https://github.com/YOUR_USERNAME/scripture-lens-2`
2. Check all files are present
3. View commit history
4. Confirm README displays correctly
5. Test clone in new directory:

```bash
# Clone to new location to test
cd ~/Desktop
git clone https://github.com/YOUR_USERNAME/scripture-lens-2.git test-clone
cd test-clone
npm install
npm run dev
```

---

## 🎯 Next Steps After Push

1. ✅ **Verify repository on GitHub**
2. ✅ **Add repository description** (on GitHub)
3. ✅ **Add topics/tags** (react, typescript, bible-app, glassmorphism, etc.)
4. ✅ **Enable GitHub Pages** (optional - for live demo)
5. ✅ **Add collaborators** (if team project)
6. ✅ **Create Flutter branch** for migration work
7. ✅ **Set up GitHub Actions** for CI/CD (optional)

---

## 🏆 Git Best Practices

✅ **Commit often** - Small, focused commits  
✅ **Write clear messages** - Describe what and why  
✅ **Pull before push** - Avoid conflicts  
✅ **Use branches** - Keep main stable  
✅ **Review changes** - Check `git diff` before committing  
✅ **Ignore secrets** - Never commit API keys, .env files  
✅ **Tag releases** - Use semantic versioning (v1.0.0, v1.1.0)  

---

## 📞 Need Help?

- Git Documentation: https://git-scm.com/doc
- GitHub Guides: https://guides.github.com
- Git Cheat Sheet: https://education.github.com/git-cheat-sheet-education.pdf

---

*Happy coding! Your premium Bible app is now backed up and ready for Flutter migration* 🚀📖
