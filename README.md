# HW 4: *3D Stylization - Watercolor and oil painting*

## Project View & Demo
This is the project inspired from 2D concept art to produce a 3D stylized interactive scene in Unity. Here, I produced shaders to mimic watercolor art for any 3D object.

![](img/final.png)

![](img/res_small.gif)

You may find a change of style between watercolor art and oil painting art style. It is interactive by clicking space anytime in the scene at "Assets/Scenes/HW final.unity".

## 2D concept art inspiration and reference

I don't refer to a completely same 2D concept art to reproduce the scene. Instead, I refered a series of art style and character art:
||Watercolor art style|Oil paint art style|Eevee model|
|----|----|----|----|
|Ref Images|![](img/ref/watercolor.jpg)|![](img/ref/oil%20paint.jpg)|![](https://github.com/CIS-566-Fall-2023/hw04-stylization/assets/72320867/48521733-f83a-4704-ac8d-9d2f24574922)|
|Link|https://stock.adobe.com/search/images?k=watercolor+landscape+village|https://stock.adobe.com/search/images?k=oil+paint+landscape+village|https://twitter.com/caomor/status/1049494055518908416|


Also, to produce the final style, I refered to a series of similar shader on ArtStation and Shadertoy:
|Reference image|Link|
|----|----|
|![](img/ref/cedric-loehr-highresscreenshot00015.jpg)|https://www.artstation.com/artwork/X1mmqa|
|![](img/ref/steven-tang-highresscreenshot00017.jpg)|https://www.artstation.com/artwork/lmO6G|
|![](img/ref/watercolour.png)|https://cyangamedev.wordpress.com/2020/10/06/watercolour-shader-experiments/|
|![](img/ref/Snipaste_2023-11-06_00-30-32.png)|https://www.shadertoy.com/view/ltyGRV|

## Shader pipeline
  - Additional light support: I added multiple light support and additional lighting features. In the original reference of eevee, highlight of specular light is important to produce a cute outlook. I also added some rim highlight on the side.
  ![](img/additional_light.png)
  - New shadow texture and surface animation: I use a line texture as the shadow with the object's uv to sample it. Also, I use a interpolation to change the color pallete of the whole color tune of the model.

  Here is a surface shader animation of the eevee model on base scene.
  ![](img/res_simple.gif)

  - Outlines: I use the gradient in depth buffer to obtain the line on the edge of the model and the scene, and I use different float value to control line thickness and color. To make the outline more vivid, I try to use a stroke mask aside with flipbook node to add noise to the original uv. This will provide an old-school animation play effect with different pages turning.

  - Post effect: This is where I mainly spend time upon. I use a function to gradually blur the strokes based on its gradient in several iterations and keep the color in parallel to the gradient. After blurring the scene to fetch the bleeding coloring effect, I deepen the edges and add the paper texture to it. In the oil painting version of the scene, I use a kuwahara filter to smooth the image while perserving the edge.

  |Watercolor art style|Oil paint art style|
  |----|----|
  |![](img/final.png)|![](img/oil.png)|

