---用多管线渲染一个描边模型

require("core");
require("utils/kittools");
kit.keyLis();
core.cam:set_pos(0,0,-5);

local function create_mat1()
    local vs,ps;

    vs = [[
    #version 430
    layout (location = 0) in vec3 _Position;
    layout (location = 1) in vec2 _TexCoord;
    layout (location = 2) in vec3 _Normal;

    varying vec2 out_texcoord;
    varying vec3 EyeDir;
    varying float diff;

    uniform mat4 pvm_matrix; 
    uniform mat4 modelView_matrix;
    uniform mat4 normal_matrix;//= inverse transpose of modelView_matrix
    uniform float lx;
    uniform float ly;
    uniform float lz;
    uniform mat4 perspective_matrix;
    uniform mat4 base_matrix;

    void main(){
        float offset = 0.02;//描边偏移
        vec3 LightPosition = vec3(lx,ly,lz);
        out_texcoord = _TexCoord.st;

        vec4 vEyeNormal = normal_matrix*vec4(_Normal,1.0);//法线向量

        vec4 v4 = modelView_matrix*vec4(_Position,1.0);

        vec3 v3 = vec3(vEyeNormal.x,vEyeNormal.y,vEyeNormal.z);
        v3 = normalize(v3)*offset;
        gl_Position = perspective_matrix * modelView_matrix * base_matrix *vec4(vec3(_Position.x + v3.x,_Position.y + v3.y,_Position.z + v3.z), 1.0);
    }
    ]];

    ps = [[
    #version 430

    uniform sampler2D texture1;
    uniform sampler2D texture2;//normal texture
    uniform float renderTex;
    uniform float cklight;
    varying float diff;
    varying vec2 out_texcoord;

    layout( location = 0 ) out vec4 FragColor;

    void main(void){
        FragColor = vec4(1.0,1.0,1.0,1.0);
    }
    ]];

    local p = core.p3d_create(vs,ps);
    local _mater = tmat_create_empty();
    --core.meterial.setCullface(_mater,GL.CULL_FACE_BACK);
    core.p3d_set(_mater,p);

    return _mater;
end

local vs,ps;

vs = [[
#version 430

layout (location = 0) in vec3 _Position;
layout (location = 1) in vec2 _TexCoord;
layout (location = 2) in vec3 _Normal;

varying vec2 out_texcoord;
varying vec3 vLightDir;
varying vec3 EyeDir;
varying float diff;

uniform mat4 pvm_matrix; 
uniform mat4 modelView_matrix;
uniform mat4 normal_matrix;//= inverse transpose of modelView_matrix
uniform float lx;
uniform float ly;
uniform float lz;
uniform mat4 perspective_matrix;
uniform mat4 base_matrix;

void main(){

    vec3 LightPosition = vec3(lx,ly,lz);
	out_texcoord = _TexCoord.st;

    vec4 vEyeNormal = normal_matrix*vec4(_Normal,1.0);//法线向量

    vec4 v4 = modelView_matrix*vec4(_Position,1.0);
    vLightDir = normalize(vec3(LightPosition - vec3(v4.x,v4.y,v4.z)));

    diff = max(0.0,dot(vec3(vEyeNormal.x,vEyeNormal.y,vEyeNormal.z),vLightDir));
    //vec3 v3 = vec3(vEyeNormal.x,vEyeNormal.y,vEyeNormal.z);
    //v3 = normalize(v3)/2;
    gl_Position = perspective_matrix * modelView_matrix * base_matrix *vec4(_Position, 1.0);

    //gl_Position = pvm_matrix *vec4(_Position, 1.0);
}
]];

