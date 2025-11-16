# JAX/Flax ML Development Environment
# Usage: nix-shell ml-jax.nix
#
# Provides:
# - Python 3.11 with JAX ecosystem (jax, flax, optax, orbax)
# - CUDA support for GPU acceleration
# - Common ML utilities

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python and core ML packages
    python311
    python311Packages.pip
    python311Packages.virtualenv
    uv  # Fast Python package manager

    # JAX ecosystem
    python311Packages.jax
    python311Packages.jaxlib
    # python311Packages.flax  # Add when available in nixpkgs
    # python311Packages.optax

    # Data science basics
    python311Packages.numpy
    python311Packages.pandas
    python311Packages.matplotlib
    python311Packages.scikit-learn

    # CUDA for GPU support
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
    export EXTRA_LDFLAGS="-L${pkgs.cudatoolkit}/lib"
    export EXTRA_CCFLAGS="-I${pkgs.cudatoolkit}/include"

    # Enable JAX GPU support
    export XLA_FLAGS="--xla_gpu_cuda_data_dir=${pkgs.cudatoolkit}"

    # Create virtual environment if it doesn't exist
    if [ ! -d .venv ]; then
      echo "Creating Python virtual environment..."
      uv venv .venv
    fi

    # Activate virtual environment
    source .venv/bin/activate

    # Install JAX ecosystem packages that might not be in nixpkgs
    echo "Installing additional packages with uv..."
    uv pip install --upgrade \
      jax[cuda12] \
      flax \
      optax \
      orbax-checkpoint \
      grain-nightly \
      fiddle

    echo "JAX ML development environment loaded"
    echo "GPU support: $(python -c 'import jax; print(jax.devices())')"
  '';
}
