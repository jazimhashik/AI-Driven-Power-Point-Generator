"""
install_fonts.py
================
Downloads Google Fonts used by the PPT generator and installs them into
the current Windows user's font directory so:
  1) python-pptx writes the real font name in the PPTX.
  2) PowerPoint can render them without substitution.

Usage:
    python install_fonts.py          # install all fonts
    python install_fonts.py --check  # only list missing fonts

Safe to run multiple times -- skips fonts already installed.
"""

import os
import sys
import re
import shutil
import ctypes
import urllib.request
import urllib.error

# ──────────────────────────────────────────────────────────────────────────────
# Google Font families to install.
# "github" entries are raw.githubusercontent.com paths (static or variable TTF).
# If none of the "github" URLs work we fall back to the Google CSS API which
# returns direct gstatic download URLs for any font+weight combination.
# ──────────────────────────────────────────────────────────────────────────────

GITHUB_RAW = "https://raw.githubusercontent.com/google/fonts/main"

GOOGLE_FONTS = {
    # ── Only STATIC ttf fonts (no variable fonts) ──
    # Variable fonts are removed because PowerPoint does not render them reliably.
    "Poppins": {
        "github": [
            "{GITHUB}/ofl/poppins/Poppins-Regular.ttf",
            "{GITHUB}/ofl/poppins/Poppins-Medium.ttf",
            "{GITHUB}/ofl/poppins/Poppins-SemiBold.ttf",
            "{GITHUB}/ofl/poppins/Poppins-Bold.ttf",
            "{GITHUB}/ofl/poppins/Poppins-Light.ttf",
            "{GITHUB}/ofl/poppins/Poppins-Italic.ttf",
        ],
    },
    "Lato": {
        "github": [
            "{GITHUB}/ofl/lato/Lato-Regular.ttf",
            "{GITHUB}/ofl/lato/Lato-Bold.ttf",
            "{GITHUB}/ofl/lato/Lato-Italic.ttf",
            "{GITHUB}/ofl/lato/Lato-Light.ttf",
        ],
    },
    "Fira Sans": {
        "github": [
            "{GITHUB}/ofl/firasans/FiraSans-Regular.ttf",
            "{GITHUB}/ofl/firasans/FiraSans-Medium.ttf",
            "{GITHUB}/ofl/firasans/FiraSans-SemiBold.ttf",
            "{GITHUB}/ofl/firasans/FiraSans-Bold.ttf",
            "{GITHUB}/ofl/firasans/FiraSans-Light.ttf",
            "{GITHUB}/ofl/firasans/FiraSans-Italic.ttf",
        ],
    },
    "Barlow": {
        "github": [
            "{GITHUB}/ofl/barlow/Barlow-Regular.ttf",
            "{GITHUB}/ofl/barlow/Barlow-Medium.ttf",
            "{GITHUB}/ofl/barlow/Barlow-SemiBold.ttf",
            "{GITHUB}/ofl/barlow/Barlow-Bold.ttf",
            "{GITHUB}/ofl/barlow/Barlow-Light.ttf",
            "{GITHUB}/ofl/barlow/Barlow-Italic.ttf",
        ],
    },
    "PT Sans": {
        "github": [
            "{GITHUB}/ofl/ptsans/PT_Sans-Web-Regular.ttf",
            "{GITHUB}/ofl/ptsans/PT_Sans-Web-Bold.ttf",
            "{GITHUB}/ofl/ptsans/PT_Sans-Web-Italic.ttf",
            "{GITHUB}/ofl/ptsans/PT_Sans-Web-BoldItalic.ttf",
        ],
    },
    "PT Serif": {
        "github": [
            "{GITHUB}/ofl/ptserif/PT_Serif-Web-Regular.ttf",
            "{GITHUB}/ofl/ptserif/PT_Serif-Web-Bold.ttf",
            "{GITHUB}/ofl/ptserif/PT_Serif-Web-Italic.ttf",
            "{GITHUB}/ofl/ptserif/PT_Serif-Web-BoldItalic.ttf",
        ],
    },

    # Ubuntu - available via Google CSS API (static)
    "Ubuntu": {
        "github": [],
        "css_weights": "300;400;500;700",
    },
}

