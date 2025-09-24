#!/usr/bin/env python3
import sys, json
from pathlib import Path
try:
    from PIL import Image
except ImportError:
    print("pip install Pillow")
    sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 extract_colors.py <wallpaper>")
        sys.exit(1)
    
    image = Image.open(sys.argv[1]).convert("RGB")
    image = image.resize((50, 50))
    pixels = list(image.getdata())
    
    colors = {}
    for r, g, b in pixels:
        key = (r//32*32, g//32*32, b//32*32)
        colors[key] = colors.get(key, 0) + 1
    
    top = sorted(colors.items(), key=lambda x: x[1], reverse=True)[:8]
    sorted_colors = sorted([c[0] for c in top], key=lambda c: sum(c)/3)
    
    scheme = {
        "bg": f"#{sorted_colors[0][0]:02x}{sorted_colors[0][1]:02x}{sorted_colors[0][2]:02x}",
        "fg": f"#{sorted_colors[-1][0]:02x}{sorted_colors[-1][1]:02x}{sorted_colors[-1][2]:02x}"
    }
    
    Path("themes").mkdir(exist_ok=True)
    with open("themes/colors.json", "w") as f:
        json.dump(scheme, f, indent=2)
    print("Colors:", scheme)

if __name__ == "__main__":
    main()
