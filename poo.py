from PIL import Image

def png_to_hex_string(image_path):
    # Open the image
    img = Image.open(image_path)

    # Get the dimensions of the image
    width, height = img.size

    # Define the background color string
    BACKGROUND_COLOR = "BACKGROUND_COLOR"

    # Initialize an empty list to store hex values
    hex_values = []

    # Loop through each pixel and get the hex value
    for y in range(height):
        for x in range(width):
            # Get the RGB or RGBA values of the pixel
            pixel_values = img.getpixel((x, y))
            if len(pixel_values) == 3:  # RGB image
                r, g, b = pixel_values
                hex_value = "0x{:02X}{:02X}{:02X}".format(r, g, b)
            elif len(pixel_values) == 4:  # RGBA image
                r, g, b, a = pixel_values
                hex_value = "0x{:02X}{:02X}{:02X}".format(r, g, b)
            else:
                raise ValueError("Unsupported pixel format")

            # Check for the background color (0x000000) and replace with the string
            if hex_value == "0x000000":
                hex_value = BACKGROUND_COLOR

            hex_values.append(hex_value)

    # Convert the list to a comma-separated string
    hex_string = ",".join(hex_values)

    return hex_string

if __name__ == "__main__":
    image_path = "exit.png"
    hex_string = png_to_hex_string(image_path)
    print(hex_string)
