3D Stylization
![Screenshot 2023-11-08 211914](https://github.com/RachelDLin/hw04-stylization/assets/43388455/eef8f072-64b8-4714-abb4-6ed96adc506e)

Concept Art: 
![image](https://github.com/RachelDLin/hw04-stylization/assets/43388455/70b89c7b-bd12-43b6-9448-1d1d22e9353c)
(https://tips.clip-studio.com/en-us/articles/3746)
I was inspired by the colorful cel shaded style seen in anime. I've linked above some concept art by Clip Studio artist Shin that I used as a reference. 

Surface Shader: 
I created a basic toon shader by computing a diffuse term based on the direction, distance attenuation, and shadow attenuation, and bucketing the material into colors based on its value. I liked the appearance of the specular highlights on the dango in the concept art, so I implemented a Blinn Phong specular model and bucketed its value to match the cel shaded look of the rest of the shader. I also noticed that instead of using perfectly cel-shaded regions, the artist breaks up the shapes with some noise. To achieve a similar painterly effect, I created some procedural tileable textures in Substance Designer: 

![brushed_metal](https://github.com/RachelDLin/hw04-stylization/assets/43388455/d35b8509-abd4-4255-bdc0-3192f45355ca)
![watercolor_resized](https://github.com/RachelDLin/hw04-stylization/assets/43388455/69fe4f3b-1819-44fa-a874-4bced14ee308)

which I mapped onto my models based on their UV coordinates rather than the screen position. For the first texture, I wanted to get the look of rougher brush strokes to really break up the shapes, create the movement of the lines through the specular highlights, and add more variation in general. For the second texture I opted for a smoother, watercolor-esque look to add some softer, more subtle detailing in the shadows. To add these textures to my shader, I blended my diffuse calculation with the textures individually to create new "textured" diffuse values. Within my bucketing calculations, I added an extra layer of bucketing within the shadows and highlights based on these warped diffuse values. 

Another thing I noticed about the concept art rendering was that within each bucketed region there was a gradient, resulting in a softening of the sharp color separations that come with cel shading. To implement a similar effect, I used the diffuse value to linearly interpolate the colors for each region within a range determined by the provided shadow, midtone, and highlight colors.

Outlines: 
To add outlines to my scene, I created a fullscreen post-process shader that uses the sobel algorithm based off of the normals retreived from the normal buffers. I noticed that instead of having pure black outlines, the concept art uses a darker shade of the color on the object, so I used the "soft light" blend mode to darken the color in the underlying render.

Full Screen Post Process Effect: 
Although the concept image has a very simple rendering style, I wanted to add slightly more color variation and get a more painterly look overall. To accomplish this, I reused my Substance Designer textures and created a new full screen shader. In my shader graph, I used the textures to iteratively recolor the image and vary the color saturation.

Particle Sim:
I liked how much the steam added in the concept art, and wanted to add some subtle movement to my scene, so I added a particle sim. To get the particles to look like actual steam, I created a shader that added a slight scale to an ellipse in either the horizontal or vertical direction as a function of time. I also used a texture to apply some slight variation in opacity.

Interactivity:
When the user hovers their mouse over the dango, the outlines will appear and smoke will rise. When the user moves their mouse off of the dango, the outlines will disappear and the smoke will stop rising. Holding down the space bar will toggle the color of the background material.

Video link: 
https://studio.youtube.com/video/T8TMRsGIspI/edit
