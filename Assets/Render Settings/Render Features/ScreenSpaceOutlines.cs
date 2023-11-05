using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ScreenSpaceOutlines : ScriptableRendererFeature
{
    [System.Serializable]
    public class OutlinePassSettings
    {
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingTransparents;
        public Material material; 
    }
    [SerializeField] public OutlinePassSettings settings;

    class ScreenSpaceOutlinePass : ScriptableRenderPass
    {

        const string ProfilerTag = "Outline Pass";
        public ScreenSpaceOutlines.OutlinePassSettings settings;
        private readonly Material screenSpaceOutlineMaterial; 
        private RenderTargetIdentifier cameraColorTarget;
        private RenderTargetIdentifier temporaryBuffer;
        
        private int temporaryBufferID = Shader.PropertyToID("_TemporaryBuffer");



        public ScreenSpaceOutlinePass(ScreenSpaceOutlines.OutlinePassSettings passSettings) { 
            
            this.renderPassEvent = renderPassEvent;
            this.settings = passSettings;
            //screenSpaceOutlineMaterial = new Material(Shader.Find("Hidden/OutlineShader"));
            if (settings.material == null) settings.material = screenSpaceOutlineMaterial;
        }


        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {

            if (!screenSpaceOutlineMaterial) return;

            CommandBuffer cmd = CommandBufferPool.Get();
            using (new ProfilingScope(cmd, new ProfilingSampler(ProfilerTag))) {
                cmd.SetGlobalTexture("_BlitTexture", cameraColorTarget);
                Blit(cmd, cameraColorTarget, temporaryBuffer, screenSpaceOutlineMaterial);
                Blit(cmd, temporaryBuffer, cameraColorTarget, screenSpaceOutlineMaterial);
            }

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
        }
    }

    ScreenSpaceOutlinePass m_ScriptablePass;

    /// <inheritdoc/>
    public override void Create()
    {
        m_ScriptablePass = new ScreenSpaceOutlinePass(settings);

        // Configures where the render pass should be injected.
        //m_ScriptablePass.renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(m_ScriptablePass);
    }
}


