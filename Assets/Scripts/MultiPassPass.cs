using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;


public class MultiPassPass : ScriptableRenderPass
{
    private List<ShaderTagId> m_Tags;

    public MultiPassPass(List<string> tags)
    {
        m_Tags = new List<ShaderTagId>();
        foreach (string tag in tags)
        {
            m_Tags.Add(new ShaderTagId(tag));
        }

        this.renderPassEvent = RenderPassEvent.AfterRenderingOpaques - 1;
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get();

        using (new ProfilingScope(cmd, new ProfilingSampler("Render Multi-Pass")))
        {
            context.ExecuteCommandBuffer(cmd);
            cmd.Clear();

            // Get the opaque rendering filter settings
            FilteringSettings filteringSettings = FilteringSettings.defaultValue;

            foreach (ShaderTagId pass in m_Tags)
            {
                DrawingSettings drawingSettings = CreateDrawingSettings(pass, ref renderingData, SortingCriteria.CommonOpaque);
                context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref filteringSettings);
            }
        }

        context.ExecuteCommandBuffer(cmd);
        cmd.Clear();

        CommandBufferPool.Release(cmd);

    }
}
