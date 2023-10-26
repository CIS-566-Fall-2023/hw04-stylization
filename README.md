# HW 4: 3D Stylization

<p align="center">
  <img width="400px" height="220px" src=https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/e200c9b3-be41-45ff-9f04-f9112ac388e3/>


## Project Overview:
In this assignment, you will use a 2D concept art piece as inspiration to create a stylized 3D scene in Unity. This will give you the opportunity to explore transforming concepts into graphics rendered in realtime, as well as explore rendering in Unity.

1. Picking a Piece of Concept Art
2. Interesting Shaders
3. Outlines
4. Full Screen Post Process Effect
5. Creating a Scene
6. Interactivty
7. Extra Credit

# HW Tasks:

## 1. Picking a Piece of Concept Art
Choose a simple illustration to guide your stylization. Choose a relatively simple piece of art THAT INCLUDES OUTLINES. You might want to look through the rest of the homework instructions before committing to one. Here are some examples of styles that will work well. Feel free to choose one of these, but we encourage your to pick your own.
[EXAMPLE IMAGES]


## 2. Interesting Shaders

Let's create some custom surface shaders for the objects in your scene, inspired by your concept art! 

Take a moment to think about the main characteristics that you see in the shading of your concept art. What makes it look appealing/aesthetic?
  * Is it the color palette? How are the different colors blending into each other? Is there any particular texture or pattern you notice?
  * Are there additional effects such as rim or specular highlights?
  * Are there multiple lights in the scene?

These are all things we want you to think about before diving into your shaders!

### To-Do:
1. **Improved Surface Shader**
   - Create a surface shader inspired by the surface(s) in your concept art. Use the three tone toon shader you created from the Stylization Lab as a starting point to build a more interesting shader that fulfills all of the following requirements:
      1. **Multiple Light Support**
          - Follow the following tutorial to implement multiple light support. [Link to additional light support]
      2. **Additional Lighting Feature**
          - Implement a Specular Highlight, Rim Highlight or another similarly interesting lighting-related effect
      3. **Interesting Shadow**
          1. Create your own custom shadow texture!
              - You can use whatever mediums you have available- digital art (Photoshop, CSP, Procreate, etc.), traditional art (drawing on paper, and then taking a photo/scan), you have complete freedom!
          2. Modify shadows using your custom texture
          3. Use the default object UVs instead of Screen position!
              - In the 3rd Puzzle of the Lab, the shadow texture was sampled using the Screen Position node. This time, let's use the object's UV coordinates to have the shadows conform to geometry. Hint: To get a consistent looking shadow texture scale across multiple objects, you're going to want some exposed float parameter, "Shadow Scale," that will adjust the tiling of the shadow texture. This will allow for per material control over the tiling of your shadow texture.
      3. **Accurate Color Palette**
          - Do your best to replicate the colors of your concept art!
3. **Special Surface Shader**
   - *Let's get creative!* Duplicate your shader to create a variant with an additional special feature that will make the hero object of your scene stand out. Choose one of the following two options:
       - **Option 1: Animated Pencil Sketch/Crayon/Watercolor Effect**
          - [Example Image]
              - In my demo, I imported a texture I created in Procreate in order to create a screenspace, animated hand drawn effect on my Sonic materials, alongside the grass plane.
          - Useful tips to get started:
              - Either create your own texture similar to the shadow texture that you made for your surface shaders or procedurally generate some noise texture that resembles some kind of hatching/crayon/watercolor/some traditional art medium. You could either have this procedural generation occur within a custom function node in real-time, or you can do the generation on something like ShaderToy, and then output/screenshot the image to import into your Unity project.
              - Use the Time node in Unity's shader graph to get access to time for animation. Consider using a Floor node on time to explore staggered/stepped interpolation! This can be really helpful for selling the illusion of the animation feeling handdrawn.
       - **Option 2: Another Custom Effect Tailored to your Concept Art**
          - If you'd like to do an alternative effect to Option 1, make sure that your idea is relatively similar in scope/difficulty.
          - Some ideas include:
            - Uhhh

## 3. Outlines
Make your objects pop by adding outlines to your scene!
1. Start by sourcing custom depth and normal maps of select objects in your scene. [ADD MORE TECHNICAL DETAIL] You should be able to reference this video for some hints on how to do this [VIDEO LINK]
2. Create an interesting, ANIMATED outline effect that resembles some kind of 2D art medium.
  1. E.g. Pencil Sketch/Crayons/Paint Strokes/Etc. Use your knowledge of toolbox functions to add some wobble, or warping or noise onto the lines that changes over time. Here's an example of outline animation [LINK]
  2. IF you're not satisfied with the look of your outlines and are looking for an extra challenge, after implementing depth/normal based post processing, you may explore non-post process techniques such as inverse hull edge rendering for outer edges to render bolder, more solid looking outlines for a different look [LINK]

## 4. Full Screen Post Process Effect
We're nearing the end! Ok, now regardless of what your concept art looks like, using what you know about toolbox functions and screen space effects, add some post-process to give your scene a unique look. Your psot processing effect should do at least two of the following.
* A vingette that darkens the edges of your images with a color or pattern
* Color / tone mapping that changes the colorization of your renders. [Here's some basic ideas, but please experiment](https://gmshaders.com/tutorials/basic_colors/) 
* A texture to make your image look like it's drawn on paper or some other surface.
* A blur to make your image look smudged.
* Fog or clouds that drift over your scene
* Whatever else you can think of that complements your scene!

## 5. Create a scene
Using Unity's controls, create a SUPER BASIC scene with a few elements to show off your unique rendering stylization. Be sure to apply the materials you've created. Please don't go crazy with the geometry -- then you'll have github problems if your files are too large. [See here](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github). Art direct your scene a little :)

## 6. Interactivity
As a finishing touch, let's show off the face that our scene is rendered in real-time! Please add an element of interactivity to your scene. Change some major visual aspect of your scene on a keypress (see video for help with this). The triggered change could be
* Party mode (things speed up, different colorization)
* Memory mode (different post-processing effects to color you scene differently)
* Fanart mode (different surface shaders, as if done by a different artist)
* Whatever else you can think of! Combine these ideas, or come up with something new. Just note, your interactive change should be at least as complex as implementing a new type of post processing effect or surface shader. We'll be disappointed if its just a parameter change. There should be significant visual change.

## Extra Credit
Explore! What else can you do to polish your scene?
[ADD MORE IDEAS]
Interesting Terrain
Interesting Skybox
Day-Night Cycle/Lighting Manager

## Submission
1. Video of a turnaround of your scene
2. All your source files, submitted as a PR against this repository.

## Resources:
1. [Link to my HW videos]
2. Lab Video
3. URP / Render Feature / Frame Debugger Video
4. Videos from Youtube
  1. NedMakesGames
  2. MinionsArt
  3. Brackeys