ps = [[
#version 430

uniform sampler2D texture1;
uniform sampler2D texture2;//normal texture
uniform float renderTex;
uniform float cklight;
varying float diff;
varying vec2 out_texcoord;
varying vec3 vLightDir;


layout( location = 0 ) out vec4 FragColor;

void main(void){
    vec3 normal = 2.0 * texture2D (texture2, out_texcoord).rgb - 1.0;
    normal = normalize (normal);
	float lamberFactor= max (dot (vLightDir, normal), 0.0) ;

    vec4 finalColor = texture2D(texture1, out_texcoord);
    if(renderTex == 0.0){
        lamberFactor = 1.0;
    }
	if (lamberFactor > 0.0){
        
    }else{
        //lamberFactor
    }

    if(cklight == 1.0){
        FragColor = finalColor * diff * lamberFactor;
    }else{
        FragColor = finalColor * lamberFactor;
    }
}
]];

local p = core.p3d_create(vs,ps);
local _mater = tmat_create_empty();
core.p3d_set(_mater,p);
core.meterial.setCullface(_mater,GL.CULL_FACE_BACK);

---@type UnitBase
local n = UnitBase:new();
n:loadvbo("\\resource\\obj\\torus1.obj");--teapot   torus
n:setmat(_mater);--设置第一根管线

local _mater1 = create_mat1();
n:push_material(_mater1);--添加第二根管线

tmat_pushTexUrl(_mater,"\\resource\\texture\\bump2.tga");
tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");
local _renderTex = 1;
local _cklight = 1;

local function f_updateMatrix(_mater)
    shader_updateVal(_mater,"perspective_matrix",core.cam:perctive());--??????
    shader_updateVal(_mater,"modelView_matrix",core.cam:model());--???????
    shader_updateVal(_mater,"normal_matrix",core.cam:normal());
    shader_updateVal(_mater,"base_matrix",n:base_matrix());
    shader_updateVal(_mater,"pvm_matrix",n:pvm_matrix());
    shader_updateVal(_mater,"renderTex",_renderTex);
    shader_updateVal(_mater,"cklight",_cklight);
end

local function updateMatirx()
    --更新管线矩阵
    f_updateMatrix(_mater);
    f_updateMatrix(_mater1);
end
evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx);
---@type NSkin
local nskin = NSkin:new();

nskin.f_callBack_ck0 = function(_selected)
    local v = _selected and 1 or 0;
    _renderTex= v;
    updateMatirx();
end
nskin.f_callBack_lineck = function(_selected)
    local v = _selected and 1 or 0;
    core.meterial.disable(_mater1,v);
end
nskin.f_callBack_cklight = function(_selected)
    _cklight= _selected and 1 or 0;
    updateMatirx();
end
nskin:load(
    [[
        <ui name="1" type="NPanel" line="1"  center="0" width="200" height="300" x="10" y="10"/>
        <ui name="ck0" type="CheckBox" x="0" y="0" label="bump" func="f_callBack_ck0" parent="1"/>
        <ui name="cklight" type="CheckBox" x="0" y="20" label="light" func="f_callBack_cklight" parent="1"/>
        <ui name="lineck" type="CheckBox" x="0" y="40" label="lineck" func="f_callBack_lineck" parent="1"/>
]]);

----------------------------------------
---@type Vec3
local dir = Vec3:new(1,1,0);
dir:normalize();
local v = 0;
local function frender()
    --旋转
    v=v + core.delayTime()/2048;
    --print(v);
    n:rotate_vec(v,dir.x,dir.y,dir.z);
    -- shader_updateVal(_mater,"base_matrix",n:base_matrix());
    updateMatirx();
end
core.setTimeout(1,frender,nil,true);
--将旋转的面包圈对象加到舞台
core.add(n);

------------------------------------------
local size = 5;
---@type LineNode
local _line = LineNode:new(2);
-- _line:push(-size,-size,-size);
_line:push(0,0,0);
_line:push(size*dir.x,size*dir.y,size*dir.z);
_line:graphics_end();
--绘制一根线段
core.add(_line);
-------------------------------------------
-- local DebugView = require("view/DebugView");
-- local panel = DebugView:new();
