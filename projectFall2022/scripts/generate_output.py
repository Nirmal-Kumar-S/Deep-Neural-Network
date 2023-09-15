# # -*- coding: utf-8 -*-
# """
# Created on Mon Feb 21 00:01:53 2022

# @author: bitsf
# """


import numpy as np
import skimage.measure
import yaml
import sys


def convolution(image, kernel, padding = 0, stride = 1):
    kernel_height, kernel_width = kernel.shape
    image_height, image_width = image.shape

    
    H_out = 1+ int((image_height+2*padding - kernel_height)/stride)
    W_out = 1+ int((image_width+2*padding-kernel_width)/stride)
    
    out = np.zeros((H_out, W_out))
    
    for i in range(H_out):
        for j in range(W_out):
            out[i][j] = np.sum(image[i*stride:i+ kernel_height, j*stride:j + kernel_width ] * kernel)
    return out       
            

# APPLY RELU FUNCTION NOW
# arr = np.array(im,np.uint16)
# arr = arr.clip(-128,127)
# print(arr)
          
# ReLU function
def ReLU(x):    
    arr = np.clip(x, 0, 127)
    return arr


# pooling


def pooling(image):
    max_pool =  skimage.measure.block_reduce(image, (2,2), np.max)
    return max_pool

def fully_connected(weights, pooled):
             
    out = weights.dot(pooled)
    
    return out


# image = np.array(
#     [[8, 28, 5, 14, 13, 38, 15, 23, 32, 44, 34, 7, 32, 21, 28, 30], [9, 40, 9, 27, 33, 7, 0, 11, 22, 1, 20, 7, 37, 3, 4, 19], [24, 34, 5, 10, 29, 31, 34, 40, 41, 39, 3, 40, 40, 44, 23, 37], [2, 17, 12, 15, 0, 27, 6, 22, 37, 22, 21, 9, 43, 2, 27, 13], [13, 22, 7, 19, 42, 7, 27, 30, 43, 35, 12, 31, 41, 16, 41, 36], [17, 13, 44, 32, 0, 23, 30, 0, 13, 29, 29, 40, 33, 9, 16, 29], [20, 34, 20, 21, 7, 2, 27, 32, 26, 23, 9, 9, 31, 23, 27, 10], [32, 25, 6, 42, 6, 33, 11, 20, 34, 38, 4, 35, 10, 13, 17, 16], [3, 7, 39, 10, 39, 12, 26, 44, 9, 41, 9, 24, 13, 3, 7, 22], [17, 39, 18, 11, 19, 19, 12, 16, 29, 21, 5, 19, 37, 26, 7, 4], [5, 34, 10, 14, 35, 3, 7, 2, 41, 43, 13, 4, 16, 18, 40, 24], [2, 37, 32, 1, 35, 3, 11, 37, 27, 10, 11, 24, 33, 23, 15, 17], [34, 42, 16, 26, 16, 24, 19, 2, 41, 28, 38, 43, 4, 31, 9, 35], [17, 12, 6, 4, 17, 38, 41, 6, 3, 8, 20, 8, 0, 10, 19, 14], [5, 0, 12, 7, 29, 42, 38, 41, 27, 31, 38, 25, 44, 1, 41, 16], [34, 37, 24, 10, 5, 36, 30, 44, 13, 23, 18, 43, 1, 38, 28, 28]]
#     )


#kernel = np.array([[-1, 1, 0], [2, 3, 0], [-2, -2, -1]]) 

# weights = np.array(
# [[0, -1, 0, 2, 1, -1, 0], [0, 1, -1, -1, 2, -1, 1], [-1, 2, 1, 0, 1, -1, -2], [-2, 1, -1, 2, -2, 0, 1], [-1, 0, 0, -2, 1, 2, 1], [-2, 1, -1, 2, 1, -2, 1], [-1, 2, -1, -2, 2, 1, -1]]

# )


# image = np.array(
    
# [[10, 29, 20, 15, 30, 14, 0, 30], [16, 6, 0, 24, 5, 15, 26, 4], [20, 6, 20, 33, 10, 20, 1, 34], [26, 19, 23, 21, 18, 4, 33, 27], [9, 2, 13, 15, 7, 20, 1, 31], [19, 29, 17, 32, 32, 23, 31, 7], [18, 6, 32, 19, 6, 10, 28, 1], [9, 1, 6, 12, 15, 10, 8, 13]]    
    

# )

#weights = np.array(
    
#[[1, 3, 1, 1, -2, -1, -2], [-1, 1, -2, -2, 2, 2, 2], [0, -1, 0, -1, 3, 3, 1], [2, 0, 2, -1, -2, 0, 3], [3, -1, 1, 0, -1, 3, 1], [-2, 2, -1, -1, -2, 3, -1], [-1, 3, -1, -1, 0, -2, 1]]   

    
#)

#image = np.array(
    

