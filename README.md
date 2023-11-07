# Chinese Painting Stylized Rendering

For this project, I created a Chinese Painting stylized shader. Here is the result.


https://github.com/horo-ursa/hw04-stylization/assets/54868517/e06286c4-e9fe-4edd-80c0-6e001e8524c8


## Concept Art

My idea for this project mainly came from this `Thousand Miles of Mountains and Rivers 千里江山圖`, which is a very famous Chinese scroll painting. The idea for this scene came from this Poetry `《江雪》` by Zongyuan Liu.

| <img height="500px" width="300px" src=https://github.com/horo-ursa/hw04-stylization/assets/54868517/c85f1468-f0f8-4add-8129-55e094ff5908/>  | <img height="300px" width="500px" src=https://github.com/horo-ursa/hw04-stylization/assets/54868517/02776b40-358b-4227-9f27-aea58cfaca6f/> |
|:--:|:--:|
| *Concept Art* | *Concept Art* |

 ## Interior

<img height="300px" width="330px" src=https://github.com/horo-ursa/hw04-stylization/assets/54868517/8cbe7970-6d81-4ee5-b611-b914964445ec/>

The interior is very similar to classic toon shading. The difference is that in order to create this Chinese painting ink look, I added some Perlin noise to disturb the uv coordinate, and also used the 3x3 Gaussian Kernal to blur the result.

## Post-Process

### Outline

<img height="300px" width="330px" src=https://github.com/horo-ursa/hw04-stylization/assets/54868517/8cbe7970-6d81-4ee5-b611-b914964445ec/>

There are two passes for my post-process outline to mimic the Chinese writing brush. In the first pass(black), I draw the backface of the object and also move the vertex out along the normal direction. In the second pass(red), I move the vertex out slightly more than in the first pass, and also add some Perlin noise to it to create the discontinuity brush look.

### Rice Paper

<img height="400px" width="668px" src=https://github.com/horo-ursa/hw04-stylization/assets/54868517/8cf9e7ba-f6ed-4746-8877-52e2109cd93c/>


To create the rice paper look, I used another post-process pass, which steals the bloom texture created by Unity's default post-process, and then combined it with a Voronoi noise to create the dotted effect. There are a bunch of parameters that can control this process, like Dot Density, Dot Cutoff, Threshold, Intensity, etc.

### basic requirements

all basic requirements are implemented in the Additional Lighting scenes.

## Credits
[Post-Process](https://www.youtube.com/watch?v=9fa4uFm1eCE&t=332s)

[Chinese Painting 1](https://zhuanlan.zhihu.com/p/63893540)

[Chinese Paintint 2](https://zhuanlan.zhihu.com/p/98948117)

[SRP Reference](https://xibanya.github.io/URPShaderViewer/Library/URP/ShaderLibrary/ShaderVariablesFunctions.html)
