"""
A comprehensive tutorial towards 2D convolution and image filtering
(The first step to understand Convolutional Neural Networks (CNNs)).
"""
import os
import cv2
import numpy as np
import struct
IMAGES_PATH = 'images/'

def load_image(image_path):
    """
    Load the image using opencv
    :param image_path: <String> Path of input_image
    :return a numpy array of size [image_height, image_width]
    """
    # Create the Image directory to save any plots
    if not os.path.exists(IMAGES_PATH):
        os.makedirs(IMAGES_PATH)
    coloured_image = cv2.imread(image_path)
    grey_image = cv2.cvtColor(coloured_image, cv2.COLOR_BGR2GRAY)
    # print('image matrix size: ', grey_image.shape)
    # print('\n First 5 columns and rows of the image matrix: \n', grey_image[:5, :5])
    # cv2.imwrite('TopLeft5x5.jpg', grey_image[:5, :5])
    return grey_image


def convolve2d(image, kernel):
    """
    This function which takes an image and a kernel and returns the convolution of them.

    :param image: a numpy array of size [image_height, image_width].
    :param kernel: a numpy array of size [kernel_height, kernel_width].
    :return: a numpy array of size [image_height, image_width] (convolution output).
    """
    # Flip the kernel
    kernel = np.flipud(np.fliplr(kernel))
    # convolution output
    output = np.zeros_like(image)

    # Add zero padding to the input image
    image_padded = np.zeros((image.shape[0] + 2, image.shape[1] + 2))
    image_padded[1:-1, 1:-1] = image

    # Loop over every pixel of the image
    for x in range(image.shape[1]):
        for y in range(image.shape[0]):
            # element-wise multiplication of the kernel and the image
            output[y, x] = (kernel * image_padded[y: y+3, x: x+3]).sum()

    return output


def approximate(arr,m):
    for i in range(len(arr)):
        for j in range(len(arr[i])):
            a = int(arr[i][j]*1000)
            k = (a//2**m)*(2**m)
            arr[i][j] = k/1000
    return arr






input_image = load_image('input_image.jpg')

# kernel to be used to get sharpened image

# kernel to be used for edge detection
k = np.array([[1, 2, 1], [2, 4, 2], [1, 2, 1]])/16.0
# image_sharpen = convolve2d(input_image, kernel=KERNEL)
# cv2.imwrite(IMAGES_PATH + 'approx_image.jpg', image_sharpen)
imagegaussianblur = convolve2d(input_image, kernel=k)
cv2.imwrite(IMAGES_PATH + 'gaussian_blur.jpg', imagegaussianblur)
# print(k)
# print(approximate(k))
for i in range(1,8):
    imagegaussianblur = convolve2d(input_image, kernel=approximate(k,i))
    cv2.imwrite(IMAGES_PATH + 'approx_blur'+str(i)+'.jpg', imagegaussianblur)