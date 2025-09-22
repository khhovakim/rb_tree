# ===========================
# Makefile for rb_tree project
# ===========================

# ===== Colors =====
_GREY   = \033[1;30m
_RED    = \033[1;31m
_GREEN  = \033[1;32m
_YELLOW = \033[1;33m
_BLUE   = \033[1;34m
_PURPLE = \033[1;35m
_CYAN   = \033[1;36m
_WHITE  = \033[1;37m
_NC     = \033[0m

SUCCESS   = $(_GREEN)SUCCESS[✔]$(_NC)
COMPILING = $(_BLUE)COMPILING[●]$(_NC)

# ===== Project =====
NAME = rb_tree
SRCDIR = src
INCDIR = include

# ===== Directories =====
OBJDIR = obj
BINDIR = bin

# ===== Compiler =====
CC = clang
CXX = clang++

# ===== Flags =====
FLAGS = -Wall -Wextra -Werror -pedantic-errors

CCFLAGS   = -std=c11   $(FLAGS)
CCXXFLAGS = -std=c++17 $(FLAGS)

CFLAGS_RELEASE   = $(CCFLAGS)   -O2 -DNDEBUG
CXXFLAGS_RELEASE = $(CCXXFLAGS) -O2 -DNDEBUG

CFLAGS_DEBUG     = $(CCFLAGS)   -g -O0
CXXFLAGS_DEBUG   = $(CCXXFLAGS) -g -O0

CFLAGS_ASAN      = $(CCFLAGS)   -g -O0 -fsanitize=address -fno-omit-frame-pointer
CXXFLAGS_ASAN    = $(CCXXFLAGS) -g -O0 -fsanitize=address -fno-omit-frame-pointer

DEPFLAGS = -MMD -MP

# ===== Source files =====
SRCFILES = $(shell find $(SRCDIR) -type f \( -name "*.c" -o -name "*.cc" -o -name "*.cpp" \))
INCDIRS  = $(shell find $(INCDIR) -type d)
IFLAGS   = $(foreach dir,$(INCDIRS),-I$(dir))

# ===== Object files =====
define MAKE_OBJ_LIST
$(patsubst %.c,$(OBJDIR)/$1/%.o,$(filter %.c,$(SRCFILES))) \
$(patsubst %.cc,$(OBJDIR)/$1/%.o,$(filter %.cc,$(SRCFILES))) \
$(patsubst %.cpp,$(OBJDIR)/$1/%.o,$(filter %.cpp,$(SRCFILES)))
endef

OBJ_RELEASE = $(call MAKE_OBJ_LIST,release)
OBJ_DEBUG   = $(call MAKE_OBJ_LIST,debug)
OBJ_ASAN    = $(call MAKE_OBJ_LIST,asan)

TARGET_RELEASE = $(BINDIR)/release/$(NAME)
TARGET_DEBUG   = $(BINDIR)/debug/$(NAME)
TARGET_ASAN    = $(BINDIR)/asan/$(NAME)

# ===== Default target =====
.PHONY: all
all: release

# ===== Build modes =====
.PHONY: release debug asan
release: CFLAGS=$(CFLAGS_RELEASE)
release: CXXFLAGS=$(CXXFLAGS_RELEASE)
release: $(TARGET_RELEASE)

debug: CFLAGS=$(CFLAGS_DEBUG)
debug: CXXFLAGS=$(CXXFLAGS_DEBUG)
debug: $(TARGET_DEBUG)

asan: CFLAGS=$(CFLAGS_ASAN)
asan: CXXFLAGS=$(CXXFLAGS_ASAN)
asan: $(TARGET_ASAN)

# ===== Linking =====
define LINK_RULE
$1: $2
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$(_NC)"
	@mkdir -p $$(@D)
	@$(CXX) $(CXXFLAGS) -o $$@ $2
	@echo "$(SUCCESS)\n$(_WHITE)Linked $$@"
endef

$(eval $(call LINK_RULE,$(TARGET_RELEASE),$(OBJ_RELEASE)))
$(eval $(call LINK_RULE,$(TARGET_DEBUG),$(OBJ_DEBUG)))
$(eval $(call LINK_RULE,$(TARGET_ASAN),$(OBJ_ASAN)))

# ===== Compile rules =====
define COMPILE_RULE
$(OBJDIR)/$1/%.o: %.c Makefile
	@mkdir -p $$(@D)
	@echo "$(COMPILING) $(_WHITE)[CC][$1] $$< → $$@$(_NC)"
	@$(CC) $$(CFLAGS) $(DEPFLAGS) $(IFLAGS) -c $$< -o $$@

$(OBJDIR)/$1/%.o: %.cc Makefile
	@mkdir -p $$(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][$1] $$< → $$@$(_NC)"
	@$(CXX) $$(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $$< -o $$@

$(OBJDIR)/$1/%.o: %.cpp Makefile
	@mkdir -p $$(@D)
	@echo "$(COMPILING) $(_WHITE)[CXX][$1] $$< → $$@$(_NC)"
	@$(CXX) $$(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $$< -o $$@
endef

$(eval $(call COMPILE_RULE,release))
$(eval $(call COMPILE_RULE,debug))
$(eval $(call COMPILE_RULE,asan))

# ===== Auto-include dependency files =====
-include $(OBJ_RELEASE:.o=.d)
-include $(OBJ_DEBUG:.o=.d)
-include $(OBJ_ASAN:.o=.d)

# ===== Run Program =====
.PHONY: run
run: release
	@echo "$(_WHITE)Running $(TARGET_RELEASE)...$(_NC)"
	@./$(TARGET_RELEASE)

# ===== Cleaning =====
.PHONY: clean fclean re
clean:
	@rm -rf $(OBJDIR)
	@echo "$(_YELLOW)[-] Removed object files$(_NC)"

fclean: clean
	@rm -rf $(BINDIR)
	@echo "$(_RED)[x] Removed executables$(_NC)"

re: fclean all
	@echo "$(_GREEN)[✔] Rebuild complete$(_NC)"

# ===== Show info =====

# PRINT: print a header (MSG1) in blue, then print each token of MSG2 on its own grey line prefixed with " -> "
# Args: $1 = header/title, $2 = space-separated list (or string) to print line-by-line
define PRINT
	MSG1=$$(echo "$1" | sed ':a;N;s/^\n*//;s/\n*$$//;ta'); \
	MSG2=$$(echo "$2" | sed ':a;N;s/^\n*//;s/\n*$$//;ta'); \
	printf "$(_BLUE)%s\n" "$$MSG1"; \
	echo "$$MSG2" | tr ' ' '\n' | while IFS= read -r line; do \
		[ -n "$$line" ] && printf "$(_GREY) -> $(_NC)%s\n" "$$line"; \
	done; \
	echo
endef

.PHONY: show
.PHONY: show_sources
.PHONY: show_release_objects
.PHONY: show_debug_objects
.PHONY: show_asan_objects
.PHONY: show_compilers
.PHONY: show_release_flags
.PHONY: show_debug_flags
.PHONY: show_asan_flags
.PHONY: show_includes
.PHONY: show_include_flags

show: show_src
show: show_release_obj
show: show_debug_obj
show: show_asan_obj
show: show_compilers
show: show_release_flags
show: show_debug_flags
show: show_asan_flags
show: show_includes
show: show_include_flags

show_src:
	@$(call PRINT,"Source Files:","$(SRCFILES)")

show_release_obj:
	@$(call PRINT,"Release Objects:","$(OBJ_RELEASE)")

show_debug_obj:
	@$(call PRINT,"Debug Objects:","$(OBJ_DEBUG)")

show_asan_obj:
	@$(call PRINT,"ASan Objects:","$(OBJ_ASAN)")

show_compilers:
	@$(call PRINT,"C Compilers:","$(CC)")
	@$(call PRINT,"C++ Compilers:","$(CXX)")

show_release_flags:
	@$(call PRINT,"Release CFlags:","$(CFLAGS_RELEASE)")
	@$(call PRINT,"Release CXXFlags:","$(CXXFLAGS_RELEASE)")

show_debug_flags:
	@$(call PRINT,"Debug CFlags:","$(CFLAGS_DEBUG)")
	@$(call PRINT,"Debug CXXFlags:","$(CXXFLAGS_DEBUG)")

show_asan_flags:
	@$(call PRINT,"ASan CFlags:","$(CFLAGS_ASAN)")
	@$(call PRINT,"ASan CXXFlags:","$(CXXFLAGS_ASAN)")

show_includes:
	@$(call PRINT,"Include Directories:","$(INCDIRS)")

show_include_flags:
	@$(call PRINT,"Include Flags:","$(IFLAGS)")

# ===== Beautify output =====
.PHONY: pretty
pretty:
	@echo "$(_CYAN)=============================$(_NC)"
	@echo "$(_CYAN) Building $(NAME) Project$(_NC)"
	@echo "$(_CYAN)=============================$(_NC)"

# ===== Valgrind =====
.PHONY: valgrind
valgrind: debug
	@echo "$(_YELLOW)Running Valgrind...$(_NC)"
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET_DEBUG)