# ──────────────────────────────────────────────────────────────────────────────
# Windows directories
# ──────────────────────────────────────────────────────────────────────────────
USER_FONT_DIR = os.path.join(
    os.environ.get("LOCALAPPDATA", ""), "Microsoft", "Windows", "Fonts"
)
SYSTEM_FONT_DIR = os.path.join(os.environ.get("WINDIR", r"C:\Windows"), "Fonts")

# Google Fonts CSS2 API  (requesting TTF via old IE user-agent)
GFONTS_CSS_URL = "https://fonts.googleapis.com/css2?family={family}:wght@{weights}"
CSS_USER_AGENT = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)"


# ──────────────────────────────────────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────────────────────────────────────

def _get_installed_font_names():
    installed = set()
    for d in (SYSTEM_FONT_DIR, USER_FONT_DIR):
        if os.path.isdir(d):
            for f in os.listdir(d):
                if f.lower().endswith((".ttf", ".otf")):
                    installed.add(f.lower())
    return installed


def is_font_family_installed(family_name):
    """Check if at least one VALID variant of the family is on disk."""
    base = family_name.replace(" ", "").lower()
    # Also check common aliases
    aliases = [base]
    if family_name == "Source Sans 3":
        aliases.append("sourcesanspro")
    elif family_name == "Source Sans Pro":
        aliases.append("sourcesans3")
    for d in (SYSTEM_FONT_DIR, USER_FONT_DIR):
        if not os.path.isdir(d):
            continue
        for f in os.listdir(d):
            if not f.lower().endswith((".ttf", ".otf")):
                continue
            clean = f.replace("-", "").replace("_", "").lower()
            for alias in aliases:
                if alias in clean:
                    # Verify the file is actually a valid font
                    fpath = os.path.join(d, f)
                    if _is_valid_font_file(fpath):
                        return True
    return False


_VALID_TTF_HEADERS = (
    b'\x00\x01\x00\x00',  # TrueType
    b'true',              # TrueType (Apple)
    b'OTTO',              # OpenType with CFF
)


def _is_valid_font_file(path):
    """Check if a file is a valid TTF/OTF font (not HTML or corrupt)."""
    try:
        if os.path.getsize(path) < 100:
            return False
        with open(path, 'rb') as f:
            hdr = f.read(4)
        return hdr in _VALID_TTF_HEADERS
    except OSError:
        return False


def _download(url, dest_path):
    """Download a URL to dest_path. Returns True on success."""
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            if resp.status != 200:
                return False
            with open(dest_path, "wb") as f:
                shutil.copyfileobj(resp, f)
            # Verify it's a valid font file (not HTML error page or corrupt data)
            if not _is_valid_font_file(dest_path):
                os.remove(dest_path)
                return False
        return True
    except (urllib.error.URLError, urllib.error.HTTPError, OSError):
        if os.path.exists(dest_path):
            os.remove(dest_path)
        return False


def _register_font(font_path):
    """Register font with Windows + persist in user registry."""
    try:
        gdi32 = ctypes.windll.gdi32
        result = gdi32.AddFontResourceW(font_path)
        if result > 0:
            ctypes.windll.user32.SendMessageW(0xFFFF, 0x001D, 0, 0)
    except Exception:
        pass
    try:
        import winreg
        fname = os.path.basename(font_path)
        font_label = os.path.splitext(fname)[0].replace("-", " ") + " (TrueType)"
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts",
            0, winreg.KEY_SET_VALUE,
        )
        winreg.SetValueEx(key, font_label, 0, winreg.REG_SZ, font_path)
        winreg.CloseKey(key)
    except Exception:
        pass


def _install_file(src_path, dest_name=None):
    """Copy a font file to USER_FONT_DIR and register it. Returns True if newly installed.
    Replaces existing file if it is corrupt."""
    os.makedirs(USER_FONT_DIR, exist_ok=True)
    fname = dest_name or os.path.basename(src_path)
    dest = os.path.join(USER_FONT_DIR, fname)
    if os.path.exists(dest):
        if _is_valid_font_file(dest):
            return False  # Already installed and valid
        # Existing file is corrupt — replace it
        os.remove(dest)
    shutil.copy2(src_path, dest)
    _register_font(dest)
    return True


