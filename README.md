# Painting in Progress Shader

## Concept Art and Final Render

<img height="400" alt="ref" src="/ref.jpg">

Inspired by this painting from the Barnes Foundation in Philly, I worked to recreate the unfinished but elegant painting look using Unity shaders. 
Below is my final render!

<img height="400" alt="ref" src="/final.png">

---
## Surface Shaders

<img height="200" alt="ref" src="/scene_cam.png">

Beginning with the three-toned toon shader from the lab, I added adjustments so that the shader supports multiple lights. 

### Additional Feature: Stroke Alpha

<img height="200" alt="ref" src="/specialized_effect.png">

I used my own stroke texture, created in Procreate, to blend with the toon shader, creating the unfinished painting look. 
This alpha feature uses the object's UVs and the alpha channel of the shader. 

### Paint Texture Shadow

<img height="200" alt="ref" src="/shadow.png">

I also created a paint stroke shadow using a texture from Blender. It uses the object's UVs and adds some more dimension to the darker shadows. 

---
## Canal Water Shader

<img height="400" alt="ref" src="/waternodes.png">

The canal water shader is composed of both a vertex and fragment shader. The shaders are also both procedural. 

For the vertex shader, I wrote a C# method in LightingHelp.HLSL entitled WaterWaves_float() to distort the plane with a sine function, creating wavy water. 

For the fragment shader, I ported in Worley noise functions from the class slides into LightingHelp.HLSL and manipulate the color of the water based on the noise. This creates caustic-like effects. Despite these changes, the water shader still handles multiple lights, as seen in color changes from the blue light towards the right of the scene. 

---
## Outlines

I followed the Toon Outlines in Unity URP to create the outlines. This includes adding a new "Full Screen Feature", creating an outline shader graph and material, and writing the Sobel algorithm function in OutlineHelp.HLSL. 
Various parts of the outline are user customizable, including the threshold, width, thickness, strength, and color. 

I added depth and normal buffers, as demonstrated in Logan's video. In addition, I also debugged the "Full Screen Feature" by adding a secondary blit. 

### Outline Animation 

I added a simple animation that offsets the outline with respect to the sine of time. I also used Perlin noise to displace the Color Sobel part of the outline, which adds an additional painterly effect. 

---
## Canvas Post-Process

Adding another Renderer Feature, I blended in a canvas texture with the output colors to create the effect that the scene is being painted on the canvas. 
The pass is named Kuwahara, as I was thinking of implementing the Kuwahara painterly shader, but I settled on the canvas effect instead. 

---
## Venetian Scene

<img height="200" alt="ref" src="/buildings.png">

The models in my scene came from my own procedural tool in Houdini. The tool generates Venetian-style buildings by using Copy to Points to geometrically put Venetian architecture pieces together.

---
## Interactivity: In-Progress Painting

https://github.com/yuhanliu-tech/hw04-stylization/assets/42754447/04993df6-634e-4ec3-80b2-10677c6d1111

I created a C# script that alters the materials of several objects in the scene. For a selection of objects, I alternate between the shader with paint-textured shadows and the shader with alpha shadows. This allows for the user to press SPACE to alternate between a painting that seems more or less incomplete. 

