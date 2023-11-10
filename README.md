# 3D Still Life Stylization in Unity

### Got an extension from Rachel until Friday 11/10 11:59 pm!

## Project Overview:
This project is an exploration of stylized graphics techniques alongside non-physically-based real-time rendering workflows in Unity, with the goal being to replicate a piece of 2D illustration into a 3D stylized scene.

## Inspiration

For the original 2D reference, I used the following illustration by artist [@chitchatchiou](https://twitter.com/chitchatchiou/status/1695202874374987852). I really liked the color scheme, composition, lighting, and visible texture, and tried to recreate the overall feel of the 2D concept in my final 3D scene.

<p align="center">
  <img width="650px" height=auto src=https://github.com/CIIINDYXUU/hw04-stylization/assets/88256581/0e6876e4-807d-4d23-909a-e479cc7f0fbd>
</p>

From @chitchatchiou's work, I got inspired by still-life drawings and wanted to replicate the texture that comes from cross-hatching and pencil on paper. In this project, I wanted to push the stylization of the original 2D illustration and combine the composition with a hand-drawn, sketchy feel.

| <img width="400px" src="https://www.pencil-topics.co.uk/images/fruit-bowl-still-life-finished.jpg"/> | <img width="450px" src="https://as2.ftcdn.net/v2/jpg/02/65/99/87/1000_F_265998700_ML2uNeokrXJOrU8huds8rQvjdv8KfXnr.jpg"/> |
|:--:|:--:|
| Color (Colored Pencil) | Black and White (Graphite) |


---
## Creating Custom Surface Shaders

### Multiple Light Support
I first used [Logan's Tutorial Video](https://youtu.be/1CJ-ZDSFsMM) to implement support for both directional and point lights.

![Screenshot 2023-11-09 153009](https://github.com/CIIINDYXUU/hw04-stylization/assets/88256581/28400048-fd2e-4546-a7bd-b13dd79c8ae6)

### Specular Highlight Feature


          
### Custom Hand-Drawn Textures
I used Photoshop to create custom hand-drawn textures for midtones and shadows.

### Custom Surface Shader Effect - Shadow Edge Coloring

---
## Adding Outlines
Specifically, we'll be creating ***Post Process Outlines*** based on Depth and Normal buffers of our scene!

### To-Do:
1. Render Features! Render Features are awesome, they let us add customizable render passes to any part of the render pipeline. To learn more about them, first, watch the following video which introduces an example usecase of a renderer feature in Unity:
    - [See here](https://youtu.be/GAh225QNpm0?si=XvKqVsvv9Gy1ufi3)
2. Next, let's explore the HW base code briely, and specifically, learn more about the "Full Screen Feature" that's included as part of your base project. There's a small part missing from "Full Screen Feature.cs" that's preventing it from applying any type of full screen shader to the screen. Your job is to solve this bug and in the process, learn how to create a Full Screen Shadergraph, and then have it actually affect the game view! Watch the following video to get a deeper break down of the Render Feature's code and some hints on what the solution may be.
    - [See here for Full Screen Render Feature Debugging Hints/Overview Video](https://youtu.be/Bc9eTlMPdjU)
4. Using what we've learnt about Render Features/URP as a base, let's now get access to the Depth and Normal Buffers of our scene!
    - Unity's Universal Render Pipeline actually already provides us with the option to have a depth buffer, and so obtaining a depth buffer is a very simple/trivial process.
    - This is not the case for a Normal Buffer, and thus, we need a render feature to render out the scene's normals into a render texture. Since the render feature for this has too much syntax specific fluff that's too Unity heavy and not very fun, I've provided a working render feature that renders objects' normals into a render texture in the /Render Features folder, called the "Normal Feature." There is also a shader provided, "Hidden/Normal Copy" or "Normal Copy.shader."
        - Your task is to add the Normal Feature to the render pipeline, make a material off of the Normal Copy shader and then plug it into the Normal Feature, and finally, connect the render texture called "Normal Buffer" located in the "/Buffers" directory as the destination target for the render feature.
            - Set the resolution of the Normal Buffer render texture to be equal to your game window resolution.
    - Watch the following video for clarifications on both of these processes, and also, how to actually access and read the depth and normal buffers once we've created them.
        - [See here for complete tutorial video on Depth and Normal Buffers](https://youtu.be/giLPZA-xAXk)


## 4. Creating the Scene (with a Post-Process Effect)
To capture the hand-drawn, sketchy feel, I added a post-process paper texture effect.


## 6. Adding Interactivity
To show off the fact that the scene is rendered in real-time, I added an element of interactivity to the scene. By pressing the SPACE button, the scene shifts from a colored version to a black-and-white version (resembling the colored pencil vs. graphite reference images.)

---

## Resources:

1. Link to all my videos:
    - [Playlist link](https://www.youtube.com/playlist?list=PLEScZZttnDck7Mm_mnlHmLMfR3Q83xIGp)
2. [Lab Video](https://youtu.be/jc5MLgzJong?si=JycYxROACJk8KpM4)
3. Very Helpful Creators/Videos from the internet
    - [Cyanilux](https://www.cyanilux.com/)
        - [Article on Depth in Unity | How depth buffers work!](https://www.cyanilux.com/tutorials/depth/) 
    - [NedMakesGames](https://www.youtube.com/@NedMakesGames)
        - [Toon Shader Lighting Tutorial](https://www.youtube.com/watch?v=GQyCPaThQnA&ab_channel=NedMakesGames)
        - [Tutorial on Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)
    - [MinionsArt](https://www.youtube.com/@MinionsArt)
        - [Toon Shader Tutorial](https://www.youtube.com/watch?v=FIP6I1x6lMA&ab_channel=MinionsArt)
    - [Brackeys](https://www.youtube.com/@Brackeys)
        - [Intro to Unity Shader Graph](https://www.youtube.com/watch?v=Ar9eIn4z6XE&ab_channel=Brackeys)
    - [Robin Seibold](https://www.youtube.com/@RobinSeibold)
        - [Tutorial on Depth and Normal Buffer Robert's Cross Outliens in Unity](https://youtu.be/LMqio9NsqmM?si=zmtWxtdb1ViG2tFs)
    - [Alexander Ameye](https://ameye.dev/about/)
        - [Article on Edge Detection Post Process Outlines in Unity](https://ameye.dev/notes/edge-detection-outlines/)
