# 3D Stylization

## Project Overview:
In this project, I used a 2D concept art piece as inspiration to create a 3D Stylized scene in Unity, allowing me to explore stylized graphics techniques alongside non-physically-based real-time rendering workflows in Unity.

https://github.com/hansen-yi/hw04-stylization/assets/97490525/027910d6-379a-45c5-abc5-078dfd211f5d

# References
| *Original Reference* | *Additional Reference* |
|:--:|:--:|
| <img width="500px" src="https://github.com/hansen-yi/hw04-stylization/assets/97490525/0f305504-e963-4556-ad6c-223693921357"> | <img width="500px" src="https://github.com/hansen-yi/hw04-stylization/assets/97490525/2ed1904e-875b-4887-bd56-43c6b18791f1"> |

Since my original reference didn't really have much variation in color or shadows, it made it rather difficult to use for this project so I looked into several different sources for additional references. The second reference is from [this video](https://www.youtube.com/watch?v=FUzJJB8wLvQ). The form that the character takes in these videos allows him to do all sorts of things so the animators played around with a lot of different styles when animating him and I tried to take inspiration from these different styles. For example, here is [another video](https://www.youtube.com/watch?v=PG2GLkqeMYM) that I looked at.
Credit to Toei Animation for all of these references

# Lighting
## Additional Light Support

