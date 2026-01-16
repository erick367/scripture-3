#!/bin/bash

# 🚀 Scripture Lens 2.0 - Git Push Script
# This script will push your complete React app to GitHub

echo "=================================================="
echo "📖 Scripture Lens 2.0 - Git Push Script"
echo "=================================================="
echo ""

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check if git is initialized
echo -e "${BLUE}Step 1: Checking Git initialization...${NC}"
if [ -d .git ]; then
    echo -e "${GREEN}✓ Git already initialized${NC}"
else
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
    echo -e "${GREEN}✓ Git initialized${NC}"
fi
echo ""

# Step 2: Get GitHub username
echo -e "${BLUE}Step 2: GitHub Repository Setup${NC}"
read -p "Enter your GitHub username: " GITHUB_USERNAME
echo ""

# Repository URL
REPO_URL="https://github.com/$GITHUB_USERNAME/scripture-lens-2.git"
echo -e "${YELLOW}Repository URL: $REPO_URL${NC}"
echo ""

# Step 3: Check and add remote
echo -e "${BLUE}Step 3: Setting up remote repository...${NC}"
if git remote | grep -q 'origin'; then
    echo -e "${YELLOW}Remote 'origin' already exists. Updating URL...${NC}"
    git remote set-url origin $REPO_URL
else
    echo -e "${YELLOW}Adding remote origin...${NC}"
    git remote add origin $REPO_URL
fi
echo -e "${GREEN}✓ Remote configured: origin -> $REPO_URL${NC}"
echo ""

# Step 4: Verify remote
echo -e "${BLUE}Step 4: Verifying remote...${NC}"
git remote -v
echo ""

# Step 5: Stage files
echo -e "${BLUE}Step 5: Staging files...${NC}"
echo -e "${YELLOW}Adding all files to staging area...${NC}"
git add .
echo ""

# Show what's being staged
echo -e "${YELLOW}Files staged for commit:${NC}"
git status --short | head -20
TOTAL_FILES=$(git status --short | wc -l)
echo -e "${GREEN}✓ Total files staged: $TOTAL_FILES${NC}"
echo ""

# Warning if node_modules is staged
if git status | grep -q 'node_modules'; then
    echo -e "${RED}⚠️  WARNING: node_modules detected in staging!${NC}"
    echo -e "${RED}This should be in .gitignore${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Aborted.${NC}"
        exit 1
    fi
fi

# Step 6: Create commit
echo -e "${BLUE}Step 6: Creating commit...${NC}"
echo -e "${YELLOW}Using comprehensive commit message...${NC}"
git commit -m "Initial commit: Complete React Bible app with premium design

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
- Created comprehensive documentation for Flutter migration
"
echo -e "${GREEN}✓ Commit created${NC}"
echo ""

# Step 7: Push to GitHub
echo -e "${BLUE}Step 7: Pushing to GitHub...${NC}"
echo -e "${YELLOW}This may take a minute for the first push...${NC}"
echo ""

git push -u origin main

# Check if push was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=================================================="
    echo -e "🎉 SUCCESS! Your app is now on GitHub! 🎉"
    echo -e "==================================================${NC}"
    echo ""
    echo -e "${GREEN}✓ All files pushed successfully${NC}"
    echo -e "${GREEN}✓ Repository: $REPO_URL${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Visit: https://github.com/$GITHUB_USERNAME/scripture-lens-2"
    echo "2. Verify all files are present"
    echo "3. Add repository description on GitHub"
    echo "4. Add topics: bible-app, react, typescript, glassmorphism"
    echo "5. Read ARCHITECTURE_MAPPING.md to start Flutter migration"
    echo ""
    echo -e "${YELLOW}📚 Helpful files created:${NC}"
    echo "  - QUICK_START.md - Quick command reference"
    echo "  - GIT_SETUP_GUIDE.md - Detailed Git guide"
    echo "  - FILE_INVENTORY.md - Complete file listing"
    echo "  - PUSH_CHECKLIST.md - Verification checklist"
    echo ""
else
    echo ""
    echo -e "${RED}=================================================="
    echo -e "❌ Push failed!"
    echo -e "==================================================${NC}"
    echo ""
    echo -e "${YELLOW}Common solutions:${NC}"
    echo ""
    echo -e "${BLUE}1. If 'permission denied':${NC}"
    echo "   - Check your GitHub credentials"
    echo "   - Try: git push -u origin main"
    echo ""
    echo -e "${BLUE}2. If 'updates were rejected':${NC}"
    echo "   - Run: git pull origin main --rebase"
    echo "   - Then: git push -u origin main"
    echo ""
    echo -e "${BLUE}3. If 'remote origin already exists':${NC}"
    echo "   - Run: git remote remove origin"
    echo "   - Then run this script again"
    echo ""
    echo -e "${BLUE}4. If branch name error (main vs master):${NC}"
    echo "   - Run: git branch -M main"
    echo "   - Then: git push -u origin main"
    echo ""
    echo "See GIT_SETUP_GUIDE.md for more troubleshooting help"
    echo ""
fi

echo -e "${YELLOW}=================================================="
echo "Script completed at $(date)"
echo "==================================================${NC}"
