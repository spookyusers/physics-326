from PIL import Image, ImageDraw, ImageFont

def add_caption(image_path, caption_text, output_path, font_path, font_size=12, padding=15):

    """
    Adds a scientific-style caption below an image, left-aligned, and saves the result.
    
    Parameters:
        image_path (str): Path to the input image.
        caption_text (str): Text of the caption to add.
        output_path (str): Path to save the output image with the caption.
        font_size (int): Font size for the caption.
        padding (int): Padding around the text and image.
    """
    # Load the image
    img = Image.open(image_path)

    # Use DejaVu Serif, which resembles Times New Roman
    try:
        font = ImageFont.truetype(font_path, font_size)
    except IOError:
        font = ImageFont.load_default()
        print(f"Font at {font_path} not found, using default font.")

    # Function to wrap text without splitting words
    def wrap_text(text, line_length, font):
        words = text.split()
        lines = []
        current_line = ""
        for word in words:
            if font.getlength(current_line + " " + word) <= line_length:
                current_line += " " + word if current_line else word
            else:
                lines.append(current_line)
                current_line = word
        if current_line:
            lines.append(current_line)
        return lines

    # Calculate max width for text lines
    max_line_width = img.width - 2 * padding
    lines = wrap_text(caption_text, max_line_width, font)

    # Calculate caption box height
    text_height = sum(font.getbbox(line)[3] - font.getbbox(line)[1] for line in lines) + (len(lines) - 1) * 5
    box_height = text_height + 2 * padding

    # Extend canvas for caption
    new_img_height = img.height + box_height + padding
    new_img = Image.new("RGB", (img.width, new_img_height), "white")
    new_img.paste(img, (0, 0))

    # Draw caption text, left-aligned
    draw = ImageDraw.Draw(new_img)
    text_y = img.height + padding
    for line in lines:
        text_x = padding  # Left-align by setting x position to padding
        draw.text((text_x, text_y), line, font=font, fill="black")
        text_y += font.getbbox(line)[3] - font.getbbox(line)[1] + 5

    # Save output image
    new_img.save(output_path)
    print(f"Image saved with caption at: {output_path}")
