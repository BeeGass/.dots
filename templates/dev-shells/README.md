# Development Shell Templates

This directory contains reusable Nix shell templates for different development scenarios.

## Usage

### Option 1: Direct Usage
Navigate to your project directory and run:

```bash
nix-shell /home/beegass/.dots/templates/dev-shells/<template-name>.nix
```

### Option 2: Copy to Project
Copy the template to your project as `shell.nix`:

```bash
cp /home/beegass/.dots/templates/dev-shells/ml-jax.nix ~/my-project/shell.nix
cd ~/my-project
nix-shell
```

### Option 3: Symlink
Create a symlink in your project:

```bash
ln -s /home/beegass/.dots/templates/dev-shells/ml-jax.nix ~/my-project/shell.nix
cd ~/my-project
nix-shell
```

## Available Templates

### `ml-jax.nix`
JAX/Flax ML development environment with CUDA support.

**Includes:**
- Python 3.11
- JAX, Flax, Optax, Orbax (installed via uv)
- CUDA toolkit and cuDNN
- Data science basics (numpy, pandas, matplotlib)
- Jupyter, IPython

**Best for:** JAX-based machine learning projects

### `ml-pytorch.nix`
PyTorch ML development environment with CUDA support.

**Includes:**
- Python 3.11
- PyTorch, torchvision, torchaudio
- CUDA toolkit and cuDNN
- Transformers, datasets, accelerate (installed via uv)
- Jupyter, IPython, TensorBoard

**Best for:** PyTorch-based deep learning projects

### `python-general.nix`
General Python development environment (lightweight).

**Includes:**
- Python 3.11
- Common utilities (requests, click, rich)
- Development tools (pytest, black, ruff, mypy)
- No ML dependencies

**Best for:** General Python applications, scripts, web services

## Customization

Feel free to modify these templates for your specific needs:

1. Add/remove packages in the `buildInputs` list
2. Modify the `shellHook` to add custom environment setup
3. Pin specific package versions if needed

## Package Management

All templates use `uv` for fast Python package management:

```bash
# Install packages
uv pip install package-name

# Install from requirements.txt
uv pip install -r requirements.txt

# Freeze current environment
uv pip freeze > requirements.txt
```

## CUDA Support

The ML templates automatically configure CUDA paths. Verify GPU access:

```bash
# For JAX
python -c 'import jax; print(jax.devices())'

# For PyTorch
python -c 'import torch; print(torch.cuda.is_available())'
```

## Tips

- These shells create a `.venv` virtual environment in your project
- The `.venv` directory is gitignore-friendly
- You can have different shells for different projects
- Shells are reproducible across machines with Nix
