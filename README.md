# HW 4: *3D Stylization*

## Project Overview:
I wanted to recreate a comic book-esque stylization, inspired by depictions of characters running "toward" the screen in the Comics. This is what I came up with. 

 ![Flash](https://github.com/inshalak/hw04-stylization/assets/104465349/4f52c8c8-4e75-43b1-bb4e-193a68a223aa)
---
# Tasks
---
## q. Interesting Shaders
1. **Improved Surface Shader**
      1. **Multiple Light Support**
          I added yellow point light support to add yellow highlights to parts of the Flash to make him look like he was runnning "away" from some lit-up object and running "toward" another one. 
      2. **Additional Lighting Feature**
          - Implement a Specular Highlight, Rim Highlight or another similarly interesting lighting-related effect
      3. **Interesting Shadow**
         - I followed the instructions in the Homework description to use a custom "paint" texture to mimic the comic-book effect feel. I'm particularly proud of how this shadow teture turned out on the face of the Flash.
      4. **Accurate Color Palette**
          
3. **Special Surface Shader**
       - **Option 3: Another Custom Effect Tailored to your Concept Art**
          I followed this [tutorial](https://www.youtube.com/watch?v=Afh5zY6zxLs) to create a procedural electricity shader using Unity's VFX Graph for my Flash. Although I couldn't figure out how to map the shader to the surface of the Flash to make it cool, I did place the electric orbs "within" the Flash Asset to make it seem like the electricity was pulsing from within him. 

---
## 3. Outlines
I implemented a basic outline for my Flash and gave him a pencil-y exterior. Animating it added too much motion to the scene however, and I decided not to put this in my final product. You can view what that looks like below. 
---
## 4. Full Screen Post Process Effect
My final post processing effect HAD to be speed lines. I worked on using the vignette method and polar coordinates to add spherical lines 

---
## 5. Create a Scene

## 6. Interactivity
Pressing the space bar translates Flash forward, places a monochrome material on flash, a black and white post processing shader and makes the vignette vibrate faster, making it seem like he is running closer to you!
 
---
## 7. Extra Credit
My surface shader is VFX shader graph based? Unsure if that qualifies.

## Submission
1. Video of a turnaround of your scene
2. A comprehensive readme doc that outlines all of the different components you accomplished throughout the homework. 
3. All your source files, submitted as a PR against this repository.

## Resources:

1. Link to all my videos:
    - [Playlist link](https://www.youtube.com/playlist?list=PLEScZZttnDck7Mm_mnlHmLMfR3Q83xIGp)
2. [Lab Video](https://youtu.be/jc5MLgzJong?si=JycYxROACJk8KpM4)
3. Very Helpful Creators/Videos from the internet
    - [Cyanilux](https://www.cyanilux.com/)
        - [Article on Depth in Unity | How depth buffers work!](https://www.cyanilux.com/tutorials/depth/) 
    - [NedMakesGames](https://www.youtube.com/@NedMakesGames)
        - [Toon Shader Lighting Tutorial](https://www.youtube.com/watch?v=GQyCPaThQnA&ab_channel=NedMakesGames)
        - [Tutorial on Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)
    - [MinionsArt](https://www.youtube.com/@MinionsArt)
        - [Toon Shader Tutorial](https://www.youtube.com/watch?v=FIP6I1x6lMA&ab_channel=MinionsArt)
    - [Brackeys](https://www.youtube.com/@Brackeys)
        - [Intro to Unity Shader Graph](https://www.youtube.com/watch?v=Ar9eIn4z6XE&ab_channel=Brackeys)
    - [Robin Seibold](https://www.youtube.com/@RobinSeibold)
        - [Tutorial on Depth and Normal Buffer Robert's Cross Outliens in Unity](https://youtu.be/LMqio9NsqmM?si=zmtWxtdb1ViG2tFs)
    - [Alexander Ameye](https://ameye.dev/about/)
        - [Article on Edge Detection Post Process Outlines in Unity](https://ameye.dev/notes/edge-detection-outlines/)
