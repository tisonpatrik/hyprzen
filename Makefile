.PHONY: apply clean restart

apply:
	@cd stow-dotfiles && stow --adopt -t $$HOME */

clean:
	@cd stow-dotfiles && stow -D -t $$HOME */

restart: clean apply
