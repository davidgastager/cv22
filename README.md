# Tip
Repository for the Tour Into the Picture (TIP) project of the Computer Vision Class in the Summer Semester 2022. Written in Matlab. <br>
In this project, we try to take a "tour" into a 2D image with the help of a spidery mesh. The spidery mesh is defined as the 2D figure consisting of: 
a vanishing point; and an inner rectangle, which represents the window out of which we look at infinity; radial lines that radiate from the vanishing point; 
an outer rectangle which corresponds to the outer frame of the input image. We basically map a 2D image onto a 3D Box.

## Resources:
[TIP Paper](https://drive.google.com/file/d/1BDrpe69ae0NYc1JlB9i6xAsa1Xv8BQhO/view?usp=sharing) <br>
[Challenge Description](https://drive.google.com/file/d/150J2yPuC0hXR1ExCX-DYXyG8SAj6GETk/view?usp=sharing) <br>
[Project Explanation](https://docs.google.com/document/d/1qcg5p95zfc2GD6pbUiAdhQBdMfhzdba7tRO9WXzn0IE/) <br>
[Project Poster](https://drive.google.com/file/d/1quZ83Acz3bonbLpUmy4ilAijdCUnVcWz/view?usp=sharing) <br>


## Running the Application:
### Setup
1. Add the folder __**Helper_functions**__ to your matlab path <br>
2. Run __**main.m**__ or __**TIPP_APP.mlapp**__ <br>

## Using the Application:
The application is very user friendly, and anyone can take a tour into his or her favorite 2D image with just the following easy steps:
1) Select the desired image for the "tour" with the help of the "Select Image" button.
2) Click the "Select Points for Inner Rectangle" to select two points on the image to form the inner rectangle (namely, the top left point and bottom left point of the rectangle).
3) Check if the rectangle formed is on the ideal positions. Else, reposition by holding and dragging on the corners selected.
4) Proceed by clicking on the "Select Vanishing Point" button and select the vanishing point in the image. Similarly, reposition the vanishing point if needed by holding and dragging.
5) Optionally, if there is an object in the foreground, it can be cropped out from the 3D generation in order to provide a better result. This can be done by clicking on the "Outline Object" button,
to outline the object, followed by the "Crop Object" button, to confirm the selection and to crop it out from the 3D generation. Note that the object to be cropped out has to be connected to the 
ground in the image, else the result may not be of optimal quality.
6) Lastly, generate the 3D image with the button "Tour into the Picture!" and tour around the 3D image with the provided camera functions.