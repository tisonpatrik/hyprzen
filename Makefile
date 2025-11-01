.PHONY: apply
apply:
	@if command -v stow >/dev/null 2>&1; then \
		if [ -d "stow-dotfiles" ]; then \
			cd stow-dotfiles && stow -t $$HOME zsh ohmyposh fastfetch ghostty 2>/dev/null || true; \
			echo "Configuration applied"; \
		else \
			echo "stow-dotfiles directory not found"; \
		fi \
	else \
		echo "stow not found, skipping dotfile stowing"; \
	fi

.PHONY: clean
clean:
	@if command -v stow >/dev/null 2>&1; then \
		if [ -d "stow-dotfiles" ]; then \
			cd stow-dotfiles && stow -D -t $$HOME zsh ohmyposh fastfetch ghostty 2>/dev/null || true; \
			echo "Symlinks removed"; \
		fi \
	fi
	rm -f $$HOME/.zshrc
	rm -rf $$HOME/.config/zsh $$HOME/.config/ohmyposh $$HOME/.config/fastfetch $$HOME/.config/ghostty

.PHONY: restart
restart:
	@$(MAKE) clean
	@$(MAKE) apply
