import sys
from pathlib import Path

# Add the formatting folder to the system path
formatting_path = Path("/home/kym/physics-326/formatting")
sys.path.insert(0, str(formatting_path))

# Import add_caption from add_captions.py
from add_captions import add_caption

# Define parameters for the captioning function
image_path = "/home/kym/physics-326/lab06_damped_harmonic_motion/figures/massvdisplacementfit.png"
caption_text = r"Figure 2. Mass vs. Displacement with Linear Fit and Error Bars. Shows a proportional relationship between mass and displacement with spring constant (k)=21.206+-0.003 (N/m)."
output_path = "/home/kym/physics-326/lab06_damped_harmonic_motion/figures/fig1_massvdisplacement.png"

# Call the function to add the caption
add_caption(
    image_path=image_path,
    caption_text=caption_text,
    output_path=output_path,
    #font_path="DejaVuSerif.ttf",  # Adjust font if necessary
    font_size=11,
    padding=15
)
