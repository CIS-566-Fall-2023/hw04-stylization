# 3D Stylization

## Project Overview:
 - In this is project I use a 2D concept art piece as inspiration to create a 3D Stylized scene in Unity.

| <img width="500px" src=https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/11.png>  | <img width="500px" src=https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/14.gif> |
|:--:|:--:|
| *2D Concept Illustration* | *3D Stylized Scene in Unity* |

 - I attempted to implement a toon shader style inspired by the game Zelda. To do this, I referenced actual scenes from the game.

| <img width="500px" src=https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/1.png>  | <img width="500px" src=https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/10.png> |
|:--:|:--:|

---
# Implementation

## Three Tone Toon Shader
- As start, I used my three-tone toon shader as basic shader to implement my 3D stylized scene. It's a shader with just three colors output based on the threshold you setting. You can have the highlight, midtone, and shadow in your object.
 ![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/4.png)

## Lighting Feature
 - Reference: https://roystan.net/articles/toon-shader/  

### 1. Rim Light
- The "rim" of an object is defined as surfaces that are facing away from the camera. I therefore calculate the rim by taking the dot product of the normal and the view direction, and inverting it. Then, I used smoothstep to toonify the effect and multiple it with the `rimColor`. With the rim being drawn around the entire object, it tends to resemble an outline more than a lighting effect.I modified it to only appear on the illuminated surfaces of the object by multiplying it with the dot product of light position and normal.
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/5.gif)

### 2. Specular Highlight
 - I used the Blinn-Phong model to calculate the specular highlight of my toon shader. This calculation takes in two properties from the surface, a `specularColor` that tints the reflection, and a `glossiness` that controls the size of the reflection.  
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/6.gif)

## Shadow
 - I used the following texture to cast the shadow texture onto the object's surface.  
<img width="300px" src=https://github.com/Jeff-Ling/hw04-stylization/blob/main/Assets/Textures/Shadow1.jpg>  

## Vertex Animation
 - To create a flag-waving effect, I simply adjusted the movement along the x-axis of the UV coordinates on the surface.  
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/7.gif)

## Outline
 - I developed a screen-space outline shader that utilizes depth and normal buffers for edge detection. This shader generates outlines in regions with substantial disparities in depth and normals across the screen. You have the flexibility to fine-tune the threshold to determine the magnitude of difference required to classify a pixel as part of an outline.  
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/9.gif)

## Animated Outline Shader
 - I used Gradient Noise to perturb the UV coordinates at the input stage of the outline process.
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/12.gif)

## Full-Screen Post-Process Effect
 - I made an old movie-style full screen post-process effect.
 - I used the `Simple Noise` node to make the screen flicker like an old-school projector.
 - I also utilized the Simple Noise node and the Voronoi node to simulate the burn marks and vertical line effects reminiscent of old film.
![](https://github.com/Jeff-Ling/hw04-stylization/blob/main/Images%20Resource/8.gif)

# Interactivity
* `Space`: Swap the material of Sonic.
* `A`: Turn ON/OFF Outline post-process.
* `S`: Turn ON/OFF Old Movie post-process effect.
