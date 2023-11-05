# *Unity: Stylized Illustration Shader*

## Project Overview:
The goal of this project was to learn how to use the Unity Shader graph and experiment with mimicking a target style using stylized rendering. 

| <img width="500px" src=https://github.com/Diana-ou/hw04-stylization/blob/main/darkness.jpg  | <img width="500px" src=https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/70550c09-ba75-4d10-9b30-60874179ad10/> |
|:--:|:--:|
| *2D Concept Illustration* | *Stylized Scene in Unity* |


### Table of Contents:
1. Picking a Piece of Concept Art
2. Developing the shaders
3. Outlines
4. Full Screen Post Process Effect
5. Creating a Scene
6. Extra Polish

---
## 1. Picking a Piece of Concept Art

My inspiration for this project started with 15th-century style metal engraving, but seeing how moody things looked, quickly increased in scope. Some of the inspirations for this scene include:   

| ![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/dae1ffc2-8269-493d-919f-b3811c76ed30) | ![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/9c345ee6-19df-4191-9e47-6722b6597a5a) | ![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/48521733-f83a-4704-ac8d-9d2f24574922) | ![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/3068bdc4-1b08-41cf-9a16-08d94be5f1ea) |  ![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/ae1d0fae-7998-4287-8269-13e2cafd740b) | 
|:--:|:--:|:--:|:--:|:--:|
| *https://twitter.com/stefscribbles/status/1646235145110683650* | *https://twitter.com/trudicastle/status/1122648793009098752* | *https://twitter.com/caomor/status/1049494055518908416* | *https://www.artstation.com/requinoesis* | *https://twitter.com/cysketch/status/1712442821389713597* | 


---
## 2. Interesting Shaders
- **Improved Surface Shader**
  - **Multiple Light Support:** Followed this [tutorial](https://youtu.be/1CJ-ZDSFsMM) to implement multiple light support.
  - **Speculars:** Added parameter to allow shadergraph to add speculars. 
- **Texturing:**
  - Hand-drew my own pencil hatch shadow to get a more sketch-like effect:
     [](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/dae1ffc2-8269-493d-919f-b3811c76ed30)
  - I also added a paper material in order to get the ink-on-paper effect.
- **Special Surface Shader:** Added time-based UV offsets to sell the hand-drawn effect.

## 3. Outlines
To really sell the hand-drawn look, I needed to implement outlines. I followed [Robin Seibold's](https://www.youtube.com/@RobinSeibold) tutorial to implement Robert's cross depth and normal-based outline. Furthermore, outline UVs are also mildly deformed to give the entire shader a hand-drawn look. 

---
## 4. Full Screen Post Process Effect:
I added a full-screen post process that adds noise to the entire screen. This simply makes the scene a bit more  organic. 

---
## 5. Create a Scene
To finally assemble the scene, I took some amazing assets of the [praying astronauts](), [darkness devil](), [grass](), and [mysterious stains](). The text assets are self-made using Blender.

---
## 6. Extra Polish
- For fun and to further stretch my shader-building skills, I added another post-process that mimics the style of monochromatic pixel-games. This buckets the UVs and turns the color palette green.
