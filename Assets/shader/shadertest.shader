Shader "Lesson/FixedFunctionShader2" {

    properties{
        _Color("Main Color",color)=(1,1,1,1)
        _Amnient("Ambient",color)=(0.3,0.3,0.3,0)
        _Specular("Specular",color)=(1,1,1,1)
        _Shininess("Shininess",range(0,8))=4
        _Emission("Emission",color)=(1,1,1,1)
        _ConstantColor("ConstantColor",color)=(1,1,1,1)
        _MainTex("MainTex",2d)=""
        _SecTex("MainTex",2d)=""
    }

    SubShader {
        Tags { "Queue" = "Transparent" }
        pass{
            Blend SrcAlpha OneMinusSrcAlpha
            // color(1,0,0,1) // 分别代表了 r,g,b,a
            // color[_Color] // 小括号内容表示固定值，中括号内容表示可变参数值
            material{
                diffuse[_Color] // 漫反射
                ambient[_Amnient] // 环境光
                specular[_Specular] // 高光
                shininess[_Shininess] // 述specular强度
                emission[_Emission] // 自发光
            }
            lighting on // 光照开关
            separatespecular on // 镜面高光开关

            settexture[_MainTex]{
                combine texture * primary double
            }

            settexture[_SecTex]{
                constantColor[_ConstantColor]
                combine texture * previous double,texture*constant
            }
        }
    }
}