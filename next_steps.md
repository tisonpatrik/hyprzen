# Next Steps for Hyprzen Project

## Overview
The Hyprzen project currently uses shell-based scripts for installation and configuration of Hyprland dotfiles. To improve maintainability, add new features, and ensure robustness, the following enhancements are planned. This document outlines the transition to a Python/Ansible-based system, new functionalities, and installer improvements.

## 1. Transition from Shell to Python/Ansible
**Rationale**: Shell scripts are error-prone and hard to maintain. Python offers better structure, error handling, and testing, while Ansible provides idempotent configuration management.

**Steps**:
- Refactor `install.sh` into Python scripts using `subprocess` for shell operations and `click` for CLI interfaces.
- Integrate Ansible playbooks for system configuration (e.g., package installation, dotfile stowing).
- Migrate existing logic from `install/` scripts to Ansible roles for modularity.
- Benefits: Cross-platform compatibility, easier debugging, and automated testing.

## 2. Add OCR Screenshot Feature
**Description**: Enhance screenshot functionality with optical character recognition (OCR) for text extraction from images.

**Implementation**:
- Integrate Tesseract OCR into `bin/screenshot.sh` or a new Python wrapper.
- Add a flag (e.g., `--ocr`) to extract text and save/copy it alongside the image.
- Ensure Tesseract is installed via the new installer.
- Use case: Capture screenshots with searchable text for notes or automation.

## 3. Add Video Recording Feature
**Description**: Enable screen recording for tutorials, bug reports, or sharing.

**Implementation**:
- Use `wf-recorder` (Wayland-compatible) or `ffmpeg` for recording.
- Add a new script `bin/record.sh` or integrate into Hyprland keybinds (`hypr/keybinds.conf`).
- Support options for audio, region selection, and output formats (e.g., MP4).
- Keybind example: Bind to `SUPER + R` to start/stop recording.

## 4. Add Cheat Sheet for Keyboard Shortcuts
**Description**: Provide an easy way to view and reference Hyprland keybinds and other shortcuts.

**Implementation**:
- Create a Python script to parse `hypr/keybinds.conf` and generate a cheat sheet.
- Use `rofi` or a simple web page for display (e.g., via `python -m http.server`).
- Integrate into the installer to auto-generate/update the cheat sheet.
- Include custom shortcuts from other configs (e.g., `zsh/functions.zsh`).

## 5. Make a Proper Installer with Idempotency
**Description**: Redesign the installer to be robust, repeatable, and user-friendly.

**Implementation**:
- Develop a Python-based installer that checks system state before applying changes.
- Use Ansible's check mode for dry runs and ensure no duplicate operations (e.g., skip if packages are installed).
- Add features: Logging, rollback on failure, progress indicators, and dependency resolution.
- Update `install.sh` to invoke the new installer, maintaining backward compatibility.
- Test idempotency by running multiple times on clean/test environments.

## Conclusion and Timeline
These changes will modernize the project, adding powerful features while improving reliability. Estimated timeline:
- Month 1: Transition to Python/Ansible core.
- Month 2: Implement OCR, video recording, cheat sheet, and finalize installer.

Priorities: Start with the installer refactor, as it enables the others. Dependencies include Python, Ansible, and new packages (e.g., tesseract, wf-recorder).</content>
<parameter name="filePath">next_steps.md
