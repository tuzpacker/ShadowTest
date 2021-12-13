using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthMapGenerator : MonoBehaviour
{
    public Camera cam;
    public RenderTexture shadowMap;
    public Shader depthShader;
    // Start is called before the first frame update
    // Update is called once per frame
    void Update()
    {
        //��������仯�����ӿ����� ��projectionMatrix ͶӰ����仯����Ļ�ռ��
        var m = cam.projectionMatrix * cam.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat",m);
        cam.targetTexture = shadowMap;
        cam.SetReplacementShader(depthShader,null);
    }
}
