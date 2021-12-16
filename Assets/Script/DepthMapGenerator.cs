using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthMapGenerator : MonoBehaviour
{
    public Camera _camera;
    public RenderTexture shadowMap;
    public Shader depthShader;
    // Start is called before the first frame update
    void Start()
    {
    }
    // Update is called once per frame
    void Update()
    {
        _camera = GetComponent<Camera>();

        _camera.renderingPath = RenderingPath.Forward;
        //_camera.Render();
        ////世界坐标变化到从视口坐标 再projectionMatrix 投影矩阵变化到屏幕空间的
        var m = _camera.projectionMatrix * _camera.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat", m);
        _camera.targetTexture = shadowMap;
        _camera.SetReplacementShader(depthShader, null);
    }
}
