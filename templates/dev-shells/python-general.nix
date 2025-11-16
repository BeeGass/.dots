# General Python Development Environment
# Usage: nix-shell python-general.nix
#
# Provides:
# - Python 3.11 with common development tools
# - No ML-specific packages (lightweight)
# - Fast package management with uv

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python
    python311
    python311Packages.pip
    python311Packages.virtualenv
    uv  # Fast Python package manager

    # Common libraries
    python311Packages.requests
    python311Packages.click
    python311Packages.rich  # Beautiful terminal output

    # Development tools
    python311Packages.ipython
    python311Packages.pytest
    python311Packages.black
    python311Packages.ruff
    python311Packages.mypy

    # System tools
    git
    gnumake
  ];

  shellHook = ''
    # Create virtual environment if needed
    if [ ! -d .venv ]; then
      echo "Creating Python virtual environment..."
      uv venv .venv
    fi

    source .venv/bin/activate

    echo "Python development environment loaded"
    echo "Python version: $(python --version)"
    echo "Use 'uv pip install <package>' for fast package installation"
  '';
}
