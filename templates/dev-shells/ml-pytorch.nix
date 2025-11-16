# PyTorch ML Development Environment
# Usage: nix-shell ml-pytorch.nix
#
# Provides:
# - Python 3.11 with PyTorch and CUDA support
# - Common deep learning libraries
# - Development tools

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python
    python311
    python311Packages.pip
    python311Packages.virtualenv
    uv

    # PyTorch (with CUDA)
    python311Packages.torch
    python311Packages.torchvision
    python311Packages.torchaudio

    # ML utilities
    python311Packages.numpy
    python311Packages.pandas
    python311Packages.matplotlib
    python311Packages.scikit-learn
    python311Packages.tensorboard

    # CUDA
    cudatoolkit
    cudnn

    # Development tools
    python311Packages.ipython
    python311Packages.jupyter
    python311Packages.black
    python311Packages.ruff

    # System libraries
    zlib
    stdenv.cc.cc.lib
  ];

  shellHook = ''
    # Set CUDA paths
    export CUDA_PATH=${pkgs.cudatoolkit}
    export LD_LIBRARY_PATH=${pkgs.cudatoolkit}/lib:${pkgs.cudnn}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH

    # Create virtual environment if needed
    if [ ! -d .venv ]; then
      echo "Creating Python virtual environment..."
      uv venv .venv
    fi

    source .venv/bin/activate

    # Install additional packages
    echo "Installing additional packages with uv..."
    uv pip install --upgrade \
      transformers \
      datasets \
      accelerate \
      wandb

    echo "PyTorch ML development environment loaded"
    echo "PyTorch version: $(python -c 'import torch; print(torch.__version__)')"
    echo "CUDA available: $(python -c 'import torch; print(torch.cuda.is_available())')"
  '';
}
