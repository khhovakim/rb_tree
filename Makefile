# ===== Colors for pretty output =====
_GREY   = \033[1;30m
_RED    = \033[1;31m
_GREEN  = \033[1;32m
_YELLOW = \033[1;33m
_BLUE   = \033[1;34m
_PURPLE = \033[1;35m
_CYAN   = \033[1;36m
_WHITE  = \033[1;37m
_NC     = \033[0m

# Colored messages
SUCCESS   = $(_GREEN)SUCCESS[✔]$(_NC)
COMPILING = $(_BLUE)COMPILING[●]$(_NC)

# ===== Executable name =====
NAME = rb_tree

# ===== Directories =====
SRCDIR = src
INCDIR = include

OBJDIR_RELEASE = obj/release
OBJDIR_DEBUG   = obj/debug
OBJDIR_ASAN    = obj/asan

BINDIR_RELEASE = bin/release
BINDIR_DEBUG   = bin/debug
BINDIR_ASAN    = bin/asan

TARGET_RELEASE = $(BINDIR_RELEASE)/$(NAME)
TARGET_DEBUG   = $(BINDIR_DEBUG)/$(NAME)
TARGET_ASAN    = $(BINDIR_ASAN)/$(NAME)

# ===== Source files =====
SRCFILES = $(shell find $(SRCDIR) -name "*.c" -o -name "*.cc" -o -name "*.cpp")

# ===== Include directories =====
INCDIRS  = $(shell find $(INCDIR) -type d)
IFLAGS   = $(foreach dir,$(INCDIRS),-I$(dir))

# ===== Compilers =====
CC       = clang
CXX      = clang++

# ===== Flags =====
FLAGS = -Wall -Wextra -Werror -pedantic-errors

CCFLAGS   = -std=c11 $(FLAGS)
CCXXFLAGS = -std=c++17 $(FLAGS)

CFLAGS_RELEASE   = $(CCFLAGS) -O2 -DNDEBUG
CXXFLAGS_RELEASE = $(CCXXFLAGS) -O2 -DNDEBUG

CFLAGS_DEBUG     = $(CCFLAGS) -g -O0
CXXFLAGS_DEBUG   = $(CCXXFLAGS) -g -O0

CFLAGS_ASAN      = $(CCFLAGS) -g -O0 -fsanitize=address -fno-omit-frame-pointer
CXXFLAGS_ASAN    = $(CCXXFLAGS) -g -O0 -fsanitize=address -fno-omit-frame-pointer

DEPFLAGS = -MMD -MP

# ===== Object lists =====
OBJ_RELEASE = \
	$(patsubst %.c,$(OBJDIR_RELEASE)/%.o,$(filter %.c,$(SRCFILES))) \
	$(patsubst %.cc,$(OBJDIR_RELEASE)/%.o,$(filter %.cc,$(SRCFILES))) \
	$(patsubst %.cpp,$(OBJDIR_RELEASE)/%.o,$(filter %.cpp,$(SRCFILES)))

OBJ_DEBUG = \
	$(patsubst %.c,$(OBJDIR_DEBUG)/%.o,$(filter %.c,$(SRCFILES))) \
	$(patsubst %.cc,$(OBJDIR_DEBUG)/%.o,$(filter %.cc,$(SRCFILES))) \
	$(patsubst %.cpp,$(OBJDIR_DEBUG)/%.o,$(filter %.cpp,$(SRCFILES)))

OBJ_ASAN = \
	$(patsubst %.c,$(OBJDIR_ASAN)/%.o,$(filter %.c,$(SRCFILES))) \
	$(patsubst %.cc,$(OBJDIR_ASAN)/%.o,$(filter %.cc,$(SRCFILES))) \
	$(patsubst %.cpp,$(OBJDIR_ASAN)/%.o,$(filter %.cpp,$(SRCFILES)))

# ===== Makefile flags =====
MAKEFLAGS = --no-print-directory

# ===== Usage note =====
#   make release → Optimized build
#   make debug   → Debug build
#   make asan    → ASan build

# ===== Default target =====
.PHONY: all
all: release

# ===== Build modes =====
.PHONY: release debug asan

release: pretty
release: CFLAGS = $(CFLAGS_RELEASE)
release: CXXFLAGS = $(CXXFLAGS_RELEASE)
release: $(TARGET_RELEASE)

debug:   pretty
debug:   CFLAGS = $(CFLAGS_DEBUG)
debug:   CXXFLAGS = $(CXXFLAGS_DEBUG)
debug:   $(TARGET_DEBUG)

asan:    pretty
asan:    CFLAGS = $(CFLAGS_ASAN)
asan:    CXXFLAGS = $(CXXFLAGS_ASAN)
asan:    $(TARGET_ASAN)

# ===== Linking =====
$(TARGET_RELEASE): $(OBJ_RELEASE)
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$@ ...$(_NC)"
	@mkdir -p $(BINDIR_RELEASE)
	@$(CXX) $(CXXFLAGS) -o $@ $(OBJ_RELEASE)
	@echo "$(SUCCESS)\n$(_WHITE)Linked $@$(_NC)"

$(TARGET_DEBUG): $(OBJ_DEBUG)
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$@ ...$(_NC)"
	@mkdir -p $(BINDIR_DEBUG)
	@$(CXX) $(CXXFLAGS) -o $@ $(OBJ_DEBUG)
	@echo "$(SUCCESS)\n$(_WHITE)Linked $@$(_NC)"

$(TARGET_ASAN): $(OBJ_ASAN)
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$@ ...$(_NC)"
	@mkdir -p $(BINDIR_ASAN)
	@$(CXX) $(CXXFLAGS) -o $@ $(OBJ_ASAN)
	@echo "$(SUCCESS)\n$(_WHITE)Linked $@$(_NC)"

# ===== Compile rules =====
$(OBJDIR_RELEASE)/%.o: %.c Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CC][RELEASE] $< → $@$(_NC)"
	$(CC) $(CFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_RELEASE)/%.o: %.cc Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][RELEASE] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_RELEASE)/%.o: %.cpp Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][RELEASE] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_DEBUG)/%.o: %.c Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CC][DEBUG] $< → $@$(_NC)"
	$(CC) $(CFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_DEBUG)/%.o: %.cc Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][DEBUG] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_DEBUG)/%.o: %.cpp Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][DEBUG] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_ASAN)/%.o: %.c Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CC][ASAN] $< → $@$(_NC)"
	$(CC) $(CFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_ASAN)/%.o: %.cc Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][ASAN] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR_ASAN)/%.o: %.cpp Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][ASAN] $< → $@$(_NC)"
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

