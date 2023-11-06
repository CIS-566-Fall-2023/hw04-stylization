# HW 4: *3D Stylization*

## Project Overview:
In this assignment, I used a 2D concept art piece as inspiration to create a 3D Stylized scene in Unity. This will gave me the opportunity to explore stylized graphics techniques alongside non-physically-based real-time rendering workflows in Unity.

## Picking a Piece of Concept Art

This is the concept art I chose by Emma Koch: 
![Concept art](https://github.com/kyraSclark/hw04-stylization/assets/60115638/59ab5ba5-226b-4a3b-a550-1967af2dc5c4)
Link: https://www.artstation.com/artwork/B1JND4

---
## Interesting Shaders

### Improved Surface Shader
I started with the three tone toon shader I created from the Stylization Lab

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/68832dc4-310f-4d45-87b0-32079d358d78)

###  Multiple Light Support
I follow the following tutorial to implement multiple light support.
[Link to Complete Additional Light Support Tutorial Video](https://youtu.be/1CJ-ZDSFsMM)

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/8724c16a-4c09-44b6-9024-3def61a9be92)
              
### Interesting Shadow
I started by create your own custom shadow textures!
I wanted something kind of plain, but when tiled, it looks a bit like scales:
![Shadow4](https://github.com/kyraSclark/hw04-stylization/assets/60115638/13e713b8-5238-4ec1-a332-e61f0fd32fb1)

When you tile it, it looks like this:

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/91046e2b-fd93-40f3-b2fa-17aad2828112)

Next, I used FBM noise to make this texture, which I used a very large scale to tile, in order to keep it blurrly, like grass. 

![Shadow3](https://github.com/kyraSclark/hw04-stylization/assets/60115638/a4f4808f-92d8-4472-99db-0c1664a00604)

Here, we can more easily see the FBM noise in the midtone, as grass on the ground: 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/5c3eddbe-2939-4404-a80a-bdcd23a8a401)

### Accurate Color Palette
I did my best to recreate the color palette of the concept art. Here we can see background has the colors of the leaf, and each sphere (left to right) is the color of the dinosaur's belly, the dinosaur's body, and the sky. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/0ade8713-2cee-4b02-af4a-0f6dc7621fd2)

### Special Surface Shader
For special shaders, first I created a shader that adds texture to the colors, based on the geometry's UV. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/38e29f41-9343-4dc1-8abf-48c411c37e66)

Then, for the sky material, I animated the texture and the color. Now it looks like there is wind, and we are at dusk, turning into night. Please forgive, the lesser quality of the gif. 

![sky_gif](https://github.com/kyraSclark/hw04-stylization/assets/60115638/92f7d155-9e8e-471d-a2b6-c325b22ca98f)

---
## Outlines
Next, I added outlines to the scene. 
Specifically, I'll be creating ***Post Process Outlines*** based on Depth and Normal buffers of our scene!

First, I added a customizable render pass as part of the render pipeline. 
For an example, I created this Invert Mat shader, which is applied at this final post-process render pass. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/d4b8a559-2ba0-4eaa-ac46-e3af5e8ff2e8)

Then, I debugged the provided's codes, Full Screen Feature, by adding this line of code: 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/0d4fd67f-3628-49e5-9d6a-6e314057b400)

Then, I added the Normal Feature to the render pipeline, and made a material off of the Normal Copy shader and then pluged it into the Normal Feature. We can see the normal buffer working here. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/d049d1dc-e77b-400b-94c7-19459034c8a0)

Finally, I used everything above to create outlines using a Sobel filter. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/dd7b1133-a212-4d6b-8692-ec11bb8e7762)

This post-process shader render pass has the following parameters to control what the outlines look like: 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/386b7d5f-89c6-4b3c-bde4-ed23596765ee)

As a last step, I animated these outlines to move over time using some noise and toolbox functions. 

![outlines_gif](https://github.com/kyraSclark/hw04-stylization/assets/60115638/21d3a3a6-9a35-41cb-8e42-8fc537e12585)

---
## Full Screen Post Process Effect

### Vignette
Lastly, I made a vignette post process to replicate the last post-process effect that I could see in the concept art. The vignette takes in a radius, which controlls how much of the screen is darkened. 

![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/a497e082-c355-48b4-b18b-0352af7455f1)
![image](https://github.com/kyraSclark/hw04-stylization/assets/60115638/d5854c79-b9b4-49e1-9f22-cd77302c8cd1)

---
## Create a Scene
This is a fairly ugly scene, but I ran out of time, and I could not figure out how to add different materials to fbx model. I think the model has a bit of detail, which doesn't work well with the way I implemented outlines. If I had more time, I would have like to tweak the colors, because I think the textures have altered the tones of the color palette a little. I also, would have liked to implement lines between colors, not just the model itself. 

[![demo](https://img.youtube.com/vi/-OmYFb3Svn0/0.jpg)](https://www.youtube.com/watch?v=-OmYFb3Svn0)

