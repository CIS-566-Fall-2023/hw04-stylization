using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.Universal.PostProcessing;

namespace CompoundRendererFeature.PostProcess {
[Serializable, VolumeComponentMenu("Post Process")]
public class PostProcessDetail : VolumeComponent {
    // Controls the amount of contrast added to the image details
    public ClampedFloatParameter intensity = new ClampedFloatParameter(0f, 0f, 3f, true);

    // Controls smoothing amount
    public ClampedFloatParameter blur = new ClampedFloatParameter(1f, 0, 2, true);

    // Controls structure within the image
    public ClampedFloatParameter edgePreserve = new ClampedFloatParameter(1.25f, 0, 2, true);

    // The distance from the camera at which the effect starts.")
    public MinFloatParameter rangeStart = new MinFloatParameter(10f, 0f);

    // The distance from the camera at which the effect reaches its maximum radius
    public MinFloatParameter rangeEnd = new MinFloatParameter(30f, 0f);
}

[CompoundRendererFeature("Post Process", InjectionPoint.BeforePostProcess)]
public class PostProcessDetailRenderer : CompoundRenderer {
    private PostProcessDetail _volumeComponent;

    private Material _effectMaterial;

    static class PropertyIDs {
        internal static readonly int Input = Shader.PropertyToID("_MainTex");
        internal static readonly int PingTexture = Shader.PropertyToID("_PingTexture");
        internal static readonly int BlurStrength = Shader.PropertyToID("_BlurStrength");
        internal static readonly int Blur1 = Shader.PropertyToID("_BlurTex1");
        internal static readonly int Blur2 = Shader.PropertyToID("_BlurTex2");
        internal static readonly int Intensity = Shader.PropertyToID("_Intensity");
        internal static readonly int DownSampleScaleFactor = Shader.PropertyToID("_DownSampleScaleFactor");
        public static readonly int CoCParams = Shader.PropertyToID("_CoCParams");
    }

    public override ScriptableRenderPassInput input =>
        ScriptableRenderPassInput.Color | ScriptableRenderPassInput.Depth;

    // Called only once before the first render call.
    public override void Initialize() {
        base.Initialize();
        _effectMaterial = CoreUtils.CreateEngineMaterial("Hidden/CompoundRendererFeature/PostProcess");
    }

    // Called for each camera/injection point pair on each frame.
    // Return true if the effect should be rendered for this camera.
    public override bool Setup(in RenderingData renderingData, InjectionPoint injectionPoint) {
        base.Setup(in renderingData, injectionPoint);
        var stack = VolumeManager.instance.stack;
        _volumeComponent = stack.GetComponent<PostProcessDetail>();
        bool shouldRenderEffect = _volumeComponent.intensity.value > 0;
        return shouldRenderEffect;
    }

    public override void Render(CommandBuffer cmd, RTHandle source, RTHandle destination,
                                ref RenderingData renderingData, InjectionPoint injectionPoint) {
        const int downSample = 1;

        RenderTextureDescriptor descriptor = GetTempRTDescriptor(renderingData);
        int wh = descriptor.width / downSample;
        int hh = descriptor.height / downSample;
        float blurRadius = _volumeComponent.blur.value * (wh / 1080f);
        blurRadius = Mathf.Min(blurRadius, 2f);
        float edgePreserve = _volumeComponent.edgePreserve.value * (wh / 1080f);
        edgePreserve = Mathf.Min(edgePreserve, 2f);

        var rangeStart = _volumeComponent.rangeStart.overrideState ? _volumeComponent.rangeStart.value : 0;
        var rangeEnd = _volumeComponent.rangeEnd.overrideState ? _volumeComponent.rangeEnd.value : -1;
        _effectMaterial.SetVector(PropertyIDs.CoCParams, new Vector2(rangeStart, rangeEnd));

        _effectMaterial.SetFloat(PropertyIDs.Intensity, _volumeComponent.intensity.value);
        SetSourceSize(cmd, descriptor);

        var tempRtDescriptor = GetTempRTDescriptor(renderingData, wh, hh, _defaultHDRFormat);
        cmd.GetTemporaryRT(PropertyIDs.PingTexture, tempRtDescriptor, FilterMode.Bilinear);
        cmd.GetTemporaryRT(PropertyIDs.Blur1, tempRtDescriptor, FilterMode.Bilinear);
        cmd.GetTemporaryRT(PropertyIDs.Blur2, tempRtDescriptor, FilterMode.Bilinear);

        cmd.SetGlobalVector(PropertyIDs.DownSampleScaleFactor,
                            new Vector4(1.0f / downSample, 1.0f / downSample, downSample, downSample));

        cmd.SetGlobalFloat(PropertyIDs.BlurStrength, edgePreserve);
        cmd.SetGlobalTexture(PropertyIDs.Input, source);
        CoreUtils.DrawFullScreen(cmd, _effectMaterial, PropertyIDs.PingTexture, null, 1);
        cmd.SetGlobalTexture(PropertyIDs.Input, PropertyIDs.PingTexture);
        CoreUtils.DrawFullScreen(cmd, _effectMaterial, PropertyIDs.Blur1, null, 2);

        cmd.SetGlobalFloat(PropertyIDs.BlurStrength, blurRadius);
        cmd.SetGlobalTexture(PropertyIDs.Input, PropertyIDs.Blur1);
        CoreUtils.DrawFullScreen(cmd, _effectMaterial, PropertyIDs.PingTexture, null, 1);
        cmd.SetGlobalTexture(PropertyIDs.Input, PropertyIDs.PingTexture);
        CoreUtils.DrawFullScreen(cmd, _effectMaterial, PropertyIDs.Blur2, null, 2);

        cmd.SetGlobalTexture(PropertyIDs.Input, source);
        CoreUtils.DrawFullScreen(cmd, _effectMaterial, destination, null, 0);

        cmd.ReleaseTemporaryRT(PropertyIDs.PingTexture);
        cmd.ReleaseTemporaryRT(PropertyIDs.Blur1);
        cmd.ReleaseTemporaryRT(PropertyIDs.Blur2);
    }

    public override void Dispose(bool disposing) { }
}
}