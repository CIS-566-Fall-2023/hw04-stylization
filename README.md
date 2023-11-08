# Stylized Worlds

## [Live Interactive Demo](https://utkarshdwivedi3997.github.io/cis566-hw04-stylization/)

# Project Overview

This project is a small stylization experiment I did for a homework in my Procedural Graphics course at the University of Pennsylvania. It was completed in roughly 5 days.

The original goal was to take a piece of concept art and make a stylized scene in the Unity Engine inspired by that concept art. I took a slightly modified approach

# Table of Contents
- [Stylized Worlds](#stylized-worlds)
  - [Live Interactive Demo](#live-interactive-demo)
- [Project Overview](#project-overview)
- [Table of Contents](#table-of-contents)
- [Breakdown](#breakdown)
  - [Inspirations](#inspirations)
  - [Toon Shading](#toon-shading)
  - [Outlines](#outlines)
  - [Dithered Fading](#dithered-fading)
  - [Gerstner Waves](#gerstner-waves)
  - [Portal Distortion](#portal-distortion)
  - ["Vignette?"](#vignette)
  - [Skybox](#skybox)
  - [Dimensional Travel](#dimensional-travel)
  - [Credits](#credits)
    - [Style Inspirations](#style-inspirations)
    - [3D Models](#3d-models)
    - [Fonts](#fonts)
    - [Outlines](#outlines-1)
    - [Gerstner Waves](#gerstner-waves-1)

# Breakdown

## Inspirations

1. [This trailer](https://www.youtube.com/watch?v=IfKNOUUtyCA) for the movie Suzume has been something I keep going back to every once in a while. I haven't even seen the movie yet, but the trailer itself is just so aesthetically pleasing! The very first shot of a door is something that I wanted to recreate in some way, and that's where the mysterious door theme came from in this project.

    While Suzume's art style is great, it was a little too complex for such a short project. Rendering grass that looked good and performed well on a WebGL build was a little out of scope - so I looked elsewhere for the general visual art style.

|Suzume Movie Poster|
|:-:|
|<img src="img/suzumeDoor.png" width=400>|

2. [Gris](https://www.youtube.com/watch?v=BRiKQIVo7ao) by Nomada Studio uses a very minimalistic, water-coloured, aesthetic with simple outlines, and the analogous colour scheme is very pleasing. This is what I decided to try and replicate.

|Gris Trailer Screenshot|
|:-:|
|<img src="img/gris1.png" width=500>|

3. At some point while working on this project, I got inspired to do something with the mysterious doors that was a little more interesting than just scattering a bunch of doors over the scene. I decided to find another art style that would be relatively easy to create with the shaders I had already created, but would still be a stark contrast to the main style. The door would act as a portal from one realm to the other. I found [this artwork by "rudut2015"](https://stock.adobe.com/images/japan-traditional-japanese-painting-sumi-e-art-sun-mountain-sakura-lake/156204903) for this purpose.

|Artwork|
|:-:|
|<img src="img/japaneseArt1.png" width=500>|

## Toon Shading

Suzume, like most anime, uses a toon shaded art style. Toon shading is a great basis look to start off of.

![](img/toon1.png)

The shader graph for this toon shader looks very complex, but it is rather simple in concept. It first performs Lambertian shading on a model, then `step`s anything above a certain threshold to the lit area of the surface, and everything else into the unlit (in shadow) area of the surface. There is an additional `step` that finds a "midtone" between the lit and shadow colours (the midtone colour is a halfway lerp between the lit and shadow colours), and this colour is put in between the lit and shadow areas.

I added support for **textures** on the shadow and midtone sections. This can be used to add something like a hatched shadow effect, though that is not something that is used in the demo scene. Additional lights are also supported, but similarly not used.

|Simple Toon Shading|
|:-:|
|<img src="img/scene1.png" width=500>|

One of the things that Gris does is affect surfaces based on a watercolour like texture sampled in screen-space. I first tried to do this by sampling a texture only in the lit areas, but that didn't look good, so I changed this texture to be an *overlay* on top of the whole surface. This looked a lot closer to the Gris art style.

I created a few "watercolour" textures in Photoshop to overlay on to the scene, and allowed manually changing the colour for this overlay.

<table>
    <tr>
        <td colSpan=3 align="center">Watercolour textures</td>
    </tr>
    <tr>
        <td><img src="Assets/Textures/watercolor_texture.jpg" width=200></td>
        <td><img src="Assets/Textures/watercolor_texture_2.jpg" width=200></td>
        <td><img src="Assets/Textures/watercolor_texture_3.jpg" width=200></td>
    <tr>
</table>

|Toon Shading + Screen Space Sampled Texture Overlay|
|:-:|
|<img src="img/scene2.png" width=500>|

Something that I tried was to scroll multiple textures at varying speeds in different directions over the surface and then using the multiplied result of that as the overlay texture. The results looked good but it added too much motion to the scene, removing the focus from the doors, so I decided to scrape this idea.

## Outlines

## Dithered Fading

## Gerstner Waves

## Portal Distortion

## "Vignette?"

## Skybox

## Dimensional Travel

## Credits

### Style Inspirations
- [This Gris trailer by Nomada Studio](https://www.youtube.com/watch?v=BRiKQIVo7ao)
- [Suzume's door aesthetics](https://www.suzume-movie.com/home/)
- [This artwork by "rudut2015"](https://stock.adobe.com/images/japan-traditional-japanese-painting-sumi-e-art-sun-mountain-sakura-lake/156204903)

### 3D Models
- [Door Model by Arnau Rocher Alcayde](https://sketchfab.com/3d-models/door-d6b9b84b78ae4462a6cf021b412085fe)
- [Palm Tree Models by Parelaxel](https://sketchfab.com/3d-models/stylized-palm-tree-set-b84b734847344cb6a81b9102a64ac63b)
- Other scene assets (rocks, more palm trees, big rocks) by my friend [Ben Spurr](https://www.linkedin.com/in/ben-spurr-3d/)

### Fonts
- ['Anime Ace' by Blambot Fonts](https://www.urbanfonts.com/fonts/Anime_Ace.font)
- ['Eatn Cake' by Chris Vile](https://www.dafont.com/eatn-cake.font)

### Outlines 
- [Tutorial on Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)

### Gerstner Waves
- [Catlike Coding's Gerstner Waves tutorial](https://catlikecoding.com/unity/tutorials/flow/waves/)
- [Stylized Station's "how water works in Sea of Thieves" video](https://www.youtube.com/watch?v=EMb_FUmr0Ts)