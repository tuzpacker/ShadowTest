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
        //世界坐标变化到从视口坐标 再projectionMatrix 投影矩阵变化到屏幕空间的
        var m = cam.projectionMatrix * cam.worldToCameraMatrix;
        Shader.SetGlobalMatrix("shadow_transform_mat",m);
        cam.targetTexture = shadowMap;
        cam.SetReplacementShader(depthShader,null);
    }
}
