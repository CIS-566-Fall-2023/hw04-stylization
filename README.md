# HW 4: *3D Stylization*

by Sherry Li

https://github.com/sherryli02/hw04-stylization/assets/97941858/120e7d54-04fe-4aea-a57c-a6b0777c7a25

https://github.com/sherryli02/hw04-stylization/assets/97941858/524e7ec3-daa8-4cd6-b9e2-4e0dd6536ea0


Original concept by Alariko:
![F9btwfLWAAAd8vy](https://github.com/sherryli02/hw04-stylization/assets/97941858/a168adbe-84f5-4a80-99cb-f28ba333931d)

# Lights
I implemented multiple light support by following Logan's tutorial. For the primary light, I  implemented interpolation between the color bands by using smoothstep and lerp; the user can control the level of interpolation by adjusting a “Smoothness” value. 

Since the additional lights themselves are quantized, not their outputs, I couldn't implement this method of smoothing for additional lights. Since the hard non-interpolated bands contrasted with the aesthetic I wanted to achieve, I chose not to use any additional lights in my scene.

# Specular Highlight
I implemented both Blinn and Phong reflections by following [this video](https://www.youtube.com/watch?v=B56z6st6U8E). By using a Round node, I could create a cell shading-like look.

# Custom Textures
Using Photoshop, I created a few textures that I incorporated throughout all materials in order to emulate the look of the concept art. The user can control the strength (opacity) and scale of the textures.

![textures](https://github.com/sherryli02/hw04-stylization/assets/97941858/f1445554-d786-4c61-a63f-cc7b00144d21)

# Leaf Shader
For the leaves of the tree, I used a different texture from the other materials and played around with shadow attenuation to get a different look. Using [this link](https://www.shadertoy.com/view/DsK3W1) for a Perlin noise implementation, I added static noise to their vertex positions to approximate the look of leaves, and time-based noise to give off the impression of the leaves swaying in the wind.

# Outlines
Using Unity Render Features in the URP pipeline, I was able to render depth and normal buffers. I referred to [this article](https://ameye.dev/notes/edge-detection-outlines/) for an implementation of post-process edge detection using both depth and normals, allowing the user to control sensitivities to depth and normals, as well as outline color and thickness. I added "wobble" to the outlines by adding Perlin noise to the UVs. Using more noise, I added variation in the thickness and opacity of the outlines to emulate a hand-drawn look.

# Specks
Using Perlin noise, I added random small circles and dots to the material textures to closer match the concept art.

# Sky
By making a plane a child of the rotating camera, and using smoothstep to create a gradient, I was able to create a sky matching the concept art.

# Interactivity
By attaching additional materials and a C# script to all objects that listens for a keypress to switch materials, the user can press Space to toggle between a daytime and evening scene.

# Post-processing
Using a Channel Mixer node, I was able to color grade the overall image.

# Model Sources
[House](https://sketchfab.com/3d-models/house-low-poly-3f2431b6c0a8440a87ec0fb1f40798e2),
[Tree](https://sketchfab.com/3d-models/low-poly-tree-5ae59f0c15f447598c80db1f623a1355)