# ──────────────────────────────────────────────────────────────────────────────
# Google CSS API fallback
# ──────────────────────────────────────────────────────────────────────────────

def _download_via_css_api(family_name, weights="400;700"):
    """Use Google Fonts CSS2 API to get direct font URLs and download them.
    Handles TTF, WOFF, and EOT → converts everything to TTF.
    Returns list of downloaded TTF file paths in a temp location."""
    import tempfile
    tmpdir = tempfile.mkdtemp(prefix="gfonts_")
    files = []

    # Try multiple user-agents: Chrome 36 gives WOFF, IE8 gives EOT/TTF
    user_agents = [
        ("Mozilla/5.0 (Windows NT 6.3) AppleWebKit/537.36 Chrome/36.0.1985.143", "woff"),
        ("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)", "eot_or_ttf"),
    ]

    for ua, _label in user_agents:
        if files:
            break  # Already got fonts from a previous UA
        try:
            url = GFONTS_CSS_URL.format(
                family=family_name.replace(" ", "+"),
                weights=weights,
            )
            req = urllib.request.Request(url, headers={"User-Agent": ua})
            resp = urllib.request.urlopen(req, timeout=15)
            css = resp.read().decode("utf-8", errors="replace")

            font_urls = re.findall(r'url\((https://[^)]+)\)', css)
            weight_list = re.findall(r'font-weight:\s*(\d+)', css)

            base_name = family_name.replace(" ", "")
            weight_names = {"300": "Light", "400": "Regular", "500": "Medium",
                            "600": "SemiBold", "700": "Bold", "800": "ExtraBold"}

            for i, furl in enumerate(font_urls):
                w = weight_list[i] if i < len(weight_list) else str(400 + i * 100)
                wname = weight_names.get(w, f"w{w}")
                raw_path = os.path.join(tmpdir, f"{base_name}-{wname}.raw")
                ttf_path = os.path.join(tmpdir, f"{base_name}-{wname}.ttf")

                if not _download(furl, raw_path):
                    # _download validates TTF header — if file is not TTF it's
                    # rejected. Try downloading without validation and convert.
                    try:
                        req2 = urllib.request.Request(furl, headers={"User-Agent": "Mozilla/5.0"})
                        data = urllib.request.urlopen(req2, timeout=30).read()
                        with open(raw_path, "wb") as f:
                            f.write(data)
                    except Exception:
                        continue

                # Check if it's already valid TTF
                if _is_valid_font_file(raw_path):
                    os.rename(raw_path, ttf_path)
                    files.append(ttf_path)
                    continue

                # Try converting WOFF/WOFF2/EOT → TTF using fontTools
                try:
                    from fontTools.ttLib import TTFont
                    font = TTFont(raw_path)
                    font.flavor = None  # Remove WOFF wrapper
                    font.save(ttf_path)
                    font.close()
                    if _is_valid_font_file(ttf_path):
                        files.append(ttf_path)
                    else:
                        os.remove(ttf_path)
                except Exception:
                    pass
                # Clean up raw file
                if os.path.exists(raw_path):
                    os.remove(raw_path)

        except Exception as e:
            print(f"    CSS API ({_label}) error for {family_name}: {e}")

    return files, tmpdir


# ──────────────────────────────────────────────────────────────────────────────
# Main install logic
# ──────────────────────────────────────────────────────────────────────────────

def install_font_family(family_name, info, quiet=False):
    """Download & install a font family. Returns number of newly installed files."""
    import tempfile
    count = 0

    # --- Strategy 1: GitHub raw URLs ---
    github_urls = info.get("github", [])
    rename_map = info.get("rename", {})

    if github_urls:
        tmpdir = tempfile.mkdtemp(prefix="gfonts_gh_")
        try:
            for raw_url in github_urls:
                url = raw_url.replace("{GITHUB}", GITHUB_RAW)
                # Filename from URL (decoded)
                url_fname = urllib.request.url2pathname(url.rsplit("/", 1)[-1])
                # Use rename map if available
                dest_name = rename_map.get(url.rsplit("/", 1)[-1], url_fname)
                
                tmp_path = os.path.join(tmpdir, dest_name)
                if _download(url, tmp_path):
                    if _install_file(tmp_path, dest_name):
                        count += 1
                    else:
                        count += 1  # Already present counts as success
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)

        if count > 0:
            return count

    # --- Strategy 2: Google CSS API fallback ---
    css_weights = info.get("css_weights", "300;400;500;600;700")
    files, tmpdir = _download_via_css_api(family_name, css_weights)
    try:
        for fpath in files:
            if _install_file(fpath):
                count += 1
            else:
                count += 1  # Already present
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

    return count


