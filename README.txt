# Tip
Repository for the Tour Into the Picture (TIP) project of the Computer Vision Class in the Summer Semester 2022. Written in Matlab. <br>
In this project, we try to take a "tour" into a 2D image with the help of a spidery mesh. The spidery mesh is defined as the 2D figure consisting of: 
a vanishing point; and an inner rectangle, which represents the window out of which we look at infinity; radial lines that radiate from the vanishing point; 
an outer rectangle which corresponds to the outer frame of the input image. We basically map a 2D image onto a 3D Box.

## Resources:
[TIP Paper](https://drive.google.com/file/d/1BDrpe69ae0NYc1JlB9i6xAsa1Xv8BQhO/view?usp=sharing)
[Challenge Description](https://drive.google.com/file/d/150J2yPuC0hXR1ExCX-DYXyG8SAj6GETk/view?usp=sharing)
[Project Explanation](https://docs.google.com/document/d/1qcg5p95zfc2GD6pbUiAdhQBdMfhzdba7tRO9WXzn0IE/) 
[Project Poster](https://drive.google.com/file/d/1quZ83Acz3bonbLpUmy4ilAijdCUnVcWz/view?usp=sharing)


## Running the Application:
### Used Toolboxes:
Image Processing Toolbox
AppDesigner

This app was written in Matlab R2020b.

### Setup
1. Add the folder __**Helper_functions**__ to your matlab path
2. Run __**main.m**__ or __**TIPP_APP.mlapp**__ in Matlab, or start the app directly from your file explorer with a double click.


## Using the Application:
1) Select the desired image for the "tour" with the help of the "Select Image" button.
2) Click the "Select Points for Inner Rectangle" to select two points on the image to form the inner rectangle (namely, the top left point and bottom left point of the rectangle).
3) Check if the rectangle formed is on the ideal positions. Else, reposition by holding and dragging on the corners selected.
4) Proceed by clicking on the "Select Vanishing Point" button and select the vanishing point in the image. Similarly, reposition the vanishing point if needed by holding and dragging.
5) Optionally, if there is an object in the foreground, it can be cropped out from the 3D generation in order to provide a better result. This can be done by clicking on the "Add Foreground Object" button,
to outline the object. Note that the object to be cropped out has to be connected to the ground in the image.
6) The Use Alpha checkbox can be checked in order to create a masked version of the plot. If alpha is not used, the final 3D plot might have some black borders. Note that using Alpha slows down the plotting process.
7) Set the Depth of the generated image using the Depth slider.
8) Lastly, generate the 3D image with the button "Tour into the Picture!" and tour around the 3D image with the provided camera functions.

## Important Notes:
Images can have a maximum of four megapixels. If an image exceeds this, it is automatically scaled down.

## Group Members:
Shi Bu, David Gastager, Milica Kalanj, LihQi Tan, Yan Wang
