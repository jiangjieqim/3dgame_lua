question:alpha?
Fbo组件
pow(x, y)：x的y次方

sqrt(x)：对x开根号

inversesqrt(x)：x根号的倒数

exp(x)：以e为底数，x为指数

exp2(x)：2的x次方

sin(x)：x的正弦值

cos(x)：x的余弦值

tan(x)：x的正切值

abs(x)：x的绝对值

clamp(x, min, max)：取x位于min和max之间的值，超出取边界

floor(x)：x向下取整

ceil(x)：x向上取整

fract(x)：x取小数部分

var VSHADER_SOURCE = '' +
  'attribute vec4 a_Position;\n' + //声明attribute变量a_Position，用来存放顶点位置信息
  'attribute vec4 a_Color;\n' + //声明attribute变量a_Color，用来存放顶点颜色信息
  'attribute vec4 a_Normal;\n' + //声明attribute变量a_Normal，用来存放法向量
  'uniform mat4 u_MvpMatrix;\n' + //声明uniform变量u_MvpMatrix，用来存放模型视图投影组合矩阵
  'uniform mat4 u_ModelMatrix;\n' + //声明uniform变量u_ModelMatrix，用来存放模型矩阵
  'uniform mat4 u_NormalMatrix;\n' + //声明uniform变量u_NormalMatrix，用来存放变换法向量矩阵
  'uniform vec3 u_PointLightColor;\n' + //声明uniform变量u_PointLightColor，用来存放点光源颜色
  'uniform vec3 u_PointLightPosition;\n' + //声明uniform变量u_PointLightPosition，用来存放点光源位置
  'uniform vec3 u_AmbientLightColor;\n' + //声明uniform变量u_AmbientLightColor，用来存放环境光颜色
  'varying vec4 v_Color;\n' + //声明varying变量v_Color，用来向片元着色器传值顶点颜色信息
  'void main(){\n' +
  '  gl_Position = u_MvpMatrix * a_Position;\n' + //将模型视图投影组合矩阵与顶点坐标相乘赋值给顶点着色器内置变量gl_Position
  '  vec3 normal = normalize(vec3(u_NormalMatrix * a_Normal));\n' + //对计算变换后的法向量并归一化处理
  '  vec4 vertexPosition = u_ModelMatrix * a_Position;\n' + //计算顶点的世界坐标
  '  vec3 lightDirection = normalize(u_PointLightPosition - vec3(vertexPosition));\n' + //计算点光源照射物体表面的光线方向，并归一化
  '  float nDotL = max(dot(lightDirection, normal), 0.0);\n' + //计算光线方向和法向量点积
  '  vec3 diffuse = u_PointLightColor * vec3(a_Color) * nDotL;\n' + //计算漫反射光的颜色
  '  vec3 ambient = u_AmbientLightColor * vec3(a_Color);\n' + //计算环境漫反射光的颜色
  '  v_Color = vec4(diffuse + ambient, a_Color.a);\n' + //将漫反射光的颜色和环境漫反射光的颜色相加的结果传给片元着色器
  '}\n';
