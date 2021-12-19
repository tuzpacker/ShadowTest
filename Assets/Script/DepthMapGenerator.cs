using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DepthMapGenerator : MonoBehaviour
{
    public RenderTexture shadowMap;
    public Shader depthShader;
    // Start is called before the first frame update
    void Start()
    {
    }
    // Update is called once per frame
    void Update()
    {
        var _camera = GetComponent<Camera>();
        if (!_camera)
            return;

        _camera.renderingPath = RenderingPath.Forward;
        Shader.SetGlobalVector("MyLightDir", transform.forward);

        //_camera.Render();
        ////世界坐标变化到从视口坐标 再projectionMatrix 投影矩阵变化到屏幕空间的
        var m = _camera.projectionMatrix * _camera.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat", m);
        Shader.SetGlobalTexture("shadowMap_data", shadowMap);
        // 光照方向
        _camera.targetTexture = shadowMap;
        _camera.SetReplacementShader(depthShader, null);
    }
}
