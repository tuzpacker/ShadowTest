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
        ////��������仯�����ӿ����� ��projectionMatrix ͶӰ����仯����Ļ�ռ��
        var m = _camera.projectionMatrix * _camera.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat", m);
        _camera.targetTexture = shadowMap;
        _camera.SetReplacementShader(depthShader, null);
    }
}
