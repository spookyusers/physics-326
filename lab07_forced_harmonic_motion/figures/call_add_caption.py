import sys
from pathlib import Path

# Add the formatting folder to the system path
formatting_path = Path("/home/kym/physics-326/formatting")
sys.path.insert(0, str(formatting_path))

# Import add_caption function directly from the add_captions module
try:
    from add_captions import add_caption
except ImportError:
    raise ImportError("Could not import add_caption from add_captions module. Ensure add_captions.py is located in the formatting folder.")


# Define parameters for the captioning function
image_path = "/home/kym/physics-326/lab07_forced_harmonic_motion/figures/experimental_setup_lab07.png"
caption_text = r"Figure 1. Experimental setup. Rotating lever arm drives the motion of a damped spring-mass system. Ultrasonic position sensor below and rotary motion sensor above measure data for analysis."
output_path = "/home/kym/physics-326/lab07_forced_harmonic_motion/figures/fig1.png"
font_path = "/home/kym/fonts/dejavu-serif/DejaVuSerif-Italic.ttf"

# Call the function to add the caption
add_caption(
    image_path=image_path,
    caption_text=caption_text,
    output_path=output_path,
    font_path=font_path,  # Adjust font if necessary
    font_size=14,
    padding=15
)
