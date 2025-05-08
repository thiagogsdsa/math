import numpy as np
import matplotlib.pyplot as plt

# Function to generate the Julia set
def julia_set(width, height, x_min, x_max, y_min, y_max, c, max_iter):
    # Generate x and y coordinates
    x, y = np.linspace(x_min, x_max, width), np.linspace(y_min, y_max, height)
    X, Y = np.meshgrid(x, y)

    # Initialize the fractal image
    img = np.zeros((height, width))

    # Calculate the Julia set
    for i in range(height):
        for j in range(width):
            zx, zy = X[i, j], Y[i, j]
            iteration = 0
            while zx*zx + zy*zy < 4 and iteration < max_iter:
                zx, zy = zx*zx - zy*zy + c[0], 2*zx*zy + c[1]
                iteration += 1
            img[i, j] = iteration

    return img

# Fractal parameters
width, height = 800, 800  # Image size
x_min, x_max = -2, 2      # x-axis range
y_min, y_max = -2, 2      # y-axis range
c = (-0.7, 0.27015)       # c parameter for the Julia set
max_iter = 256            # Maximum number of iterations

# Generate the fractal
img = julia_set(width, height, x_min, x_max, y_min, y_max, c, max_iter)

# Display the image
plt.imshow(img, cmap='inferno', extent=(x_min, x_max, y_min, y_max))
plt.colorbar()
plt.title("Julia Set Fractal")
plt.show()