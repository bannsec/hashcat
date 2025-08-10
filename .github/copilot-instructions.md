# HashCat Python Wrapper

HashCat is a Python pip installer wrapper around the hashcat password cracking tool. It downloads the latest hashcat binary (currently v7.0.0) from the official GitHub releases and provides a Python CLI wrapper that handles path issues and makes hashcat available via pip install.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Build
- Install required system dependencies:
  - `apt-get update && apt-get install -y python3 python3-pip p7zip-full wget`
  - Python 3.12+ is supported
- Build the package:
  - `./build.sh` -- takes 42 seconds. NEVER CANCEL. Set timeout to 120+ seconds.
  - Downloads latest hashcat from GitHub releases automatically
  - Creates both Linux and Windows wheel packages in `dist/`
- Install for development:
  - `python3 -m pip install -e .[dev]` -- installs development dependencies
  - Includes pytest, sphinx, coverage, twine for documentation and publishing

### Testing and Validation
- No unit tests exist in this repository (`pytest --collect-only` finds 0 tests)
- Manual validation commands:
  - `python3 -m pip install dist/*manylinux1*.whl` -- install built package
  - `hashcat --help` -- verify installation works
  - `hashcat --version` -- should show v7.0.0
- CRITICAL: Full hashcat functionality requires GPU/OpenCL drivers not available in container environments
- Basic CLI commands work but benchmarks/cracking will fail with "No OpenCL, Metal, HIP or CUDA installation found"
- Always test installation and basic help commands after building

### Development Workflow
- ALWAYS run `./build.sh` after making changes to verify package builds correctly
- Build warnings about package configuration are expected and not critical
- The repository structure is simple:
  - `setup.py` -- Python package configuration
  - `build.sh` -- Downloads hashcat and builds wheels
  - `hashcat/cli.py` -- Main wrapper script that proxies to hashcat binary
  - `hashcat/__init__.py` -- Empty package init
  - `MANIFEST.in` -- Includes hashcat binary and assets in package

## Validation Scenarios

ALWAYS run these validation steps after making any changes:
1. `rm -rf dist/ build/ *.egg-info` -- clean previous builds
2. `./build.sh` -- rebuild package (42 seconds, NEVER CANCEL)
3. `python3 -m pip install dist/*manylinux1*.whl` -- install package
4. `hashcat --help` -- verify CLI works
5. `hashcat --version` -- verify version is correct

## Key Project Information

### Repository Structure
```
.
├── .github/
│   └── workflows/pypi.yml    # CI/CD for PyPI publishing
├── build.sh                  # Main build script
├── setup.py                  # Python package configuration
├── hashcat/
│   ├── __init__.py          # Empty package init
│   └── cli.py               # Main wrapper script
├── MANIFEST.in              # Package data inclusion rules
├── version                  # Auto-generated version file
└── README.md               # Basic usage instructions
```

### Important Files and Locations
- `hashcat/cli.py` -- The main wrapper that handles path conversion and proxies to hashcat binary
- `build.sh` -- Downloads hashcat from GitHub releases and builds wheels
- `.github/workflows/pypi.yml` -- CI pipeline that builds and publishes to PyPI
- `setup.py` -- Defines entry point as `hashcat = hashcat.cli:main`
- `version` -- Auto-generated during build with format YY.MM.DD

### Build Process Details
The build script:
1. Downloads latest hashcat.7z from GitHub releases (currently v7.0.0)
2. Extracts to `hashcat/hashcat/` directory (excluded by .gitignore)
3. Generates version file with current date
4. Creates wheels for Linux (manylinux1_x86_64) and Windows (win_amd64)
5. Build typically takes 42 seconds, NEVER CANCEL

### Development Dependencies
Available via `pip install -e .[dev]`:
- pytest, pytest-cov, pytest-xdist -- testing framework (no tests exist currently)
- sphinx, sphinx_rtd_theme, sphinxcontrib-napoleon -- documentation
- twine -- PyPI publishing
- coverage -- code coverage analysis
- ipython -- interactive development

### CI/CD Pipeline
- Runs on Ubuntu 22.04
- Triggers on pushes to master and weekly schedule (Sunday 4AM)
- Builds both wheel types and publishes to PyPI
- Tests installation by running `hashcat --help`

## Common Tasks

### Building a Release
```bash
# Clean previous builds
rm -rf dist/ build/ *.egg-info

# Build new release (42 seconds, NEVER CANCEL)
./build.sh

# Verify build artifacts
ls -lah dist/
# Should show: hashcat-YY.M.DD-py3-none-manylinux1_x86_64.whl and win_amd64.whl
```

### Testing Installation
```bash
# Install from local build
python3 -m pip install dist/*manylinux1*.whl

# Test basic functionality
hashcat --help
hashcat --version

# Note: Full functionality requires GPU/OpenCL drivers
```

### Making Code Changes
1. Edit `hashcat/cli.py` (main wrapper) or `setup.py` (package config)
2. Run full validation scenario (see above)
3. Verify no functionality regression in basic CLI commands
4. Build warnings about package configuration are expected and safe to ignore

### Common Issues
- **"No OpenCL installation found"** -- Expected in container environments without GPU
- **Package configuration warnings** -- Expected due to downloaded hashcat binary structure
- **Build failures** -- Usually due to network issues downloading hashcat release
- **Import errors after changes** -- Reinstall package with `pip install -e .`

## Limitations
- Cannot fully test GPU-accelerated hashcat functionality in container environments
- No existing unit test suite (would need to be created for testing wrapper functionality)
- Package includes large binary files (~158MB wheels) 
- Requires internet connection during build to download latest hashcat
- Full hashcat features require OpenCL/CUDA runtime installation on target system