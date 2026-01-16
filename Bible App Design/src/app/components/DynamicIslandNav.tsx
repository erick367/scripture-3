import { motion, AnimatePresence } from "motion/react";
import { Home, BookOpen, BookMarked, Sparkles } from "lucide-react";
import { useState } from "react";

interface DynamicIslandNavProps {
  currentPage: "sanctuary" | "lens" | "plans" | "mentor";
  onPageChange: (page: "sanctuary" | "lens" | "plans" | "mentor") => void;
  isDark: boolean;
}

export function DynamicIslandNav({ currentPage, onPageChange, isDark }: DynamicIslandNavProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  const navItems = [
    { id: "sanctuary", icon: Home, label: "Home", gradient: "from-orange-500 to-pink-600" },
    { id: "lens", icon: BookOpen, label: "Read", gradient: "from-blue-500 to-cyan-600" },
    { id: "plans", icon: BookMarked, label: "Plans", gradient: "from-purple-500 to-pink-600" },
    { id: "mentor", icon: Sparkles, label: "Journal", gradient: "from-green-500 to-emerald-600" }
  ];

  const currentItem = navItems.find(item => item.id === currentPage) || navItems[0];
  const CurrentIcon = currentItem.icon;

  const handleNavClick = (pageId: string) => {
    onPageChange(pageId as "sanctuary" | "lens" | "plans" | "mentor");
    // Auto-collapse after selection
    setTimeout(() => setIsExpanded(false), 300);
  };

  return (
    <motion.div
      className="fixed bottom-8 left-1/2 -translate-x-1/2 z-50"
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.3, type: "spring", stiffness: 200, damping: 20 }}
    >
      <motion.div
        animate={{
          width: isExpanded ? 320 : 80,
          height: isExpanded ? 64 : 56,
        }}
        transition={{
          type: "spring",
          stiffness: 300,
          damping: 30,
        }}
        onClick={() => !isExpanded && setIsExpanded(true)}
        className={`relative rounded-full cursor-pointer overflow-hidden ${
          isExpanded 
            ? isDark
              ? "bg-white/5 border border-white/10 backdrop-blur-2xl shadow-2xl"
              : "bg-white/20 border border-white/30 backdrop-blur-2xl shadow-2xl"
            : "bg-transparent border-none shadow-none"
        }`}
        style={{
          boxShadow: isExpanded ? (isDark
            ? "0 10px 40px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 255, 255, 0.1)"
            : "0 10px 40px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(0, 0, 0, 0.05)") : "none",
        }}
      >
        {/* Collapsed State - Current Icon Only */}
        <AnimatePresence>
          {!isExpanded && (
            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.8 }}
              transition={{ duration: 0.2 }}
              className="absolute inset-0 flex items-center justify-center"
            >
              <motion.div
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                className={`w-12 h-12 rounded-full bg-gradient-to-br ${currentItem.gradient} flex items-center justify-center shadow-lg`}
              >
                <CurrentIcon className="w-6 h-6 text-white" />
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Expanded State - All Icons */}
        <AnimatePresence>
          {isExpanded && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="absolute inset-0 flex items-center justify-around px-4"
            >
              {navItems.map((item, index) => {
                const Icon = item.icon;
                const isActive = item.id === currentPage;

                return (
                  <motion.button
                    key={item.id}
                    initial={{ scale: 0, opacity: 0, y: 20 }}
                    animate={{ scale: 1, opacity: 1, y: 0 }}
                    exit={{ scale: 0, opacity: 0, y: 20 }}
                    transition={{
                      delay: index * 0.05,
                      type: "spring",
                      stiffness: 400,
                      damping: 25,
                    }}
                    whileHover={{ scale: 1.15, y: -4 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => handleNavClick(item.id)}
                    className="relative group"
                  >
                    {/* Active Background */}
                    {isActive && (
                      <motion.div
                        layoutId="activeTab"
                        className={`absolute inset-0 rounded-full bg-gradient-to-br ${item.gradient}`}
                        transition={{
                          type: "spring",
                          stiffness: 400,
                          damping: 30,
                        }}
                      />
                    )}

                    {/* Icon Container */}
                    <div
                      className={`relative w-12 h-12 rounded-full flex items-center justify-center transition-all ${
                        isActive
                          ? "text-white"
                          : isDark
                          ? "text-white/60 hover:text-white/90"
                          : "text-gray-600 hover:text-gray-900"
                      }`}
                    >
                      <Icon className="w-6 h-6" />
                    </div>

                    {/* Hover Label */}
                    <motion.div
                      initial={{ opacity: 0, y: 10 }}
                      whileHover={{ opacity: 1, y: 0 }}
                      className={`absolute -top-10 left-1/2 -translate-x-1/2 px-3 py-1.5 rounded-xl whitespace-nowrap text-xs font-semibold ${
                        isDark
                          ? "bg-white/90 text-gray-900"
                          : "bg-gray-900/90 text-white"
                      } shadow-lg`}
                    >
                      {item.label}
                      <div
                        className={`absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 rotate-45 ${
                          isDark ? "bg-white/90" : "bg-gray-900/90"
                        }`}
                      />
                    </motion.div>
                  </motion.button>
                );
              })}
            </motion.div>
          )}
        </AnimatePresence>

        {/* Tap Outside to Collapse */}
        {isExpanded && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setIsExpanded(false)}
            className="fixed inset-0 -z-10"
          />
        )}
      </motion.div>

      {/* Subtle Hint - Shows Once */}
      {!isExpanded && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: [0, 0.6, 0] }}
          transition={{ duration: 2, delay: 1, repeat: 2 }}
          className={`absolute -top-12 left-1/2 -translate-x-1/2 text-xs font-medium whitespace-nowrap ${
            isDark ? "text-white/40" : "text-gray-500"
          }`}
        >
          Tap to navigate
        </motion.div>
      )}
    </motion.div>
  );
}