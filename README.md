# HW 4: *3D Stylization*
(using a late day)

## Project Overview:
In this assignment, I turned a 2D concept art piece into a 3D Stylized scene in Unity via stylized graphics techniques and non-physically-based real-time rendering workflows. 

## Videos 
- https://github.com/debbylin02/hw04-stylization/blob/main/Sunflower-turnaround.mp4
- https://github.com/debbylin02/hw04-stylization/blob/main/Sunflower-straight.mp4
- https://github.com/debbylin02/hw04-stylization/blob/main/Sunflower-interactable.mp4

# Tasks

## 1. Picking a Piece of Concept Art
I chose work made by @riibirengo 
<img width="500px" src=https://github.com/debbylin02/hw04-stylization/blob/main/sunflower-rabbits-concept-art-riibrego-2.png>

## 2. Interesting Shaders
1. **Improved Surface Shader**
      1. **Multiple Light Support**
      - I added multiple light support to my toon shader
     <img width="500px" src=https://github.com/debbylin02/hw04-stylization/blob/main/Screenshot%202023-11-07%20223812.png>
      2. **Additional Lighting Feature**
          - I added a Specular Highlight and Rim Highlight  
      3. **Interesting Shadow**
         - I added a custom shader with a dotted texture 
3. **Special Surface Shader**
   - I added a vertex animation based surface shader to my clouds and flowers to make them wobbly 

## 3. Outlines
I created Post Process Outlines based on Depth and Normal buffers of my scene. I also animated the depth-based outlines.  

## 4. Full Screen Post Process Effect
I added a paper texture and color filters to my scene 

## 5. Create a Scene
I used models from SketchFab 

## 6. Interactivity
Pressing space bar enables "Party mode," which invokes new color shaders as well has faster wobbles  
