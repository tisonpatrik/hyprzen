.PHONY: apply clean restart

apply:
	@cd stow-dotfiles && stow -t $$HOME */

clean:
	@cd stow-dotfiles && stow -D -t $$HOME */

restart: clean apply
