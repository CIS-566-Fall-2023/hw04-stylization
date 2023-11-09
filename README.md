# 3D Stylization Shaders - *Waterpaint*

https://github.com/LinDadaism/ProceduralGraphics-Stylization/assets/46789205/0bc1bffd-128b-4060-9e6c-cec8e8c2096b


## Project Overview:
In this project, I used some watercolor/ water paint 2D concept art pieces as inspiration to create a 3D Stylized scene in Unity. This gave me the opportunity to explore stylized graphics techniques alongside non-physically-based real-time rendering workflows using the Universal Render Pipeline (URP).

| ![](/Images/poppiesVase.png)  | ![](/Images/watercolor.png) |
|:--:|:--:|
| *2D Concept Illustration* | *3D Stylized Scene in Unity* |


## Inspirations/ Concept Art
Below are some linked references of watercolor paintings I found aesthetic and peaceful. More importantly, they have simple scene assembly and clear outlines -- features that ease you in as a start to learn Unity ShaderGraph.

| ![](/Images/poppiesVase.png) | ![](/Images/orchids.jpg) | ![](/Images/coffee.jpg) |
|:--:|:--:|:--:|
| *https://www.etsy.com/listing/1459961161/kintsugi-vase-and-poppies-square-art* | *https://pin.it/4Qje7a9* | *https://www.watercoloraffair.com/watercolor-coffee-painting-a-complete-step-by-step-tutorial/* |


## Watercolor 
### Interesting Surface Shader
The main catch of my concept art pieces is watercolor so I put a lot of effort into creating a surface shader that heavily utilizes noise-based texture sampling to mimick water paint. Then I move on to add dynamic shadow, also in watercolor style, that is eventually blended with the object's surface color with some fresnel effect. [This article](https://cyangamedev.wordpress.com/2020/10/06/watercolour-shader-experiments/#object-shader) on watercolour shader experiments gave me a good guidance on this step.

Watercolor Shader | Watercolor Shader with Shadow
---|---
![](/Images/watercolorShader.png) | ![](/Images/watercolorShadow.png)

*Note: I decreased the noise value of the floor material for the second screenshot to better showcase the shadow.*


Although there's no distinct/ complex lighting in my concept art, I experimented with multiple lights in the scene using a basic 3-tone shader. Unfortunately the result was not satisfying so I decided to not incorporate multi-lights support in my stylized render.

![](/Images/additionalLights.png)


## Outlines
### Post-process Shader
The subtle outlines on the 3D objects are achieved by post-processing effects. I mainly relied on Render Features in Unity URP to add customizable full screen render passes to any part of the render pipeline. 

I followed these tutorials to learn the use cases of Render Features and the various techniques to outlining 3D objects:
 - [Show Silhouette When Hidden](https://youtu.be/GAh225QNpm0?si=XvKqVsvv9Gy1ufi3)
 - [Alexander Ameye](https://ameye.dev/about/)
    - [Article on Edge Detection Post Process Outlines in Unity](https://ameye.dev/notes/edge-detection-outlines/)
 - [NedMakesGames](https://www.youtube.com/@NedMakesGames)
    - [Tutorial on Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)

To trace the objects' outlines, we need to get access to the Depth and Normal Buffers of our scene. URP actually already provides us with the option to have a depth buffer, and so obtaining a depth buffer is a very simple/trivial process. However, this is not the case for a Normal Buffer, and thus, we need a render feature to render out the scene's normals into a render texture. I watched this [video](https://youtu.be/giLPZA-xAXk) to learn how to create the depth and normal buffers, and then access/read both once we've created them.

Normal Map | Depth Map
---|---
![](/Images/normalMap.png) | ![](/Images/depthMap.png)


Back to outlining 3D objects, the logic behind my post-process shaders is quite straight-forward: detect areas of large depth and normal difference across the screen. I explored different kinds of edge detection methods in HLSL, including Sobel operator and Robert's Cross filters. The following table shows the different approaches after fine-tuning.

No Outlines | Sobel | Robert's Cross | Sobel + Robert's Cross
---|---|---|---
![](/Images/noOutlines.png) | ![](/Images/outlinesSobel.png) | ![](/Images/watercolor.png) | ![](/Images/bothOutlines.png)

I tweaked some outline parameters such as outline thickness, normal and depth sensitivities (i.e. discontinuity threshold) to replicate the subtle wobbly outlines in the concept art. Using only Robert's Cross gives me the most desirable result. In addition, the outlines are dynamically traced based on the view change in terms of camera angle and position.


## Vertex Animation
Finally I assembled my scene "A Serene Afternoon" with flower vases and a cup of coffee. To make the scene more lively and organic, I wrote another two special surface shaders that animate a falling dead leaf and the coffee steam by offsetting the vertex positions. Both shaders are based off of [this tutorial](https://www.youtube.com/watch?v=VQxubpLxEqU&ab_channel=GabrielAguiarProd).

Falling Leaf |
---|
![](/Images/fallingLeaf.gif) |
![](/Images/vertAnim.png) |


Coffee Steam | 
---|
![](/Images/coffeeSteam.gif) |
![](/Images/wobbleAnim.png) |


## Full Screen Post Process Effect
The last step is to add a watercolor background. I tried to insert a render pass of just a texture sample using my hand-painted watercolor paper (scanned to produce a digital copy) but it was always blocking the opaque objects. As I was running out of time, I chose a work-around, i.e. creating a 6-sided skybox with the same texture flipped in the positive and negative direction of each axis. The output isn't seamless -- as the turn table rotates you can recognize the sharp edges of a cube. Future improvement is to fix the background full screen render pass, or to generate 6 skybox textures to match each side of the 3 axes.

![](/Assets/Textures/skybox1.jpg)

## Resources:
In addition to the references mentioned in the descriptions,
1. Logan Cho's Tutorials on Unity ShaderGraph:
    - [Playlist link](https://www.youtube.com/playlist?list=PLEScZZttnDck7Mm_mnlHmLMfR3Q83xIGp)
    - [Color Lab Video](https://youtu.be/jc5MLgzJong?si=JycYxROACJk8KpM4)
2. Models:
    - [Magnolia in a vase](https://skfb.ly/oxxYN)
    - [Flower test](https://skfb.ly/6REuY)
    - [XfrogPlants Poppy Anemone](https://www.turbosquid.com/3d-models/3ds-max-xfrogplants-poppy-anemone-plant/286070)
    - [Mossy Vase](https://sketchfab.com/3d-models/mossy-vase-08bf8528a304460491dde8d4d8212234)
    - [Coffee Mug](https://sketchfab.com/3d-models/coffee-mug-fea036cd02da4b83ba749041a0c62ca9)
    - [Plate](https://sketchfab.com/3d-models/plate-4a7e825593344734b2802abc4c363fc2)
    - [Dead leaf](https://sketchfab.com/3d-models/dead-leaf-3010adcad5874e9dad812110eaf94198)
