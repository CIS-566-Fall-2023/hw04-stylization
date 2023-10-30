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
        public Material outlineMaterial;
        public Material wobbleMaterials;
        public Material filterMaterial;
    }

    [SerializeField] private FullScreenPassSettings settings;
    class FullScreenPass : ScriptableRenderPass
    {
        const string ProfilerTag = "Full Screen Pass";
        public FullScreenFeature.FullScreenPassSettings settings;
        RenderTargetIdentifier colorBuffer;
        RenderTargetIdentifier[] temporaryBuffers = new RenderTargetIdentifier[2];
        int[] temporaryBufferIDs = new int[2];

        public FullScreenPass(FullScreenFeature.FullScreenPassSettings passSettings)
        {
            this.settings = passSettings;
            this.renderPassEvent = settings.renderPassEvent;
        }

        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            RenderTextureDescriptor descriptor = renderingData.cameraData.cameraTargetDescriptor;
            colorBuffer = renderingData.cameraData.renderer.cameraColorTarget;


            for (int i = 0; i < temporaryBuffers.Length; i++)
            {
                temporaryBufferIDs[i] = Shader.PropertyToID("_TemporaryColorBuffer" + i.ToString());
                cmd.GetTemporaryRT(temporaryBufferIDs[i], descriptor, FilterMode.Point);
                temporaryBuffers[i] = new RenderTargetIdentifier(temporaryBufferIDs[i]);
            }
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
                Blit(cmd, colorBuffer, temporaryBuffers[0], settings.outlineMaterial);
                Blit(cmd, colorBuffer, temporaryBuffers[1]);
                Blit(cmd, temporaryBuffers[0], temporaryBuffers[1], settings.wobbleMaterials);
                Blit(cmd, temporaryBuffers[1], colorBuffer, settings.filterMaterial);
            }

            // Execute the command buffer and release it.
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            if (cmd == null) throw new ArgumentNullException("cmd");
            for (int i = 0; i < temporaryBuffers.Length; i++)
            {
                cmd.ReleaseTemporaryRT(temporaryBufferIDs[i]);
            }
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


