# *3D Stylization*

## Project Overview:
In this project, I implemented two different stylizations using Unity ShaderGraph.

## Results
 * The initial reference was originally implemented in Unreal Engine. I incorporated certain features of it into my Unity shader.
    * I generated a brush stroke texture in Adobe Substance 3D Designer (DS) for the shader to sample, resulting in the creation of stroke-like features.
    * I utilized the dot product between the view direction and the object's normal to calculate the Fresnel term and then sampled the texture to produce eroded outlines based on that.
 * The second stylization essentially combines Toon mapping with an outline effect.
    * I introduced some noise to the UV coordinates I sampled for creating the outlines, giving them a wavy appearance. To ensure the outlines change only at discrete time steps, I employed a floor function.

| *Reference* | *My implementation in Unity* |
|:--:|:--:|
|<img width="450px" src=MdAssets//ref1.PNG />|<img width="500px" src=MdAssets//Stylize.gif /> 
|<img width="500px" src=https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/70550c09-ba75-4d10-9b30-60874179ad10/>|<img width="500px" src=MdAssets//Stylize2.gif />

## Resources:

1. Stylized paint shader
    - [Stylized paint shader breakdown](https://cyn-prod.com/stylized-paint-shader-breakdown)
    - [Stylized paint shader breakdown implementation](https://www.bilibili.com/video/BV1WV4y1q7YZ/?spm_id_from=333.788&vd_source=458aa72a37afffef2c151bd0069f1f6b)
2. Outlines
    - [NedMakesGames](https://www.youtube.com/@NedMakesGames)
        - [Tutorial on Depth Buffer Sobel Edge Detection Outlines in Unity URP](https://youtu.be/RMt6DcaMxcE?si=WI7H5zyECoaqBsqF)
    - [Robin Seibold](https://www.youtube.com/@RobinSeibold)
        -  [Tutorial on Depth and Normal Buffer Robert's Cross Outliens in Unity](https://youtu.be/LMqio9NsqmM?si=zmtWxtdb1ViG2tFs)
