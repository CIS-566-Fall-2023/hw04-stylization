# 3D Stylization

## Project Overview:
In this assignment, you will use a 2D concept art piece as inspiration to create a stylized 3D scene in Unity. This will give you the opportunity to explore transforming concepts into graphics rendered in realtime, as well as explore rendering in Unity.

## 1. Picking a piece of concept art
Choose a simple illustration to guide your stylization. Choose a relatively simple piece of art THAT INCLUDES OUTLINES. You might want to look through the rest of the homework instructions before committing to one. Here are some examples of styles that will work well. Feel free to choose one of these, but we encourage your to pick your own.
[EXAMPLE IMAGES]


## 2. More Interesting Surface and Shadow Shaders

### **2. Description:**
Based on your concept art, let's create some custom surface shaders for the objects in your scene! 

Spend some time thinking about the main characteristics you see in the surface shading of your concept art. 
* What makes it look appealing/aesthetic?
  * Is it the color palette? How smooth or blocky are the transitions between colors?
  * Are there additional effects such as rim or specular highlights?
  * Are there multiple lights in the scene?

*These are all examples of things we want you to try thinking about before diving into your shaders!*

### **2. To-Do:**
1. Create a surface shader inspired by the surface(s) in your concept art. Build off of the three tone toon shader you created from the lab as a starting point, but the final shader must be more complex with the following requirements:
    1. **Multiple Light Support**
        - Follow the following tutorial to implement multiple light support
    2. **Additional Lighting Feature**
        - Implement a Specular Highlight, Rim Highlight or another similar new effect in your shader
    3. **Interesting Shadow Texture**
        - Source your own shadow texture!
    4. **Accurate Color Palette**
        - Do your best to replicate the colors of your concept art!
 2. Create an additional shader that will make an object stand out in some way. 

Tips:

I recommend you work with very simple geometry when prototyping your shaders/materials. E.g. Spheres/Cubes and planes- anything simple enough to showcase lighting and shadows.


Surface shading:
  * A surface shader that conveys the effects of different amount of light on the surface of the objects. This should be morecomplex than our three tone lab toon shader from the lab, and make your objects look like they belong in the concept art you've chosen.
    * TO-DO:
      * Support additional lights and shadows  
    * There must be at least 2 significant new features. For example:
      * Specular Highlight
      * Directional Light Rim Highlight
  * A SPECIAL second shader that adds a glow, a highlight or some other special effect that makes the object stand out in some way. This is intended to give you practice riffing on existing shaders. Most games or applications require some kind of highlighting: this could be an effect in a game that draw player focus, or a highlight on hover like you see in a tool. If your concept art doesn't provide a visual example of what highlighting could look like, use your imagination or find another piece of concept art.
  * Create two materials, one for each of these shaders. Apply the shaders, to at least one object each in your scene.

Shadows:
* Interesting rendering of shadows. This could be a texture like in the lab, or simplified or warped shapes. Apply this shadow effect to your whole scene.

## 3. Depth and Normal Based Outlines
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
As a finishing touch, let's show off the face that our scene is rendered in real-time! Please add an elment of interactivity to your scene. Change some major visual aspect of your scene on a keypress (see video for help with this). The triggered change could be
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
