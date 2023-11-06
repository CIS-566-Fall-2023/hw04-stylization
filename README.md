# HW 4: 3D Stylization

Kisha Yan

https://github.com/kishayan02/hw04-stylization/assets/97934823/66ba4753-0a79-47f9-afec-de8a104c1e36

## 1. Picking a Piece of Concept Art
![image](https://github.com/kishayan02/hw04-stylization/assets/97934823/2f913fa6-8c8d-48e9-93c7-f437c3c5d6c5)

I chose one of Emma Koch's pieces from Artstation ([Emma Koch](https://www.artstation.com/ekoch)). I really liked the combination of the watercolor design with the crayon outlines, as well as the color combinations.

## 2. Interesting Shaders
![image](https://github.com/kishayan02/hw04-stylization/assets/97934823/13a4c216-eeaa-4963-bdf6-0e3127bd03aa)

1. **Improved Surface Shader**
   
To improve my shader, I added the folloiwing to the original 3 shade toon shader:
- Multiple light support
- Specular highlight for some shininess (shininess of shader is adjustable)
- An interesting crayon-like shadow
- Accurate colors for each part of model

2. **Special Surface shader**
   
For my second shader, I wanted to add some animated effect to my shark to make it appear like it's in water. I followed the given tutorial to add an animation to the vertex positions of both the shark and the bubbles around it


## 3. Outlines
After fixing the given base code of the homework and getting access to both Depth and Normal buffers, I followed the tutorial on [Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF) to create outlines. I also tried to make my outline resemble crayons by adding some extra textures.


## 4. Full Screen Post Process Effect
In order to mimic the concept art, I added some watercolor texture to the entire screen as a full screen post process effect.


## 5. Create a Scene
My scene is composed of a [shark model](https://sketchfab.com/3d-models/cute-shark-b1c0265a579a4d39b84406ca49c7b5b2) along with bubbles


## 6. Interactivity
If the spacebar is pressed, the shader on the bubbles change.


## 7. Extra Credit
You can rotate the directional light about the Up axis using the Q and E keys.

Thanks :)