# ===== Auto-include dependency files =====
-include $(OBJ_RELEASE:.o=.d)
-include $(OBJ_DEBUG:.o=.d)
-include $(OBJ_ASAN:.o=.d)

# ===== Run Program =====
.PHONY: run
run: release
	@echo "$(_WHITE)Running $(TARGET_RELEASE)...$(_NC)"
	@./$(TARGET_RELEASE)

# ===== Clean =====
.PHONY: clean fclean re
clean:
	@rm -rf obj
	@echo "$(_YELLOW)[-] Removed object files$(_NC)"

fclean: clean
	@rm -rf bin
	@echo "$(_RED)[x] Removed all executables$(_NC)"

re: fclean all
	@echo "$(_GREEN)[✔] Rebuild complete$(_NC)"

# ===== Phony target to prevent conflicts with files named 'Makefile' =====
.PHONY: Makefile

# ===== Beautify output =====
.PHONY: pretty
pretty:
	@echo "$(_CYAN)=============================$(_NC)"
	@echo "$(_CYAN) Building $(NAME) Project$(_NC)"
	@echo "$(_CYAN)=============================$(_NC)"

# ===== Show macro details =====
.PHONY: show
show:
	@printf "$(_BLUE)%s\n$(_WHITE)%s$(_NC)\n" "SRCFILES:"    "$(SRCFILES)"
	@printf "$(_BLUE)%s\n$(_WHITE)%s$(_NC)\n" "OBJ_RELEASE:" "$(OBJ_RELEASE)"
	@printf "$(_BLUE)%s\n$(_WHITE)%s$(_NC)\n" "OBJ_DEBUG:"   "$(OBJ_DEBUG)"
	@printf "$(_BLUE)%s\n$(_WHITE)%s$(_NC)\n" "OBJ_ASAN:"    "$(OBJ_ASAN)"
	@printf "\n"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "C Compiler:"       "$(CC)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CPP Compiler:"     "$(CXX)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CFLAGS_RELEASE:"   "$(CFLAGS_RELEASE)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CXXFLAGS_RELEASE:" "$(CXXFLAGS_RELEASE)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CFLAGS_DEBUG:"     "$(CFLAGS_DEBUG)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CXXFLAGS_DEBUG:"   "$(CXXFLAGS_DEBUG)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CFLAGS_ASAN:"      "$(CFLAGS_ASAN)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "CXXFLAGS_ASAN:"    "$(CXXFLAGS_ASAN)"
	@printf "$(_BLUE)%-20s $(_WHITE)%s$(_NC)\n" "IFLAGS:"           "$(IFLAGS)"

# ===== Valgrind (optional, debug only) =====
.PHONY: valgrind
valgrind: debug
	@echo "$(_YELLOW)Running Valgrind on debug build...$(_NC)"
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET_DEBUG)