#[[1, 8, 5, 4, 8, 9, 2, 8, 1, 0, 3, 7, 2, 5, 8, 0], [6, 3, 9, 4, 7, 6, 1, 9, 10, 10, 3, 7, 2, 0, 2, 9], [5, 9, 10, 11, 8, 0, 3, 3, 11, 7, 0, 1, 9, 6, 1, 10], [1, 7, 6, 1, 9, 4, 8, 8, 8, 8, 4, 3, 7, 6, 6, 0], [10, 8, 3, 1, 7, 3, 7, 4, 7, 9, 5, 11, 10, 0, 8, 9], [3, 5, 9, 1, 5, 8, 5, 8, 9, 4, 10, 0, 2, 7, 4, 8], [3, 11, 11, 8, 3, 5, 9, 11, 1, 3, 4, 5, 11, 7, 9, 5], [0, 11, 5, 10, 0, 6, 4, 1, 0, 8, 11, 9, 6, 6, 11, 11], [9, 2, 8, 11, 4, 5, 5, 9, 4, 2, 5, 9, 11, 11, 11, 10], [6, 2, 11, 3, 9, 1, 5, 7, 0, 0, 0, 1, 7, 11, 6, 7], [9, 6, 5, 9, 6, 1, 6, 1, 3, 8, 3, 11, 5, 7, 4, 4], [3, 5, 5, 11, 9, 7, 6, 3, 3, 0, 2, 9, 1, 10, 10, 6], [2, 2, 7, 7, 0, 2, 11, 6, 7, 6, 5, 8, 11, 3, 1, 2], [2, 5, 2, 9, 9, 0, 4, 1, 1, 5, 4, 9, 5, 3, 3, 11], [10, 6, 3, 1, 1, 4, 6, 10, 8, 2, 3, 0, 8, 2, 3, 1], [3, 10, 5, 10, 8, 4, 3, 6, 8, 2, 7, 11, 6, 2, 3, 4]]   

#    )

# weights = np.array(
    
# [[0, -2, -1, 1, 0, 1, 0, -1, 2, -1, 1, -1, -1, 1, -2], [0, 0, 0, 0, -2, 1, 1, 1, 1, 0, -2, -1, 2, -1, 1], [-2, -2, -2, 2, 1, 2, 1, -1, 0, -1, -1, 1, 0, -2, -2], [1, 1, 0, 2, 0, 1, 1, -2, -1, 0, -2, 2, 0, -2, 2], [-1, -2, 0, -1, 2, 1, 2, 0, 0, 0, 1, -1, -1, 0, 1], [-2, 2, 1, 0, 0, 2, 2, 0, 0, -1, -2, 0, -1, 1, 1], [2, 0, -1, -1, 2, 2, -1, 1, 0, 2, 1, 0, 0, 2, -2], [0, 2, 2, -2, 2, 1, -2, 1, 1, -2, -1, -1, 2, 2, -2], [2, 2, 1, 2, -1, -2, 1, -2, 0, -2, 0, 0, 2, 1, -2], [-1, -2, -2, 1, -1, -2, 1, 2, -2, 2, -2, 0, 1, 1, 0], [-2, 0, -2, -1, 2, 0, 2, -1, 1, 0, 2, -1, 0, 0, 2], [-1, -2, 0, 1, 0, 2, -1, 0, 1, 0, -1, 0, 1, 2, 1], [2, -2, -2, -2, -1, -2, -1, 0, 0, -1, -1, 1, 2, 2, 0], [1, 0, 1, -2, 2, -1, -1, 2, -2, 2, 2, -2, 2, 1, -1], [-2, -1, 1, 1, 0, -1, -2, 2, -2, -1, 2, 2, -1, 0, -1]]
    
#     )

if (__name__ == "__main__"):         
    images = []
    outputs = []
    weights = []

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    with open(input_file) as yf :
        yaml_data = yaml.safe_load(yf)
        for img in yaml_data['images'] :
            images.append(yaml_data["images"][img])
        for wgh in yaml_data['weights'] :
            weights.append(yaml_data["weights"][wgh])

    with open(output_file,'w') as yf :
        outputs = {}
        outputs["outputs"] = {}
        kernel = weights[0]
        for i in range(len(images)):
            conv_im = convolution(np.array(images[i]), np.array(kernel))
            relu_im= ReLU(conv_im)
            if("564" in output_file):
              im_pool = pooling(relu_im)
              fully_im = fully_connected(np.array(weights[i+1]), im_pool)
              fully_im_relu = ReLU(fully_im)
              outputs["outputs"]["output{}".format(i)] = fully_im_relu.astype(int).tolist()
            else:
              outputs["outputs"]["output{}".format(i)] = relu_im.astype(int).tolist()
              break
        yf.write(yaml.safe_dump(outputs))

# print(conv_im)
# print(relu_im)
# print(im_pool)
# print(fully_im)
#print(fully_im_relu)