Having already created a toon shader in Unity before, the first thing I did was add support for additional lights. This was done using a custom function that would detect additional lights in the scene and compute a color based on the additional lights that could be then added on top of the color in the scene.
| *No additional lights* | *One additional light* | *Two additional lights* |
|:--:|:--:|:--:|
|![No Lights](https://github.com/hansen-yi/hw04-stylization/assets/97490525/6008cf8a-381d-46ce-8815-3e0c7c18a883) | ![One Light](https://github.com/hansen-yi/hw04-stylization/assets/97490525/d29adbcf-0bdf-4b9b-98d6-33f833f094b5) | ![Two Lights](https://github.com/hansen-yi/hw04-stylization/assets/97490525/5ce1ceec-eaf6-4362-9c74-fc3d86d1bcf0) |

I utilized this in my final result to give sort of a glowing effect on my character:
<p align="center">
 <img src="https://github.com/hansen-yi/hw04-stylization/assets/97490525/77fff9ad-ab39-4d56-8c87-9eb14b982e8d" height="400">
</p>

## Specular Light
Next, I added specular light for each object in the scene. This was done in the shader graph by first accessing the view direction, negating that and reflecting that against the object's normal. The result of this was then dot producted with the direction of the main light and saturated to ensure that the output was still between 0 and 1. Then I created a parameter that could be used to determine how shiny the object would appear. This parameter is then used in a power node to "decrease" the size of the light. Finally, to keep the toon effect of the scene, I rounded the output.

![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/365beb16-7288-44f3-8de4-7acd9174f135)

Looking at the scene at this angle, you can see this effect on the character (his face and fist) and on rock structures in the background.

![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/3f9e998d-84b5-4ed9-9dc7-d29deb7c9bc5)

# Shadows

Since my reference image didn't have shadows (or not very stylized shadows), I opted to reference the creator of One Piece's shadows from the manga. For many of the darker shadows, the creator just shades it completely in black. However, the shadows on top of characters are pretty stylized. The lines are not perfectly parallel and often several lines are actually made up of multiple lines. The lines intersect and are hand drawn, and seem to be drawn pretty quickly.

|![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/233d421e-839f-4660-931e-1a519f93b4ba) |![IMG_3339](https://github.com/hansen-yi/hw04-stylization/assets/97490525/8128150a-1335-4dad-82f6-e900eb6a03a3) |  ![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/17343e99-84bb-48d4-b575-e889189b9020) | ![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/d39d88a4-0c39-496a-8269-09a3a1491806) | ![image](https://github.com/hansen-yi/hw04-stylization/assets/97490525/47c56b18-15b4-4fea-94a1-8d9a229878d4) |
|:--:|:--:|:--:|:--:|:--:|

Credit to Eiichiro Oda for these images

So I drew my own texture and used https://www.imgonline.com.ua/eng/make-seamless-texture.php to try and make it seamless. The results were not the best but they worked  for the purpose of this project (in addition it added to the imperfect aspect that the original shadows had).
<p align="center">
 <img src="https://github.com/hansen-yi/hw04-stylization/assets/97490525/5ffb85ff-6c3d-43cc-8dd9-599c50cada78" height="300">
</p>

Here is the shadow applied onto the objects into the scene, and it uses the objects UVs to ensure that the shadows wrap correctly on the object.
<p align = "center">
 <img src="https://github.com/hansen-yi/hw04-stylization/assets/97490525/81ea879a-b599-4be5-a910-9c4a2098d375">
</p>

# Special Surface Shaders
## Vertex Animation
The first special surface shader that I created was a vertex animation shader. Given specific parameters, the user can control how much of the character oscillates back and forth and how much it wobbles in a different direction. This shader was based on <a href="https://www.youtube.com/watch?v=VQxubpLxEqU&ab_channel=GabrielAguiarProd">this one</a>. However, since I wanted the character to be extending their arm in a sort of punch animation (this is something the character can do because they are made of rubber), I added inputs that would allow me to control the range of y and z values where the object was affected. The vertex animation is done by lerping between the original position and a position with a value added to the y direction (which is the forward direction for this mesh). There is additional "wobble" in the z direction to give it a bit more springiness.

![LuffyArmExtend](https://github.com/hansen-yi/hw04-stylization/assets/97490525/b4a6deef-485b-42c8-8540-e864ea801126)

## Animated Colors
The second special surface that I created was an animated color shader. This shader utilized several Lerp nodes to change between several different colors. For the interpolation, a sine function and a Time node were used to ensure a smoother interpolation between all the colors.

![LuffyColorChange](https://github.com/hansen-yi/hw04-stylization/assets/97490525/2bfec058-e385-4af2-b90e-15eb366dd340)

The inputs for this shader are slightly different which is why more of his body deforms.

# Post Processing
## Outlines
The outlines for this project are post processing outlines. They are rendered using a Full Screen Rendered Feature. The outlines consist of two types, one based on the objects' normals and one based on the objects' depths. The Depth outlines use the Sobel edge detection method, while the Normal outlines use the Robert's Cross edge detection method. Each type of outline uses data from a texture to generate the outlines, the Depth outlines uses Unity's built in depth texture and the Normal outlines use a custom one stored to a Normal Buffer. The Depth normals are modified using noise that has been offset by time. The noise is added to each of the points that the Sobel edge detection method samples to generate the outline resulting in a waving distorted outline that sort of resembles a glow or aura. The color of the outlines was based on my original reference image. Both outlines are combined using a Max node and then used a Blend node to combine with (MainTex of) the original scene.
| *Depth Outlines* | *Normal Outlines* |
|:--:|:--:|
|![Depth Outlines](https://github.com/hansen-yi/hw04-stylization/assets/97490525/b572e789-dff4-4fc0-9a0c-69728c0dbb6f) | ![Normal Outlines](https://github.com/hansen-yi/hw04-stylization/assets/97490525/c741f35e-a0ce-4cf3-b776-c0b90ea011ee) |

| *Both Outlines Together* |
|:--:|
|![Outlines](https://github.com/hansen-yi/hw04-stylization/assets/97490525/e79a5970-15f3-44e7-b565-98646f300509)|

## Full Screen Shader
An additional post-processing effect that I added was a lightning effect which was created by passing a UV that was a Lerp between the regular UVs and a noise UV into a Rectangle node. In addition, this UV was modified using a Tiling node and a Fraction node to split the UV into 5 allowing me to generate 5 lightning bolts. Then I repeated this with a Rectangle node with a different width to create an outline for the lightning. Finally, the lightning bolts were then placed on top of the scene using a Blend node.
![Lightning](https://github.com/hansen-yi/hw04-stylization/assets/97490525/211e998d-c41b-461a-9aeb-942ea06fe280)

# Interactivity
Using the space button, the user can switch between 3 separate scenes each set up with their own parameters. This is achieved by creating scripts and attaching them to several objects to allow the Space button to change either the material, property, or parameter of the object or shader. The full screen post processing shader, since it is not attached to any object, has its parameters modified using a script attached to a Global object. The background color is changed with a script attached to the Camera. The appearance of the one point light uses a script to change its intensity. Basically, everything else changes by iterating through an array of preset materials with their parameters manually tuned.

https://github.com/hansen-yi/hw04-stylization/assets/97490525/9544c683-c9bf-4f3b-a731-f5b772e0e70d

| *Scene 1* | *Scene 2* | *Scene 3* |
|:--:|:--:|:--:|
|![Lightning](https://github.com/hansen-yi/hw04-stylization/assets/97490525/211e998d-c41b-461a-9aeb-942ea06fe280) | ![Scene 2](https://github.com/hansen-yi/hw04-stylization/assets/97490525/07dff89e-967e-481a-9181-8ff0807d6f4d)  | ![Scene 3](https://github.com/hansen-yi/hw04-stylization/assets/97490525/226a5654-425b-4e47-a238-e1b55a879671) |

The second scene is attempt at a little clip from the [second reference's video](https://youtu.be/FUzJJB8wLvQ?si=6wH6Rg8r1JMDCJNF&t=22), and the third scene is an attempt at my original reference.

# Future Improvements
Some improvement that I definitely would like to do some time in the future are:
- To improve the third scene so that it is closer to my original reference, I think what it is really missing is the texture of the outlines as they are very distinct in the reference
- To figure out how to update the normals properly based on vertex deformation that way the Normal outlines will follow the deformed shapes as opposed to remaining still. Attempted [this](https://gamedevbill.com/shader-graph-normal-calculation/) fix, however didn't seem to work.
- Also, for the normal outlines, figure out how to update the Normal texture based on occlusion so that I can remove objects from the being mapped to the Normal texture but ensuring that the hidden outlines of the object don't show
   - This would also allow for assigning different color normal outlines to different objects
- I would also like to relook at the lightning shader and try to adjust how it spawns and the direction that it travels
- Finally, maybe improve the model as it is not completely accurate
- Another bonus would be to add more scenes and shaders for different and new effects!
 
# Sources
Models
- [Luffy](https://sketchfab.com/3d-models/luffy-9f437d56785b49558482e3f5bb2c299d)
- [Terrain](https://sketchfab.com/3d-models/mountainous-valley-102726ea9fa0411b994a5ca0c02de823)
- [Rocky Structure](https://sketchfab.com/3d-models/desert-high-cliff-f50a8315c11c488c8ccaddee814501b0)
- [Punch Pose and Animation](https://www.mixamo.com/)

Tutorials
- [Logan Cho Tutorials](https://www.youtube.com/playlist?list=PLEScZZttnDck7Mm_mnlHmLMfR3Q83xIGp)
- [Specular Light Explanation - Freya Holmér](https://www.youtube.com/watch?v=JmfQLHMw7N8)
- [Vertex Animation - Gabriel Aguiar Prod.](https://www.youtube.com/watch?v=VQxubpLxEqU&ab_channel=GabrielAguiarProd)
- [Sobel Edge Detection - NedMakesGames](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)
- [Robert's Cross Outlines - Robin Seibold](https://youtu.be/LMqio9NsqmM?si=zmtWxtdb1ViG2tFs)
- [Lightning Effect - Gabriel Aguiar Prod.](https://www.youtube.com/watch?v=40m_HUENh3E)
- [Updating Parameters in Script - Dapper Dino](https://www.youtube.com/watch?v=IQ7qnMv01Vs)
