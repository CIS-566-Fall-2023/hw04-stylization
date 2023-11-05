
## Demo
### GIF
![pic](/img/2023-11-05-03-15-14.gif){:height="80%" width="80%"}
![pic](/img/2023-11-05-03-18-55.gif){:height="80%" width="80%"}
<br/>
### Video
<iframe src="//player.bilibili.com/player.html?aid=323074799&bvid=BV1rw411s7Th&cid=1322842424&p=1" width="800" height="500" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
<iframe src="//player.bilibili.com/player.html?aid=918042889&bvid=BV1wu4y187Rj&cid=1322851006&p=1" width="800" height="500" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
<br/>

### Inspiration 
![pic](/img/r1.jpg){:height="50%" width="50%"} ![pic](/img/r2.jpg){:height="50%" width="50%"}
[@agu_knzml](https://twitter.com/agu_knzm)


## Process
### 1. Basic surface shaders & shadow 
To mimic the styles usually used in manga , I created 4 base materials : basic black, basic white, halftone points, and a gray-scale one with stripes. And also a shadow material with texture. Here the halftone is based on the combination of diffuse and how far a fragment is from the edge.
![pic](/img/base.png){:height="100%" width="100%"}
<br/>
### 2. Outline
Normal extrusion outline created by moving the vertices along their normal vector. This pass is added as a URP Render Objects Feature.
Our spheres now looks like:
![pic](/img/outline.png){:height="100%" width="100%"}
<br/>
### 3. Rim & pecular 
Very simple rim and specular. Here for the rim I used haftone points again based on how far a fragment is from the edge. This is also added as a URP Render Objects Feature.
![pic](/img/rim.png){:height="100%" width="100%"}
<br/>
### 4. Post process white edge 
I moved the full screen outline pass to be before rendering opaques so that full screen outline doesn't cover anything we draw. Now it is actually using only the normal buffer to calculate the edges, but it is enough for what I wanna do. It ran twice, one without noises for the wide white outline, and one with noise for the noisy white color in the back.
![pic](/img/edge.png){:height="100%" width="100%"}
<br/>
### 4. Post process book paper effect
![pic](/img/paper.png){:height="100%" width="100%"}
<br/>

## Some homework requirements
### Post process outline
For the outline, at first I tried the method required for this homework, post process outlines based on depth and normal buffers. It looks like not working really well with my target style.
![pic](/img/dn_outline.png){:height="100%" width="100%"}
Then I tried the normal extrusion method which moves the vertices along their normal vector. This one looks better.
![pic](/img/ex_outline.png){:height="100%" width="100%"}
The post process outline shader is not wasted, it was used later for creating the white edge and noise in the background.
<br/>
### Multiple light support
![pic](/img/mult.gif){:height="100%" width="100%"}
<br/>

## Reference
- [Normal extrusion outline](https://zhuanlan.zhihu.com/p/361285222)
- [Post process outline](https://youtu.be/LMqio9NsqmM?si=zmtWxtdb1ViG2tFs)
- [Halftone](https://zhuanlan.zhihu.com/p/321884529)
- [Nier model](https://sketchfab.com/3d-models/nier-automata-3d-print-figure-1027cd12a93341e1ab15105415696a9a)
- [Small car model](https://sketchfab.com/3d-models/thermal-ex-from-arknights-02986155f515462ab2507bb4ac9563e7)
- Other models are from Unity assets store
