// Temporary snippet to show the updated hero card section

            {/* Glassmorphic Card */}
            <div className="relative rounded-[32px] overflow-hidden shadow-2xl shadow-black/5">
              {/* Glass Background with Blur */}
              <div className={`absolute inset-0 ${
                isDark 
                  ? "bg-white/10" 
                  : "bg-white/80"
              } backdrop-blur-xl`} />
              
              {/* Subtle border */}
              <div className={`absolute inset-0 rounded-[32px] ring-1 ring-inset ${
                isDark ? "ring-white/20" : "ring-gray-200"
              }`} />

              {/* Content */}
              <div className="relative z-10 px-8 md:px-16 py-20">
