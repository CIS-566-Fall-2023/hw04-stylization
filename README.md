# HW 4: *3D Stylization*

## Result

https://github.com/IwakuraRein/CIS-566-hw04-stylization/assets/28486541/5057922b-4473-4bd0-8405-8b31d6e1cc11

## Reference

![iwakura_lain_serial_experiments_lain_drawn_by_soggyworms](https://github.com/IwakuraRein/CIS-566-hw04-stylization/assets/28486541/42406586-bb2a-4810-82d5-50da0f907d2e)

Author: [𝖘𝖍𝖆𝖓𝖓𝖎](https://twitter.com/soggyworms)

The skeletal mesh I used is from http://sprishri.nobody.jp/mmd_model1.html:

![image](https://github.com/IwakuraRein/CIS-566-hw04-stylization/assets/28486541/17eb2663-f0b1-4d49-8ddd-c1b0aeadc9c8)

I used Maya to modify the UV of her eye to glance sideways. 

I also used some animation from Mixamo to pose her.

## Interesting Shaders

The surface shaders I used are based on the toon shader in Lab 05. I used different approaches for her skin and clothes.

- I added a transitional zone between highlight and shadow to make the skin look more natural:

![](Doc/2.png)

- For her clothes, I used two sketch-look textures for the shadow and transitional zone:

![](Doc/1.png)

- Based on the Reference Art, there is no need for multiple light sources except for the can which has additional highlights. I added a point light source to simulate it.

![](Doc/3.png)

- I make the shadow on her clothes jitter by randomly altering the UV:

![](Doc/4.gif)

## Outlines

- I used the Sobel operator to detect edges on the normal map and depth map:

    ```C
    void normalEdge_float(float2 uv, float2 texelSize, out float edge)
    {
        float3 horizontal = 0, vertical = 0, value = 0;
        sobelEdgeCheck(uv, -1.0 * texelSize.x, -1.0 * texelSize.y, value);
        horizontal += -1.0 * value;
        sobelEdgeCheck(uv, -1.0 * texelSize.x,  0.0 * texelSize.y, value);
        horizontal += -2.0 * value;
        sobelEdgeCheck(uv, -1.0 * texelSize.x,  1.0 * texelSize.y, value);
        horizontal += -1.0 * value;
        sobelEdgeCheck(uv,  1.0 * texelSize.x, -1.0 * texelSize.y, value);
        horizontal +=  1.0 * value;
        sobelEdgeCheck(uv,  1.0 * texelSize.x,  0.0 * texelSize.y, value);
        horizontal +=  2.0 * value;
        sobelEdgeCheck(uv,  1.0 * texelSize.x,  1.0 * texelSize.y, value);
        horizontal +=  1.0 * value;
        sobelEdgeCheck(uv, -1.0 * texelSize.x, -1.0 * texelSize.y, value);
        vertical += -1.0 * value;
        sobelEdgeCheck(uv,  0.0 * texelSize.x, -1.0 * texelSize.y, value);
        vertical += -2.0 * value;
        sobelEdgeCheck(uv,  1.0 * texelSize.x, -1.0 * texelSize.y, value);
        vertical += -1.0 * value;
        sobelEdgeCheck(uv, -1.0 * texelSize.x,  1.0 * texelSize.y, value);
        vertical +=  1.0 * value;
        sobelEdgeCheck(uv,  0.0 * texelSize.x,  1.0 * texelSize.y, value);
        vertical +=  2.0 * value;
        sobelEdgeCheck(uv,  1.0 * texelSize.x,  1.0 * texelSize.y, value);
        vertical +=  1.0 * value;

        edge = sqrt(dot(horizontal.xyz, horizontal.xyz) + dot(vertical.xyz, vertical.xyz));
    }
    ```

- Since I don't want outlines on her face, I implemented the normal outline within the toon shader and added a switch for it. For the depth outline, I implemented it in a fullscreen render feature.

- I use Perlin noise to offset the UV when sampling the normal/depth map to make it more sketch-like:

    ![](Doc/5.png)

## Full-Screen Post-Process Effects

- I added some film grain by generating random values based on UV and time:

    ![](Doc/7.gif)

- I created some floating clouds in the background by randomly generating disks:

    ![](Doc/8.png)

## Interactivity

Thanks to the deformation bones provided by the model, I can create some animations. I used the [Dynamic Bone plugin](https://assetstore.unity.com/packages/tools/animation/dynamic-bone-16743) to simulate the effect of wind on her hair and the strings of her cap. I created a script that enhances the wind force whenever the user clicks the mouse button:

![](Doc/9.gif)