def install_all_fonts(quiet=False):
    """Install all fonts. Returns summary dict."""
    results = {"installed": 0, "skipped": 0, "failed": 0, "families_installed": []}

    for family_name, info in GOOGLE_FONTS.items():
        if is_font_family_installed(family_name):
            if not quiet:
                print(f"  [OK] {family_name} - already installed")
            results["skipped"] += 1
            continue

        if not quiet:
            print(f"  [DL] {family_name}...", end=" ", flush=True)

        count = install_font_family(family_name, info, quiet=quiet)
        if count > 0:
            if not quiet:
                print(f"done ({count} files)")
            results["installed"] += count
            results["families_installed"].append(family_name)
        else:
            if not quiet:
                print("FAILED")
            results["failed"] += 1

    return results


def check_fonts():
    """Print installed / missing status."""
    missing, installed = [], []
    for family_name in GOOGLE_FONTS:
        (installed if is_font_family_installed(family_name) else missing).append(family_name)

    print(f"\n  Installed ({len(installed)}):")
    for f in installed:
        print(f"    [OK] {f}")
    if missing:
        print(f"\n  Missing ({len(missing)}):")
        for f in missing:
            print(f"    [X]  {f}")
        print(f"\n  Run  python install_fonts.py  to install missing fonts.\n")
    else:
        print("\n  All fonts are installed!\n")
    return missing


def ensure_fonts_installed(quiet=True):
    """Called from app.py at startup."""
    missing = [f for f in GOOGLE_FONTS if not is_font_family_installed(f)]
    if not missing:
        if not quiet:
            print("[Fonts] All Google Fonts already installed.")
        return
    print(f"[Fonts] {len(missing)} font families missing, installing...")
    results = install_all_fonts(quiet=quiet)
    if results["families_installed"]:
        print(f"[Fonts] Newly installed: {', '.join(results['families_installed'])}")
    if results["failed"]:
        print(f"[Fonts] {results['failed']} families could not be downloaded (will retry next start)")
    print("[Fonts] Done.")


# ──────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("=" * 56)
    print("  Google Fonts Installer for PPT Generator")
    print("=" * 56)

    if "--check" in sys.argv:
        check_fonts()
    elif "--validate" in sys.argv:
        # Check all installed font files are valid
        print(f"\n  Validating font files in {USER_FONT_DIR}\n")
        bad = []
        for f in sorted(os.listdir(USER_FONT_DIR)):
            if not f.lower().endswith((".ttf", ".otf")):
                continue
            path = os.path.join(USER_FONT_DIR, f)
            if _is_valid_font_file(path):
                print(f"    [OK] {f}")
            else:
                print(f"    [BAD] {f} — will be replaced on next install")
                bad.append(f)
        if bad:
            print(f"\n  {len(bad)} corrupt file(s) found. Run 'python install_fonts.py' to fix.\n")
        else:
            print("\n  All font files are valid!\n")
    elif "--register" in sys.argv:
        # Re-register all installed fonts without re-downloading
        print(f"\n  Re-registering all fonts in {USER_FONT_DIR}\n")
        count = 0
        for f in sorted(os.listdir(USER_FONT_DIR)):
            if not f.lower().endswith((".ttf", ".otf")):
                continue
            path = os.path.join(USER_FONT_DIR, f)
            if _is_valid_font_file(path):
                _register_font(path)
                count += 1
                print(f"    [REG] {f}")
        print(f"\n  Registered {count} font(s).\n")
    else:
        print(f"\n  Target: {USER_FONT_DIR}\n")
        results = install_all_fonts(quiet=False)
        print(f"\n  Summary: {results['installed']} files installed, "
              f"{results['skipped']} already present, "
              f"{results['failed']} failed\n")
