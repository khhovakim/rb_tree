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
OBJDIR = obj
BINDIR = bin
TARGET = $(BINDIR)/$(NAME)

# ===== Source files =====
SRCFILES = $(shell find $(SRCDIR) -name "*.c" -o -name "*.cc" -o -name "*.cpp")

# ===== Include directories =====
INCDIRS  = $(shell find $(INCDIR) -type d)
IFLAGS   = $(foreach dir,$(INCDIRS),-I$(dir))

# ===== Object files =====
OBJFILES = \
	$(patsubst %.c,$(OBJDIR)/%.o,$(filter %.c,$(SRCFILES))) \
	$(patsubst %.cc,$(OBJDIR)/%.o,$(filter %.cc,$(SRCFILES))) \
	$(patsubst %.cpp,$(OBJDIR)/%.o,$(filter %.cpp,$(SRCFILES)))

# ===== Compilers =====
CC       = clang
CXX      = clang++

# ===== Flags =====
ifeq ($(DEBUG),1)
  CCFLAGS  = -std=c11   -Wall -Wextra -Werror -g -O0 -pedantic-errors -fsanitize=address
  CXXFLAGS = -std=c++17 -Wall -Wextra -Werror -g -O0 -pedantic-errors -fsanitize=address
else
  CCFLAGS  = -std=c11   -Wall -Wextra -Werror -O2 -DNDEBUG -pedantic-errors
  CXXFLAGS = -std=c++17 -Wall -Wextra -Werror -O2 -DNDEBUG -pedantic-errors
endif

DEPFLAGS = -MMD -MP

# ===== Makefile flags =====
MAKEFLAGS = --no-print-directory

# ===== Usage note =====
#   make          → Build in release mode
#   make DEBUG=1  → Build in debug mode
#   make -j[N]    → Parallel build

# ===== Default target =====
.PHONY: all
all: pretty $(TARGET)

# ===== Linking =====
$(TARGET): $(OBJFILES)
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$@ ...$(_NC)"
	@mkdir -p $(BINDIR)
	@$(CXX) $(CXXFLAGS) -o $@ $(OBJFILES)
	@echo "$(SUCCESS)\n$(_WHITE)Linked $@$(_NC)"

# ===== Generic object build rules =====
$(OBJDIR)/%.o: %.c Makefile
	@mkdir -p $(@D)
	@$(CC) $(CCFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@
	@echo "$(COMPILING) $(_WHITE)[CC] $< → $@$(_NC)"

$(OBJDIR)/%.o: %.cc Makefile
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@
	@echo "$(COMPILING) $(_WHITE)[CXX] $< → $@$(_NC)"

$(OBJDIR)/%.o: %.cpp Makefile
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@
	@echo "$(COMPILING) $(_WHITE)[CXX] $< → $@$(_NC)"

# ===== Auto-include dependency files =====
-include $(OBJFILES:.o=.d)

# ===== Run Program =====
.PHONY: run
run: $(TARGET)
	@./$(TARGET)

# ===== Clean object files only =====
.PHONY: clean
clean:
	@rm -rf $(OBJDIR)
	@echo "$(_YELLOW)[-] Removed object files$(_NC)"

# ===== Clean everything =====
.PHONY: fclean
fclean: clean
	@rm -f  $(TARGET)
	@rm -rf $(BINDIR)
	@echo "$(_RED)[x] Removed Executable $(TARGET)$(_NC)"

# ===== Rebuild everything =====
.PHONY: re
re: fclean all

# ===== Beautify output =====
.PHONY: pretty
pretty:
	@echo "$(_CYAN)=============================$(_NC)"
	@echo "$(_CYAN) Building $(NAME) Project$(_NC)"
	@echo "$(_CYAN)=============================$(_NC)"

# ===== Show macro details =====
.PHONY: show
show:
	@echo "$(_BLUE)SRCFILES:\t$(_YELLOW)$(SRCFILES)$(_NC)"
	@echo "$(_BLUE)OBJFILES:\t$(_YELLOW)$(OBJFILES)$(_NC)"
	@echo "$(_BLUE)Compilers:\t$(_YELLOW)$(CXX) $(CC)$(_NC)"
	@echo "$(_BLUE)CXXFLAGS:\t$(_YELLOW)$(CXXFLAGS)$(_NC)"
	@echo "$(_BLUE)CCFLAGS:\t$(_YELLOW)$(CCFLAGS)$(_NC)"
	@echo "$(_BLUE)IFLAGS:\t\t$(_YELLOW)$(IFLAGS)$(_NC)"

# ===== Valgrind (optional, debug only) =====
.PHONY: valgrind
valgrind: $(TARGET)
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET)
