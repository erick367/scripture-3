import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";

// Import components individually
import { ReadPage } from "@/app/components/ReadPage";
import { PlansPage } from "@/app/components/PlansPage";
import { MentorPage } from "@/app/components/MentorPage";
import { MeScreen } from "@/app/components/MeScreen";
import { ProfilePage } from "@/app/components/ProfilePage";
import { DynamicIslandNav } from "@/app/components/DynamicIslandNav";
import { HomePage } from "@/app/components/HomePage";

type Page = "sanctuary" | "lens" | "plans" | "mentor";
type TimeOfDay = "morning" | "day" | "evening" | "night";

export default function App() {
  const [currentPage, setCurrentPage] = useState<Page>("sanctuary");
  const [showProfile, setShowProfile] = useState(false);
  const [showSearch, setShowSearch] = useState(false);
  const [timeOfDay, setTimeOfDay] = useState<TimeOfDay>("day");
  const [forceLightMode, setForceLightMode] = useState(false);
  const [readingContext, setReadingContext] = useState<{
    book: string;
    chapter: string;
    planTitle?: string;
  } | null>(null);
  const [hideMainNav, setHideMainNav] = useState(false);

  // Dynamic time-based ambient background
  useEffect(() => {
    if (forceLightMode) {
      setTimeOfDay("day");
      return;
    }
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 12) setTimeOfDay("morning");
    else if (hour >= 12 && hour < 17) setTimeOfDay("day");
    else if (hour >= 17 && hour < 20) setTimeOfDay("evening");
    else setTimeOfDay("night");
  }, [forceLightMode]);

  const isDarkMode = (timeOfDay === "night" || timeOfDay === "evening") && !forceLightMode;

  const handleNavigateToRead = (book: string, chapter: string, planTitle?: string) => {
    setReadingContext({ book, chapter, planTitle });
    setCurrentPage("lens");
  };

  return (
    <div className={`min-h-screen ${
      isDarkMode 
        ? "bg-[#0A0A0A]" 
        : "bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50"
    } transition-colors duration-700 font-ui relative`}>
      
      {/* Main Content */}
      <main className="relative z-10">
        <AnimatePresence mode="wait">
          <motion.div
            key={showProfile ? "profile" : showSearch ? "search" : currentPage}
            initial={{ opacity: 0, scale: 0.98 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.98 }}
            transition={{ duration: 0.3, ease: [0.4, 0, 0.2, 1] }}
          >
            {showProfile && (
              <MeScreen onClose={() => setShowProfile(false)} timeOfDay={timeOfDay} />
            )}
            
            {showSearch && (
              <ProfilePage onClose={() => setShowSearch(false)} timeOfDay={timeOfDay} />
            )}
            
            {!showProfile && !showSearch && currentPage === "sanctuary" && (
              <HomePage 
                onProfileClick={() => setShowProfile(true)} 
                onSearchClick={() => setShowSearch(true)} 
                timeOfDay={timeOfDay} 
              />
            )}
            
            {!showProfile && !showSearch && currentPage === "lens" && (
              <ReadPage timeOfDay={timeOfDay} readingContext={readingContext} />
            )}
            
            {!showProfile && !showSearch && currentPage === "plans" && (
              <PlansPage timeOfDay={timeOfDay} onNavigateToRead={handleNavigateToRead} onNavVisibilityChange={setHideMainNav} />
            )}
            
            {!showProfile && !showSearch && currentPage === "mentor" && (
              <MentorPage timeOfDay={timeOfDay} onNavigateToRead={handleNavigateToRead} />
            )}
          </motion.div>
        </AnimatePresence>
      </main>

      {/* Dynamic Island Navigation */}
      {!showProfile && !showSearch && (
        <motion.div
          initial={{ y: 0 }}
          animate={{ y: hideMainNav ? 200 : 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
        >
          <DynamicIslandNav
            currentPage={currentPage}
            onPageChange={(page) => setCurrentPage(page)}
            isDark={isDarkMode}
          />
        </motion.div>
      )}

      <style>{`
        @keyframes shimmer {
          0% { transform: translateX(-100%); }
          100% { transform: translateX(100%); }
        }
        .animate-shimmer {
          animation: shimmer 3s infinite;
        }
      `}</style>
    </div>
  );
}