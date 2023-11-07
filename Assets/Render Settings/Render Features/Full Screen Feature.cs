using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class FullScreenFeature : ScriptableRendererFeature
{
    [System.Serializable]
    public class FullScreenPassSettings
    {
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingTransparents;
        public Material material;
    }

    [SerializeField] private FullScreenPassSettings settings; // serialized to user so they can click dropdown

    // when a Feature is created, it creates a Pass, which is going to be queued onto the Render call
        // this is why we need settings as an input
    class FullScreenPass : ScriptableRenderPass
    {
        const string ProfilerTag = "Full Screen Pass"; // for debugging purposes
        public FullScreenFeature.FullScreenPassSettings settings;
        RenderTargetIdentifier colorBuffer, temporaryBuffer;    // buffers! - needed for post processing
            // colorBuffer - will be what colors are on the screen
            // temporaryBuffer - blit from color to temp and back
        private int temporaryBufferID = Shader.PropertyToID("_TemporaryBuffer");

        public FullScreenPass(FullScreenFeature.FullScreenPassSettings passSettings)
        {
            this.settings = passSettings;
            this.renderPassEvent = settings.renderPassEvent;
            if (settings.material == null) settings.material = CoreUtils.CreateEngineMaterial("Shader Graphs/Invert");
        }

        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            RenderTextureDescriptor descriptor = renderingData.cameraData.cameraTargetDescriptor;
            colorBuffer = renderingData.cameraData.renderer.cameraColorTarget;  // color buffer getting initialized to camera data

            cmd.GetTemporaryRT(temporaryBufferID, descriptor, FilterMode.Point);
            temporaryBuffer = new RenderTargetIdentifier(temporaryBufferID);
        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get();
            using (new ProfilingScope(cmd, new ProfilingSampler(ProfilerTag)))
            {
                // HW 4 Hint: Blit from the color buffer to a temporary buffer and *back*.
                // "blitting" all pixel data from colorBuffer to temporary buffer
                    // transferring all pixel information from first to second
                    // might modify info on the way to blitting it
                    // everything red to blue
                    //
                // in this process, we end up applying this material onto it.
                // material in tempBuffer has already been applied to scene and is being stored
                // there currently
                // need to go back to color buffer bc it represents what camera is seeing
                //cmd.SetRenderTarget(colorBuffer);
                Blit(cmd, colorBuffer, temporaryBuffer, settings.material);
                Blit(cmd, temporaryBuffer, colorBuffer);
                
            }

            // Execute the command buffer and release it.
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            if (cmd == null) throw new ArgumentNullException("cmd");
            cmd.ReleaseTemporaryRT(temporaryBufferID);  // releasing memory taken up by temporary buffer whenever we're cleaning up after render pass
        }
    }

    FullScreenPass m_FullScreenPass;

    /// <inheritdoc/>
    public override void Create()
    {
        m_FullScreenPass = new FullScreenPass(settings);
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (renderingData.cameraData.cameraType != CameraType.Game)
            return;
        renderer.EnqueuePass(m_FullScreenPass);
    }
}


