question:alpha?
Fbo���
pow(x, y)��x��y�η�

sqrt(x)����x������

inversesqrt(x)��x���ŵĵ���

exp(x)����eΪ������xΪָ��

exp2(x)��2��x�η�

sin(x)��x������ֵ

cos(x)��x������ֵ

tan(x)��x������ֵ

abs(x)��x�ľ���ֵ

clamp(x, min, max)��ȡxλ��min��max֮���ֵ������ȡ�߽�

floor(x)��x����ȡ��

ceil(x)��x����ȡ��

fract(x)��xȡС������

var VSHADER_SOURCE = '' +
  'attribute vec4 a_Position;\n' + //����attribute����a_Position��������Ŷ���λ����Ϣ
  'attribute vec4 a_Color;\n' + //����attribute����a_Color��������Ŷ�����ɫ��Ϣ
  'attribute vec4 a_Normal;\n' + //����attribute����a_Normal��������ŷ�����
  'uniform mat4 u_MvpMatrix;\n' + //����uniform����u_MvpMatrix���������ģ����ͼͶӰ��Ͼ���
  'uniform mat4 u_ModelMatrix;\n' + //����uniform����u_ModelMatrix���������ģ�;���
  'uniform mat4 u_NormalMatrix;\n' + //����uniform����u_NormalMatrix��������ű任����������
  'uniform vec3 u_PointLightColor;\n' + //����uniform����u_PointLightColor��������ŵ��Դ��ɫ
  'uniform vec3 u_PointLightPosition;\n' + //����uniform����u_PointLightPosition��������ŵ��Դλ��
  'uniform vec3 u_AmbientLightColor;\n' + //����uniform����u_AmbientLightColor��������Ż�������ɫ
  'varying vec4 v_Color;\n' + //����varying����v_Color��������ƬԪ��ɫ����ֵ������ɫ��Ϣ
  'void main(){\n' +
  '  gl_Position = u_MvpMatrix * a_Position;\n' + //��ģ����ͼͶӰ��Ͼ����붥��������˸�ֵ��������ɫ�����ñ���gl_Position
  '  vec3 normal = normalize(vec3(u_NormalMatrix * a_Normal));\n' + //�Լ���任��ķ���������һ������
  '  vec4 vertexPosition = u_ModelMatrix * a_Position;\n' + //���㶥�����������
  '  vec3 lightDirection = normalize(u_PointLightPosition - vec3(vertexPosition));\n' + //������Դ�����������Ĺ��߷��򣬲���һ��
  '  float nDotL = max(dot(lightDirection, normal), 0.0);\n' + //������߷���ͷ��������
  '  vec3 diffuse = u_PointLightColor * vec3(a_Color) * nDotL;\n' + //��������������ɫ
  '  vec3 ambient = u_AmbientLightColor * vec3(a_Color);\n' + //���㻷������������ɫ
  '  v_Color = vec4(diffuse + ambient, a_Color.a);\n' + //������������ɫ�ͻ�������������ɫ��ӵĽ������ƬԪ��ɫ��
  '}\n';
