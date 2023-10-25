# hw04-stylization

## Project Overview:
In this assignment, you will use a 2D concept art piece as inspiration to create a stylized 3D scene in Unity. This will give you the opportunity to explore transforming concepts into graphics rendered in realtime, as well as explore rendering in Unity.

## Picking a piece of concept art
Choose a simple illustration to guide your stylization. Choose a relatively simple piece of art THAT INCLUDES OUTLINES. You might want to look through the rest of the homework instructions before committing to one. Here are some examples of styles that will work well. Feel free to choose one of these, but we encourage your to pick your own.
[EXAMPLE IMAGES]


## More Interesting Surface and Shadow Shaders
Based on your concept art, let's create some custom surface shaders for the objects in your scene. This should include the following:

Surface shading:
  * A surface shader that conveys the effects of different amount of light on the surface of the objects. This should be more complex than our three tone lab toon shader and make your objects look like they belong in the concept art you've chosen.
  * A SPECIAL second shader that adds a glow, a highlight or some other special effect that makes the object stand out in some way. This is intended to give you practice riffing on existing shaders. Most games or applications require some kind of highlighting: this could be an effect in a game that draw player focus, or a highlight on hover like you see in a tool. If your concept art doesn't provide a visual example of what highlighting could look like, use your imagination or find another piece of concept art.
  * Create two materials, one for each of these shaders. Apply the shaders, to at least one object each in your scene.

Shadows:
* Interesting rendering of shadows. This could be a texture like in the lab, or simplified or warped shapes. Apply this shadow effect to your whole scene.

## Depth and Normal Based Outlines
Make your objects pop by adding outlines to your scene. 
1. Start by sourcing custom depth and normal maps of select objects in your scene. [ADD MORE TECHNICAL DETAIL] You should be able to reference this video for some hints on how to do this [VIDEO LINK]
2. Create an interesting, ANIMATED outline effect that resembles some kind of 2D art medium.
  1. E.g. Pencil Sketch/Crayons/Paint Strokes/Etc. Use your knowledge of toolbox functions to add some wobble, or warping or noise onto the lines that changes over time. Here's an example of outline animation [LINK]
  2. IF you're not satisfied with the look of your outlines and are looking for an extra challenge, after implementing depth/normal based post processing, you may explore non-post process techniques such as inverse hull edge rendering for outer edges to render bolder, more solid looking outlines for a different look [LINK]

## Full Screen Post Process Effect
Ok, now regardless of what your concept art looks like, using what you know about toolbox functions and screen space effects, add some post-process to give your scene a unique look. Your psot processing effect should do at least two of the following.
* A vingette that darkens the edges of your images.

## Interactivity


Other aspects of the HW:
Picking inspiration art
Keep it simple!
Outlines
Aesthetic colors
Patterns	
Sketchy? Hatching? Crayon? Watercolor?
Geometry
Sketchfab, etc.
Mixamo for animated
Manual creation
Maya, ZBrush
Do this at your own benefit and peril. Your geometry/modeling will NOT be graded in this assignment. 
Interactivity
Unity is a game engine after all
Make an interactive component of your scene
E.g. Pressing a button results in all of the materials switching/going crazy- something simple like that!
Think of the post process water effect in Minecraft- it can be simple like that.
Final product:
A turnaround mp4 of your rendered scene!

## Submission
1. Video of a turnaround of your scene

## Resources:
1. [Link to my HW videos]
2. Lab Video
3. URP / Render Feature / Frame Debugger Video
4. Videos from Youtube
  1. NedMakesGames
  2. MinionsArt
  3. Brackeys
