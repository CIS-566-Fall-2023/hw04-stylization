# Beach House *3D Stylization*

## 1. Concept Art:
I wanted to use the style and theme of this concept art I found on the Instagram Page of @holosomnia

|![concept art](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/3636a2a1-0b81-418d-9d15-2de22263f99c)
|

---
## Final Scene:
I created a small video of my stylized scene. Audio is included.

https://github.com/dinethmeegoda/unity-stylization/assets/35506196/2a127ce2-47d3-4463-a978-e0da6258d8ec

---
## 2. Interesting Shaders

I added several custom shaders and properties to this scene. All of these shaders have customizable exposed parameters controlling their main effects.
  * Multiple Light Support
  * Circle Blending Function
  * Sky Shader
  * Cloud Shader
  * Tree Shader
  * Ocean Shader

### Multiple Light Support

External lights other than the main directional light affect the scene and this was used to help light the bed and the ocean.

### Circle Blending Function

I wrote a custom function that would map a circle onto an object as part of its shader based on parameters such as radius, inner/outer color, x/y offset, and blending radius. This shader effect allowed me to map a purple/pink sky reflection onto the ocean as well as create the sun on the sky plane.

### Sky Shader

I used a specified gradient in addition to a spotty noise map I created in Substance Designer that created the stars that were mapped onto the sky. I scrolled a Perlin noise in the sky and as the noise overlapped with the stars, they would brighten and dim, creating a star-twinking effect.

### Cloud Shader

To create the colorful cloud effect I wrote a shader that would first take in the bounds of the object and use its object space coordinates to parametrize each fragment to a 0 - 1 value in the x, y, and z coordinates. I would then use the x coordinates to drive a gradient that represented a sunset color and the z coordinates to drive different buckets of specified colors (pink, purple, blue, red) based on customizable thresholds, much like the three-tone shader. 

I then used the y value to interpolate between the gradient for lower values (when the fragment was closer to the bottom of the cloud) and the color buckets for the higher values at the top of the cloud. I then overrode that with the color of the sun if the surface normal was pointing in the direction of that main light, creating highlights on the left.

Finally, I added vertex displacement driven by customizable Perlin noise to create a windy effect.

### Tree Shader

I used a similar vertex deformation shader to simulate the trees blowing in the wind.

### Ocean Shader

In addition to using the circle from earlier to create the pink/purple effect, I used Simplex Noise and a Sine Wave to create the waves panning across the ocean plane by displacing the height of each vertex. I also used Perlin noise to displace the normal adding to the wavy ocean effect.

I then animated the colors by using the simplex noise driving the height offset to create a white sea shine effect and the normal offset to create white blobs where there was normal displacement (stronger waves) creating a sea foam effect.

---
## 3. Outlines

I implemented outlines by using a Sobel filter on depth and color buffers with customizable parameters. I used a darker version of the existing color for my outlines which helped drive my chalkboard filter later on.

---
## 4. Full-Screen Post-Process Effect

I created a simple customizable vignette post-process effect to give more attention to the center of the composition.

---
## 5. Create a Scene

I used Autodesk Maya's cloth simulations and plane-based modeling in addition to regular 3D modeling to create the models for this scene. Cloth simulations were used for the bed and blankets and the planes were used for the foliage.

All the models were made by me.

In addition, I used ZBrush to sculpt and hand-model the cloud mesh so I could fine-tune the look of the cloud to match the scene.

## 6. Interactivity

Interactivity for the scene was added in two forms:
 * Pressing Space would flood the scene with water using the height parameter of the ocean shader and cause the objects to float up and down using noise.
 * Pressing C would change the parameters of the outline post-process to create a blackboard-like effect.
 
---
## 7. Extra

- Polish through model detail
- Circle shader/Multiple vertex/animated shaders
- Sound Effects
- Double Interactivity

---
# Thanks for Reading!
