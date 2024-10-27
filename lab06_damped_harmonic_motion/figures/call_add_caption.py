import sys
from pathlib import Path

# Add the formatting folder to the system path
formatting_path = Path("/home/kym/physics-326/formatting")
sys.path.insert(0, str(formatting_path))

# Import add_caption from add_captions.py
from add_captions import add_caption

# Define parameters for the captioning function
image_path = "/home/kym/physics-326/lab06_damped_harmonic_motion/figures/logAvsT.png"
caption_text = r"Figure 6. Plot of the natural logarithm of amplitude vs. time for damped oscillatory motion of a 500g mass with an added paper plate. The linear fit demonstrates the exponential decay of amplitude over time, characteristic of damped harmonic motion. The slope of the line provides an estimate of the damping coefficient gamma, indicating the rate of energy dissipation in the system."
output_path = "/home/kym/physics-326/lab06_damped_harmonic_motion/figures/fig6.png"

# Call the function to add the caption
add_caption(
    image_path=image_path,
    caption_text=caption_text,
    output_path=output_path,
    #font_path="DejaVuSerif.ttf",  # Adjust font if necessary
    font_size=11,
    padding=15
)
