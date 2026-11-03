import re, shutil
from pathlib import Path
from PIL import Image

images = Path("lib/images")
backup = Path("../hot_and_souly_original_images")
backup.mkdir(exist_ok=True)

for f in list(images.iterdir()):
    if f.suffix.lower() not in (".png", ".jpg", ".jpeg"):
        continue
    img = Image.open(f)
    img = img.convert("RGBA" if "A" in img.getbands() or img.mode == "P" else "RGB")
    max_w = 1920 if f.stem == "background" else 400 if "logo" in f.stem.lower() else 800
    if img.width > max_w:
        img = img.resize((max_w, round(img.height * max_w / img.width)), Image.LANCZOS)
    out = f.with_suffix(".webp")
    img.save(out, "WEBP", quality=72, method=6)
    print(f"{f.name}: {f.stat().st_size // 1024} KB  ->  {out.name}: {out.stat().st_size // 1024} KB")
    shutil.move(str(f), backup / f.name)

pattern = re.compile(r"(images/[\w\-]+)\.(png|jpe?g)", re.IGNORECASE)
for code in list(Path("lib").rglob("*.dart")) + [Path("pubspec.yaml")]:
    text = code.read_text(encoding="utf-8")
    new = pattern.sub(r"\1.webp", text)
    if new != text:
        code.write_text(new, encoding="utf-8")
        print(f"Updated names in {code}")

print("Done.")