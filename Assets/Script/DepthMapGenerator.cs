using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
        //_camera.Render();
        ////��������仯�����ӿ����� ��projectionMatrix ͶӰ����仯����Ļ�ռ��
        var m = _camera.projectionMatrix * _camera.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat", m);
        Shader.SetGlobalTexture("shadowMap_data", shadowMap);
        // ���շ���
        Shader.SetGlobalVector("MyLightDir", transform.forward);
        _camera.targetTexture = shadowMap;
        _camera.SetReplacementShader(depthShader, null);
    }
}
