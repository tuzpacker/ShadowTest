using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthMapGenerator : MonoBehaviour
{
    private Camera _camera;
    public RenderTexture shadowMap;
    public Shader depthShader;
    // Start is called before the first frame update
    void Start()
    {
        _camera = new GameObject().AddComponent<Camera>();
        _camera.name = "DepthCamera";
        _camera.depth = 2;
        _camera.clearFlags = CameraClearFlags.SolidColor;
        _camera.backgroundColor = new Color(0, 0, 0, 0);
        _camera.aspect = 1;
        _camera.transform.position = this.transform.position;
        _camera.transform.rotation = this.transform.rotation;
        _camera.transform.parent = this.transform;

        _camera.orthographic = true;
        _camera.orthographicSize = 10;
    }
    // Update is called once per frame
    void Update()
    {
        //_camera.Render();
        ////世界坐标变化到从视口坐标 再projectionMatrix 投影矩阵变化到屏幕空间的
        var m = _camera.projectionMatrix * _camera.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat",m);
        _camera.targetTexture = shadowMap;
        _camera.SetReplacementShader(depthShader,null);
    }
}
