# HW 4: *3D Stylization*

## Project Overview:
Using a 2D concept art piece as inspiration to create a 3D stylized scene in Unity. 

| <img width="300px" src=https://github.com/wc41/hw04-stylization/assets/97757188/50ae461d-544c-427a-bd14-f2db9152146a/>  | <img width="500px" src=https://github.com/wc41/hw04-stylization/assets/97757188/513587ea-619c-4a6f-95b2-81509bd0ff07/> |
|:--:|:--:|
| *2D Concept Illustration* | *3D Stylized Scene in Unity* |

<br>
<b>Turnaround video (showcases interactivity for 2nd shader/materials):</b>

https://github.com/wc41/hw04-stylization/assets/97757188/3e1981d1-dd14-4e35-b095-fbcc65f1e0c6

---
# Process

## 1. Picking Concept Art

Concept art taken from @sseongryul on instagram:

<img width="300px" src=https://github.com/wc41/hw04-stylization/assets/97757188/13586bc0-a1c5-4c3a-86b6-d558be0570e3/><img width="300px" src=https://github.com/wc41/hw04-stylization/assets/97757188/ea7273a3-3b7f-4e14-ae8d-84ed6e587276/>


---
## 2. Shaders

1. **Improved Toon Shader**
Improvements upon previously created three tone toon shader.
      1. **Multiple Light Support**
          - Multiple light support for additional point lights, created by modifying original shader.
              - <img width="450" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/0df531f6-5ed5-4da2-9636-9bf4ba0e5e12">
              - <img width="450" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/5adff250-8d46-474d-9eb1-b989a0b910dc">
              - With help from tutorial: https://youtu.be/1CJ-ZDSFsMM
      2. **Specular Lighting and Rim Lighting**
          - Modified shaders for extra specular lighting and rim lighting
          - Specular lighting process
              - pow(saturate(dot(viewVector, lightVector)), glossiness) * diffuse lighting
              - Then applied noise, smoothstep for black and white values + control for blending
              - Finally multiply with color input
          - ![image](https://github.com/wc41/hw04-stylization/assets/97757188/b5827b2d-f8dd-44f2-9e63-2379ad1273c0)
          - Rim lighting done similarly, except multiplying diffuse lighting with 1-saturate(dot(view, normal))
          - ![image](https://github.com/wc41/hw04-stylization/assets/97757188/b1d2bf09-0374-4561-b41b-786f312974b6)
      3. **Textured Shadow**
          1. Custom shadow texture to create a textured look
          2. Using default object UVs to map shadows onto ground
          3. Shadows + specular/rim lighting before blending/noise:<br><img width="450" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/3c2e7f77-af88-401d-8a25-eab8b08c6eb6">
3. **Special Surface Shader**
   - Added more effects to the coloring and lighting
       - Blur between the diffuse colors
       - Perlin noise along the lines of the diffuse colors, and surrounding the specular/rim lighting
           - Added before all diffuse color separation:
           - ![image](https://github.com/wc41/hw04-stylization/assets/97757188/20ba8c43-2b6a-445c-a259-47ce2b634140)
       - Perlin noise to the diffuse colors themselves, so that they vary in brightness
           - ![image](https://github.com/wc41/hw04-stylization/assets/97757188/5ac0bf05-57ef-4366-a52a-45ec0695e187)
       - Applied an edge darkening effect to simulate watercolor pooling at the edges of diffuse colors. The size and darkness of this effect is affected by a noise value
           - ![image](https://github.com/wc41/hw04-stylization/assets/97757188/4a15c131-48fb-4741-ba36-2b7b508a989c)
       - Animated the color brightness noise and the diffuse color edge noise with a Time node and modifying my Perlin noise function to take in time as an input
   - Final look + parameters:<br><img width="450" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/92dce2b8-6339-4fc3-a6bc-825b26741074"><img width="250" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/4f829a56-a625-4b28-9c52-3f8ca46c7d78">
   - Turnaround video to showcase animation: <br>
   https://github.com/wc41/hw04-stylization/assets/97757188/4b12e27f-3a91-42ba-b869-7d191039965d


---
## 3. Outlines

Added ***Post Process Outlines*** based on Depth buffers of the scene.

1. Created render feature from base code (help from https://youtu.be/Bc9eTlMPdjU), which then takes in a new full-screen material to create outlines
2. Created a new shader for this material which accesses normal and depth buffers
3. Followed [this tutorial](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF) to write a depth-based sobel edge detection function which takes in many parameters for edge detection.
4. To make outlines seem more hand-drawn with pen, a bunch of noise parameters were added to vary the darkness, thickness, and offset of the lines.<br>![image](https://github.com/wc41/hw04-stylization/assets/97757188/7927baff-d33f-4ded-86a0-190692db91af)
5. The noise for each of these outline parameters is also animated using a time node and a perlinTime function.
6. Final look + parameters:<br><img width="450" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/eda1344d-9543-49d0-9c5f-0c5de02a8492"><img width="250" alt="Screenshot 2023-10-26 140845" src="https://github.com/wc41/hw04-stylization/assets/97757188/f4ce8ee6-b915-4269-91c3-a74622964b53">


---
## 4. Full Screen Post Process Effect + Creating Scene

Added a post-process paper texture to the scene in my fullscreen shader and created the scene. It consists of a pine tree model and an ice bear model both downloaded from SketchFab.

https://sketchfab.com/3d-models/pine-tree-d45218a3fab349e5b1de040f29e7b6f9

https://sketchfab.com/3d-models/ice-bear-we-bare-bears-77f6d43d4dc740dfb8a500743676a18c

![image](https://github.com/wc41/hw04-stylization/assets/97757188/601e0e7a-207c-404c-8f22-9aedc6ccb8fa)

## 5. Interactivity
To add interactivity, I created a new shader with a different method of blending between the diffuse color separation values using Perlin Noise:

![image](https://github.com/wc41/hw04-stylization/assets/97757188/8a5bc942-3ed9-4b60-a4d6-96234cbf17e1)

This applies a sort of inky effect, so I decided to make new materials with colors that reflect this. I found that a harshly lit red/black scene looked interesting:

![image](https://github.com/wc41/hw04-stylization/assets/97757188/2110a713-071c-4d3d-8748-a3a7db2a7492)

Finally, I applied a C# script to toggle between the 2 main scenes, as well as a script for the camera to toggle between beige and black for the background.
