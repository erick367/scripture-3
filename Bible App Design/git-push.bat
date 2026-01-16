@echo off
REM Scripture Lens 2.0 - Git Push Script (Windows)
REM This script will push your complete React app to GitHub

echo ==================================================
echo Scripture Lens 2.0 - Git Push Script (Windows)
echo ==================================================
echo.

REM Step 1: Check if git is initialized
echo Step 1: Checking Git initialization...
if exist .git (
    echo [OK] Git already initialized
) else (
    echo Initializing Git repository...
    git init
    echo [OK] Git initialized
)
echo.

REM Step 2: Get GitHub username
echo Step 2: GitHub Repository Setup
set /p GITHUB_USERNAME="Enter your GitHub username: "
echo.

REM Repository URL
set REPO_URL=https://github.com/%GITHUB_USERNAME%/scripture-lens-2.git
echo Repository URL: %REPO_URL%
echo.

REM Step 3: Check and add remote
echo Step 3: Setting up remote repository...
git remote | findstr "origin" >nul
if %errorlevel% equ 0 (
    echo Remote 'origin' already exists. Updating URL...
    git remote set-url origin %REPO_URL%
) else (
    echo Adding remote origin...
    git remote add origin %REPO_URL%
)
echo [OK] Remote configured
echo.

REM Step 4: Verify remote
echo Step 4: Verifying remote...
git remote -v
echo.

REM Step 5: Stage files
echo Step 5: Staging files...
echo Adding all files to staging area...
git add .
echo.

REM Show what's being staged
echo Files staged for commit:
git status --short
echo.

REM Step 6: Create commit
echo Step 6: Creating commit...
echo Using comprehensive commit message...
git commit -m "Initial commit: Complete React Bible app with premium design - Implemented 4-tab architecture (Sanctuary, Lens, Plans, Mentor) - Added glassmorphic design with animated gradient orbs - Integrated warm earthy aesthetic color palette - Created immersive reading experience with 4 themes - Built dynamic reading plans with visual progress tracking - Developed dual-tab journal system with AI mentor - Implemented time-adaptive ambient backgrounds - Added comprehensive UI component library - Premium animations with Motion/React - Complete documentation for Flutter migration"
echo [OK] Commit created
echo.

REM Step 7: Push to GitHub
echo Step 7: Pushing to GitHub...
echo This may take a minute for the first push...
echo.

git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ==================================================
    echo SUCCESS! Your app is now on GitHub!
    echo ==================================================
    echo.
    echo [OK] All files pushed successfully
    echo [OK] Repository: %REPO_URL%
    echo.
    echo Next steps:
    echo 1. Visit: https://github.com/%GITHUB_USERNAME%/scripture-lens-2
    echo 2. Verify all files are present
    echo 3. Add repository description on GitHub
    echo 4. Add topics: bible-app, react, typescript, glassmorphism
    echo 5. Read ARCHITECTURE_MAPPING.md to start Flutter migration
    echo.
    echo Helpful files created:
    echo   - QUICK_START.md - Quick command reference
    echo   - GIT_SETUP_GUIDE.md - Detailed Git guide
    echo   - FILE_INVENTORY.md - Complete file listing
    echo   - PUSH_CHECKLIST.md - Verification checklist
    echo.
) else (
    echo.
    echo ==================================================
    echo Push failed!
    echo ==================================================
    echo.
    echo Common solutions:
    echo.
    echo 1. If 'permission denied':
    echo    - Check your GitHub credentials
    echo    - Try: git push -u origin main
    echo.
    echo 2. If 'updates were rejected':
    echo    - Run: git pull origin main --rebase
    echo    - Then: git push -u origin main
    echo.
    echo 3. If 'remote origin already exists':
    echo    - Run: git remote remove origin
    echo    - Then run this script again
    echo.
    echo 4. If branch name error (main vs master):
    echo    - Run: git branch -M main
    echo    - Then: git push -u origin main
    echo.
    echo See GIT_SETUP_GUIDE.md for more help
    echo.
)

echo ==================================================
echo Script completed
echo ==================================================
pause
