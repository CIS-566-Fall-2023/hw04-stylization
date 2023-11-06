# *3D Stylization*

## Project Overview
In this assignment, I implement a toon style 3D sea island scene in Unity URP pipeline.

![](/Recordings/result.png)

As you can see, the player could switch between the normal 3D PBR shading and toon style shading, when pressing SPACE.

![](/Recordings/gif.gif)

## Inspiration

I have several reference images, which altogether inspire me to achive this project. To make this project more creative, artistic and wonderful, I made some small adjustments on details based on my understanding.

| Image | ![](/ref_0.png) | ![](https://user-images.githubusercontent.com/72320867/278452211-ae1d0fae-7998-4287-8269-13e2cafd740b.jpg) | ![](https://user-images.githubusercontent.com/72320867/278458163-dae1ffc2-8269-493d-919f-b3811c76ed30.jpg) |
| :--: | :--: | :--: | :--: |
| Source | https://store.steampowered.com/app/1156990/_Return_to_Shironagasu_Island/ | https://twitter.com/cysketch/status/1712442821389713597 | https://twitter.com/stefscribbles/status/1646235145110683650 |

## Toon Shading Surface Shader

### Shading

Below is the toon light shading effect I implement. Besides diffuse light, I also implement specular light.

![](/Recordings/1.png)

What's more, I implement a special rim shading effect. The rim part of the model in player's view is darker than center part.

![](/Recordings/4.png)

### Additional Light

![](/Recordings/2.png)

The additional light is supported in my shader.

### Shadow

![](/Recordings/3.png)

I implement the special shadow effect, with the texture I created in Substance Designer.

![](/Assets/Textures/MyShadow_7.png)

## Water Surface Shader

I implement a stylized water shader. The shader has four main features.

![](/Recordings/water.gif)

![](/Recordings/water.png)

### Gernester Wave Vertex Animation
Using Gernester wave function, I immplement water wave vertex animation which is more complex than sin wave.

### Toon Style Caustic Texture
I generate the Toon style caustic texture using Substance Designer.

![](/Assets/Textures/toon_caustic_1.png)

### Foam Effect On Boundary & Transparency and Color Change

The theory behind these two features are similar. I use depth texture to calculate the depth difference between the water and the corresponding point under water in viewport.

While the depth difference is very small, this part is considered to be boundary part, which has foam. Otherwise, as the water is shallow, the transparency is higher and the color is lighter.

## Outline

![](/Recordings/result_without_post.png)

Based on sobel edge detection, I sample a noise texture which I created in SD, to make it looks like crayon sketching.

## PostEffect

![](/Recordings/result.png)

I sample a normal texture to simulate the paper effect in post-processing stage, where the normal texture is also created in SD.

![](/Assets/Textures/paper_normal_1.png)