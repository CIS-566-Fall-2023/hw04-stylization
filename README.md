# 0. Context & My Result
For this project, I looked to recreate the character toon-shading effect used in Genshin. I used Klee, an iconic character, as my base model to work from. Thanks to Rachel who allowed me to explore the project in Unreal Engine instead :)
## Completed Viewport Screenshot in Unreal of My Character Materials:
![HighresScreenshot00001](https://github.com/xcupsilon/hw04-stylization/assets/50472308/5763a360-d81a-48e5-a3a8-3fd369d1250d)

# 1. Original Concept Art
Found some nice in-game screenshots in Genshin:
![image](https://github.com/xcupsilon/hw04-stylization/assets/50472308/22fe919d-2012-4d8f-b2b7-fd8a3910ab92)
![image](https://github.com/xcupsilon/hw04-stylization/assets/50472308/d3c01477-1874-47ed-b0e7-86d89ac22b46)
---
# 2. Shader Creation
## Base Color
![HighresScreenshot_2023 11 06-00 52 57](https://github.com/xcupsilon/hw04-stylization/assets/50472308/d9f7cce2-90ab-4a35-84f6-57045fe6c76e)

## Simple Dot with Sunlight Sampling
![Dot](https://github.com/xcupsilon/hw04-stylization/assets/50472308/fb0fa9c7-2306-4826-aedb-6b7ddf604b29)
<img width="646" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/09c6728b-f922-4246-a07e-9845a583d6f1">

## CelShading: Color Lookup Using a Custom Color Curve
![LUT](https://github.com/xcupsilon/hw04-stylization/assets/50472308/e0c1ab5d-e130-47c6-8d64-4641ddeb61ce)
<img width="1089" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/934fea4c-7565-4163-b114-e207cf87765d">

## Slight Self-Shadowing by Sampling a Simple Light/Shade Texture using Matcap UV
![SelfShade](https://github.com/xcupsilon/hw04-stylization/assets/50472308/d929c9aa-a1cf-4854-bfed-bb24084f760c)
<img width="1438" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/debdab8b-6c3c-4cbb-8f8c-a8a166587071">

## Custom 1: Specular Rendering (Talked with Rachel to replace multiple lighting support)
![ezgif com-video-to-gif (2)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/11d46889-9a62-40d1-b66f-2b9195479d1e)
![ezgif com-video-to-gif (1)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/01ac7936-8064-4fff-bf69-3bdce579f8bc)

Achieved through reading PBR info from channels of the lightmap and compute using BlinnPhong

<img width="643" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/66243f02-053b-4efc-af42-7c75dfd3d034">
<img width="1045" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/b679efc7-a01c-4afa-9903-5deec1cdd398">

## Custom 2 Additional Light Feature: Metallic Rendering
![Metallic](https://github.com/xcupsilon/hw04-stylization/assets/50472308/1e478734-b605-43ad-bc73-0ec00fb4df72)
<img width="414" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/4e5909d2-948b-4936-9f7c-c63c58657827">
<img width="851" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/4d30026c-7ff2-4e01-bf41-1b4176c848e5">

MetalMap used:

![Avatar_Tex_MetalMap](https://github.com/xcupsilon/hw04-stylization/assets/50472308/36ba6bda-8821-4154-9754-a905c23ba9c4)


## Diffuse + Specular + Metallic Combined Result 
![ezgif com-video-to-gif (3)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/da399cae-f6f6-4f1d-bfa4-d365b90bb728)

## Custom Shadow Texture
World-Aligned Shadow Texture Mapping

![ezgif com-video-to-gif (5)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/043c8a2f-3ea2-47dd-b421-e3d7eb519cd6)
![ezgif com-video-to-gif (6)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/4b7869aa-cbaf-4ae3-aa38-2d8fdaf18862)

## Special Surface Shader: Custom SDF & Normal-Based Face Rendering
![SDF](https://github.com/xcupsilon/hw04-stylization/assets/50472308/6a2db61b-2ce2-454a-90be-6666fff60883)
Old:

![ezgif com-video-to-gif (7)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/e4c5c8bf-3053-4987-8f20-232a815ffaa8)

New:

![ezgif com-video-to-gif (8)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/939f4eb8-1fa7-4a52-8415-35e8e46ad1da)

SDF-based Shadow Calculation

<img width="1305" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/b1cd237c-c71f-49c2-b3a5-9c2d4dc49e62">

Lerping Artist-Controlled Light and Shadow Colors
<img width="1030" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/13bd97a8-e404-49d9-b69d-5fed87ca1954">


## Outline
Base Outline
![Outline](https://github.com/xcupsilon/hw04-stylization/assets/50472308/feae656b-c9b3-4348-8bac-65e1457d4950)
<img width="1458" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/c5be0ff7-18e0-4161-ac84-d43547faec41">

Using Noise to Offset Outline Based on Time For a Windy Effect on Hair
![ezgif com-video-to-gif (4)](https://github.com/xcupsilon/hw04-stylization/assets/50472308/3082d987-ab09-4476-94e5-00b13f330a8a)
<img width="1349" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/1965eba6-a487-4dc8-96ea-51bb9659fb08">

## Pixel Art Screen Post Process Effect
Threshold at 1/10:
![Pixelated10](https://github.com/xcupsilon/hw04-stylization/assets/50472308/661a5788-1ac3-45ab-80e5-2af206897c1b)
Threshold at 1/20:
![Pixelated20](https://github.com/xcupsilon/hw04-stylization/assets/50472308/a1f7dc3e-2398-4fee-b361-6d54ca0efabe)
Threshold at 1/29:
![Pixalted29](https://github.com/xcupsilon/hw04-stylization/assets/50472308/47638dad-03fa-4660-a1ab-f348b978c435)
<img width="997" alt="image" src="https://github.com/xcupsilon/hw04-stylization/assets/50472308/8f2ec0ac-9538-4b5e-94fa-9e24ceca10c1">

# 3. Game Scene & Interactivity
I used some marketplace assets that closely resembled Genshin Impact's modeling styles with the architecture mirroring the city where the character was from: "Mondstadt". Then I added my own lighting setup and post processes effect to it.

Here is one of my final hero render: 
![HighresScreenshot00001](https://github.com/xcupsilon/hw04-stylization/assets/50472308/5763a360-d81a-48e5-a3a8-3fd369d1250d)

For the interactivity part, I wanted to showcase the shader performing at different lighting scenarios: another one at dawn, and another very stylized one. I implemented functions that would quick unload/load different lighting components & post process materials to achieve this. Here are the results:

---
## 4. Full Screen Post Process Effect
We're nearing the end! 

### To-Do:
Ok, now regardless of what your concept art looks like, using what you know about toolbox functions and screen space effects, add an appealing post-process effect to give your scene a unique look. Your post processing effect should do at least one of the following.
* A vingette that darkens the edges of your images with a color or pattern
* Color / tone mapping that changes the colorization of your renders. [Here's some basic ideas, but please experiment](https://gmshaders.com/tutorials/basic_colors/) 
* A texture to make your image look like it's drawn on paper or some other surface.
* A blur to make your image look smudged.
* Fog or clouds that drift over your scene
* Whatever else you can think of that complements your scene!

***Note: This should be easily accomplishable using what you should have already learnt about working with Unity's Custom Render Features from the Outline section!***

---
## 5. Create a Scene
Using Unity's controls, create a ***SUPER BASIC*** scene with a few elements to show off your unique rendering stylization. Be sure to apply the materials you've created. Please don't go crazy with the geometry -- then you'll have github problems if your files are too large. [See here](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github). 

Note that your modelling will NOT be graded at all for this assignment. It is **NOT** expected that your scene will be a one-to-one faithful replica of your concept art. You are **STRONGLY ENCOURAGED** to find free assets online, even if they don't strongly resemble the geometry/objects present in your concept art. (TLDR; If you choose to model your own geometry for this project, be aware of the time-constraint and risk!)

Some example resources for finding 3D assets to populate your scene With:
1. [SketchFab](https://sketchfab.com/)
2. [Mixamo](https://www.mixamo.com/#/)
3. [TurboSquid](https://www.turbosquid.com/)

## 6. Interactivity
As a finishing touch, let's show off the fact that our scene is rendered in real-time! Please add an element of interactivity to your scene. Change some major visual aspect of your scene on a keypress. The triggered change could be
* Party mode (things speed up, different colorization)
* Memory mode (different post-processing effects to color you scene differently)
* Fanart mode (different surface shaders, as if done by a different artist)
* Whatever else you can think of! Combine these ideas, or come up with something new. Just note, your interactive change should be at least as complex as implementing a new type of post processing effect or surface shader. We'll be disappointed if its just a parameter change. There should be significant visual change.

### To-Do:
* Create at least one new material to be swapped in using a key press
* Create and attach a new C# script that listens for a key press and swaps out the material on that key press. 
Your C# script should look something like this:
```
public Material[] materials;
private MeshRenderer meshRenderer;
int index;

void Start () {
          meshRenderer = GetComponent<MeshRenderer>();
}

void Update () {
          if (Input.GetKeyDown(KeyCode.Space)){
                 index = (index + 1) % materials.Count;
                 SwapToNextMaterial(index);
          }
}

void SwapToNextMaterial (int index) {
          meshRenderer.material = materials[index % materials.Count];
}
```
* Attach the c# script as a component to the object(s) that you want to change on keypress
* Assign all the relevant materials to the Materials list field so you object knows what to swap between.
 
---
## 7. Extra Credit
Explore! What else can you do to polish your scene?
  
- Implement Texture Support for your Toon Surface Shader with Appealing Procedural Coloring.
    - I.e. The procedural coloring needs to be more than just multiplying by 0.6 or 1.5 to decrease/increase the value. Consider more deeply the relationship between things such as value and saturation in artist-crafted color palettes? 
- Add an interesting terrain with grass and/or other interesting features
- Implement a Custom Skybox alongside a day-night cycle lighting script that changes the main directional light's colors and direction over time.
- Add water puddles with screenspace reflections!
- Any other similar level of extra spice to your scene : ) (Evaluated on a case-by-case basis by TAs/Rachel/Adam)

## Submission
1. Video of a turnaround of your scene
2. A comprehensive readme doc that outlines all of the different components you accomplished throughout the homework. 
3. All your source files, submitted as a PR against this repository.

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
