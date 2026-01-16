import { Home, BookOpen, BookMarked, Sparkles } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { useState } from "react";

type Page = "sanctuary" | "lens" | "plans" | "mentor";

interface RadialNavigationProps {
  currentPage: Page;
  onPageChange: (page: Page) => void;
  isDark: boolean;
}

export function RadialNavigation({ currentPage, onPageChange, isDark }: RadialNavigationProps) {
  const [isOpen, setIsOpen] = useState(false);

  const navItems = [
    { id: "sanctuary" as Page, icon: Home, label: "Home", angle: -90 },
    { id: "lens" as Page, icon: BookOpen, label: "Read", angle: -30 },
    { id: "plans" as Page, icon: BookMarked, label: "Plans", angle: 30 },
    { id: "mentor" as Page, icon: Sparkles, label: "Journal", angle: 90 }
  ];

  const currentItem = navItems.find(item => item.id === currentPage);
  const CurrentIcon = currentItem?.icon || Home;

  return (
    <div className="fixed bottom-8 left-1/2 -translate-x-1/2 z-50">
      {/* Radial Menu Items */}
      <AnimatePresence>
        {isOpen && navItems.map((item, index) => {
          const Icon = item.icon;
          const isActive = currentPage === item.id;
          const radius = 100;
          const angleInRadians = (item.angle * Math.PI) / 180;
          const x = Math.cos(angleInRadians) * radius;
          const y = Math.sin(angleInRadians) * radius;

          return (
            <motion.button
              key={item.id}
              initial={{ scale: 0, x: 0, y: 0, opacity: 0 }}
              animate={{
                scale: 1,
                x,
                y,
                opacity: 1,
              }}
              exit={{
                scale: 0,
                x: 0,
                y: 0,
                opacity: 0,
              }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 25,
                delay: index * 0.05,
              }}
              onClick={() => {
                onPageChange(item.id);
                setIsOpen(false);
              }}
              className={`absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-14 h-14 rounded-2xl ${
                isActive
                  ? "bg-gradient-to-br from-[#C17D4A] to-[#8B7355] shadow-2xl"
                  : isDark
                  ? "bg-white/10 backdrop-blur-xl border border-white/20"
                  : "bg-white/90 backdrop-blur-xl border border-black/10 shadow-xl"
              } flex items-center justify-center group`}
              whileHover={{ scale: 1.15 }}
              whileTap={{ scale: 0.9 }}
            >
              <Icon
                className={`w-6 h-6 ${
                  isActive
                    ? "text-white"
                    : isDark
                    ? "text-white/70"
                    : "text-gray-700"
                }`}
              />

              {/* Label */}
              <motion.div
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                className={`absolute ${
                  item.angle < 0 ? "bottom-full mb-3" : "top-full mt-3"
                } whitespace-nowrap px-3 py-1.5 rounded-xl ${
                  isDark
                    ? "bg-white/10 backdrop-blur-xl border border-white/20"
                    : "bg-white/90 backdrop-blur-xl border border-black/10 shadow-lg"
                }`}
              >
                <span
                  className={`text-xs font-semibold ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}
                >
                  {item.label}
                </span>
              </motion.div>
            </motion.button>
          );
        })}
      </AnimatePresence>

      {/* Central Button */}
      <motion.button
        onClick={() => setIsOpen(!isOpen)}
        className={`relative w-20 h-20 rounded-[28px] ${
          isDark
            ? "bg-gradient-to-br from-[#C17D4A] to-[#8B7355]"
            : "bg-gradient-to-br from-[#C17D4A] to-[#8B7355]"
        } shadow-2xl flex items-center justify-center overflow-hidden`}
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        animate={{
          rotate: isOpen ? 180 : 0,
        }}
        transition={{
          type: "spring",
          stiffness: 260,
          damping: 20,
        }}
      >
        {/* Glow effect */}
        <motion.div
          className="absolute inset-0 bg-gradient-to-br from-orange-400/40 to-transparent rounded-[28px]"
          animate={{
            opacity: isOpen ? [0.5, 0.8, 0.5] : 0,
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
          }}
        />

        {/* Icon */}
        <motion.div
          animate={{
            rotate: isOpen ? -180 : 0,
          }}
          transition={{
            type: "spring",
            stiffness: 260,
            damping: 20,
          }}
        >
          <AnimatePresence mode="wait">
            {isOpen ? (
              <motion.div
                key="close"
                initial={{ scale: 0, rotate: -90 }}
                animate={{ scale: 1, rotate: 0 }}
                exit={{ scale: 0, rotate: 90 }}
                transition={{ duration: 0.2 }}
                className="relative"
              >
                {/* X icon */}
                <div className="w-6 h-6 flex items-center justify-center">
                  <div className="absolute w-6 h-0.5 bg-white rounded-full rotate-45" />
                  <div className="absolute w-6 h-0.5 bg-white rounded-full -rotate-45" />
                </div>
              </motion.div>
            ) : (
              <motion.div
                key="open"
                initial={{ scale: 0, rotate: 90 }}
                animate={{ scale: 1, rotate: 0 }}
                exit={{ scale: 0, rotate: -90 }}
                transition={{ duration: 0.2 }}
              >
                <CurrentIcon className="w-7 h-7 text-white" />
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>

        {/* Ring animation when open */}
        <AnimatePresence>
          {isOpen && (
            <motion.div
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1.5, opacity: 0 }}
              exit={{ scale: 0, opacity: 0 }}
              transition={{ duration: 0.6 }}
              className="absolute inset-0 border-4 border-white/40 rounded-[28px]"
            />
          )}
        </AnimatePresence>
      </motion.button>

      {/* Backdrop */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setIsOpen(false)}
            className="fixed inset-0 bg-black/20 backdrop-blur-sm -z-10"
          />
        )}
      </AnimatePresence>
    </div>
  );
}
