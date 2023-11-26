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

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/304d8112-c2fa-4905-8e6b-74b5c4539356)|
|:--:|
| *Circle Function Parameters* |

### Sky Shader

I used a specified gradient in addition to a spotty noise map I created in Substance Designer that created the stars that were mapped onto the sky. I scrolled a Perlin noise in the sky and as the noise overlapped with the stars, they would brighten and dim, creating a star-twinking effect.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/123aecf2-5b77-46db-b02a-1594b6aa14e7)|
|:--:|
| *Stars Noise made with Substance Designer* |


### Cloud Shader

To create the colorful cloud effect I wrote a shader that would first take in the bounds of the object and use its object space coordinates to parametrize each fragment to a 0 - 1 value in the x, y, and z coordinates. I would then use the x coordinates to drive a gradient that represented a sunset color and the z coordinates to drive different buckets of specified colors (pink, purple, blue, red) based on customizable thresholds, much like the three-tone shader. 

I then used the y value to interpolate between the gradient for lower values (when the fragment was closer to the bottom of the cloud) and the color buckets for the higher values at the top of the cloud. I then overrode that with the color of the sun if the surface normal was pointing in the direction of that main light, creating highlights on the left.

Finally, I added vertex displacement driven by customizable Perlin noise to create a windy effect.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/e33c4477-2112-4bab-b857-bd5254ad811e)|
|:--:|
| *Cloud next to sunset Gradient* |

### Tree Shader

I used a similar vertex deformation shader to simulate the trees blowing in the wind.

### Ocean Shader

In addition to using the circle from earlier to create the pink/purple effect, I used Simplex Noise and a Sine Wave to create the waves panning across the ocean plane by displacing the height of each vertex. I also used Perlin noise to displace the normal adding to the wavy ocean effect.

I then animated the colors by using the simplex noise driving the height offset to create a white sea shine effect and the normal offset to create white blobs where there was normal displacement (stronger waves) creating a sea foam effect.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/7046a1bc-2f90-4ee9-8d46-a871264a9186)|
|:--:|
| *Top Down on Ocean Plane* |



---
## 3. Outlines

I implemented outlines by using a Sobel filter on depth and color buffers with customizable parameters. I used a darker version of the existing color for my outlines which helped drive my chalkboard filter later on with animated outlines using a sine wave driven by Perlin Noise.

---
## 4. Full-Screen Post-Process Effect

I created a simple customizable vignette post-process effect to give more attention to the center of the composition.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/bb7b044d-bf16-4887-9e1b-5146590965af)  | ![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/f068393f-47c9-49cc-8950-d6c2079f4434) |
|:--:|:--:|
| *Heavy Vignette Effect* | *Vignette Options* |

---
## 5. Create a Scene

I used Autodesk Maya's cloth simulations and plane-based modeling in addition to regular 3D modeling to create the models for this scene. Cloth simulations were used for the bed and blankets and the planes were used for the foliage. In addition, I used ZBrush to sculpt and hand-model the cloud mesh so I could fine-tune the look of the cloud to match the scene.

All the models were made by me.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/5b7bd987-0a09-4beb-adb2-86831ecd4dfa)  | ![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/a29b1c45-a175-482b-b390-695e0f373012) |
|:--:|:--:|
| *Maya Models* | *ZBrush Cloud Sculpt* |

## 6. Interactivity

Interactivity for the scene was added in two forms:
 * Pressing Space would flood the scene with water using the height parameter of the ocean shader and cause the objects to float up and down using noise.
 * Pressing C would change the parameters of the outline post-process to create a blackboard-like effect with animated outlines.

|![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/7d9abdd4-319b-48e4-9bdf-899858c050af)  | ![image](https://github.com/dinethmeegoda/unity-stylization/assets/35506196/56772978-d1b7-4d18-9866-bdf951c91930) |
|:--:|:--:|
| *Flooded Effect* | *Blackboard Post-Process* |
---
## 7. Extra
- Interactive Camera Shake Script
- Circle shader/Multiple vertex/animated shaders (Most HLSL shader code is in LightingHelp and OutlineHelp)
- Sound Effects
- Double Interactivity
- Polish through model detail?

---
## Thanks for Reading!
