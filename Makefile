# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vde-frei <vde-frei@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/17 10:03:10 by vde-frei          #+#    #+#              #
#    Updated: 2023/11/12 14:34:43 by vde-frei         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# program name #
NAME = pipex

# shell #
SHELL := /bin/bash

# misc #
COUNT := 0
SLEEP := sleep 0.2

# colors #
BLACK  		 = \033[0;30m
RED    		 = \033[0;31m
GREEN  		 = \033[0;32m
YELLOW 		 = \033[0;33m
BLUE   		 = \033[0;34m
MAGENTA		 = \033[0;35m
CYAN   		 = \033[0;36m
WHITE  		 = \033[0;37m
RESET  		 = \033[0m

# functions #
define eraseBins
	$(if $(NAME),@$(RM) $(NAME))
	$(if $(BLIBNAME),@$(RM) $(BLIBNAME))
endef

# messages #
MANDATORY = Program compiled
LBONUS = Bonus Program compiled
CLEAN = Objects delete
FCLEAN = Program delete
LIBNAME = pipex
BLIBNAME = pipex_bonus
COMP = Compiling

# debbug and normal flags #
DFLAGS = -Wall -Wextra -Werror -g3 # TO DEBBUG
CFLAGS = -Wall -Werror -Wextra -g3 -O3 -fomit-frame-pointer -finline-functions # TO IMPROVE PERFORMANCE

# paths #
SRC = src
BONUS = src/bonus
INC = includes
OBJ = obj

# libs #
INCLUDES = -I$(INC)/ -Ilib/libft/includes/
LINCLUDES = -L$(LIBFT_PATH) -lft

LIBFT = lib/libft/libft.a
LIBFT_PATH = lib/libft

# files #
CFILES = $(addprefix $(SRC)/, main.c string.c errors.c)

BFILES = $(addprefix $(BONUS)/, main_bonus.c string_bonus.c errors_bonus.c \
child_bonus.c heredoc_bonus.c)

# obj dir #
OBJECT =  $(patsubst %, $(OBJ)/%, $(notdir $(CFILES:.c=.o)))

# define bonus #
ifdef WITH_BONUS
	NAME = $(BLIBNAME)
	CFILES = $(BFILES)
	SRC = $(BONUS)
	MANDATORY = $(LBONUS)
	MAGENTA = $(YELLOW)
	LIBNAME = $(BLIBNAME)
endif

# define debbug #
ifdef WITH_DEBBUG
	CFLAGS = $(DFLAGS)
endif

# rules #
all: $(OBJ) $(NAME)

$(NAME): $(OBJECT)
	@$(MAKE) -sC $(LIBFT_PATH)
	@$(CC) $(CFLAGS) $(INCLUDES) $(LINCLUDES) $(OBJECT) $(LIBFT) -o $(NAME)
	@$(SLEEP)
	@printf "\n$(MAGENTA)$(MANDATORY)\n$(RESET)"

$(OBJ):
	@mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.c
	@$(eval COUNT=$(shell expr $(COUNT) + 1))
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	@printf "$(GREEN)$(LIBNAME) $(COMP) %d%%\r$(RESET)" $$(echo $$(($(COUNT) * 100 / $(words $(CFILES)))))

clean:
	@$(MAKE) fclean -sC $(LIBFT_PATH)
	@$(RM) -rf $(OBJ)/
	@$(SLEEP)
	@printf "$(RED)$(CLEAN)$(RESET)\n"

fclean: clean
	$(call eraseBins)
	@$(SLEEP)
	@printf "$(RED)$(FCLEAN)$(RESET)\n"

re: fclean all

bonus:
	@make WITH_BONUS=TRUE --no-print-directory

debbug:
	@make WITH_DEBBUG=TRUE --no-print-directory

.PHONY: all bonus clean fclean re debbug
