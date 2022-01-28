require("core");

local vs,ps;
--[[


#version 430
 
layout (location = 0) in vec3 VertexPosition;
layout (location = 1) in vec3 VertexNormal;
 
out vec3 LightIntensity;
 
uniform vec4 LightPosition; // Light position in eye coords.
uniform vec3 Kd;            // Diffuse reflectivity
uniform vec3 Ld;            // Diffuse light intensity
 
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 MVP;
 
void main()
{
    vec3 tnorm = normalize( NormalMatrix * VertexNormal);
    vec4 eyeCoords = ModelViewMatrix * vec4(VertexPosition,1.0);
    vec3 s = normalize(vec3(LightPosition - eyeCoords));
 
    LightIntensity = Ld * Kd * max( dot( s, tnorm ), 0.0 );
 
    gl_Position = MVP * vec4(VertexPosition,1.0);
}
--------------------------------------
#version 430
 
in vec3 LightIntensity;

layout( location = 0 ) out vec4 FragColor;
 
void main() {
    FragColor = vec4(LightIntensity, 1.0);
}
]]


vs = [[
#version 430
//attribute vec3 _Position;
//attribute vec2 _TexCoord;
//attribute vec3 _Normal;

layout (location = 0) in vec3 _Position;
layout (location = 1) in vec2 _TexCoord;
layout (location = 2) in vec3 _Normal;

varying vec2 out_texcoord;
varying vec3 LightDir;
varying vec3 EyeDir;
varying float diff;

uniform mat4 pvm_matrix; 
uniform mat4 perspective_matrix;//透视矩阵
uniform mat4 modelView_matrix;//视图矩阵
uniform mat4 normal_matrix;//= inverse transpose of modelView_matrix
uniform float lx;
uniform float ly;
uniform float lz;
uniform mat4 base_matrix;

void main(){

    //灯光坐标
    vec3 LightPosition = vec3(lx,ly,lz);
	out_texcoord = _TexCoord.st;

    vec4 vEyeNormal = normal_matrix*vec4(_Normal,1.0);

    vec4 v4 = modelView_matrix*vec4(_Position,1.0);
    vec3 vLightDir = normalize(vec3(LightPosition - vec3(v4.x,v4.y,v4.z)));

    diff = max(0.0,dot(vec3(vEyeNormal.x,vEyeNormal.y,vEyeNormal.z),vLightDir));
    
    gl_Position = perspective_matrix * modelView_matrix * base_matrix *vec4(_Position, 1.0);

    gl_Position = pvm_matrix *vec4(_Position, 1.0);
    //pvm_matrix 等价于 perspective_matrix * modelView_matrix * base_matrix(PVM)
}
]];

ps = [[
#version 430

uniform sampler2D texture1;
varying float diff;
varying vec2 out_texcoord;

layout( location = 0 ) out vec4 FragColor;

void main(void){
        texture1;
        vec4 finalColor = texture2D(texture1, out_texcoord);

        //FragColor = vec4(1,1,1,1)*diff;
        FragColor = finalColor*diff;
}
]];

 -- if(_Alpha<1.0)
            -- {
            --     finalColor.a = _Alpha;
            -- }
            -- if(finalColor.a<=0.0){
            --     discard;//带透明通道的tga文件处理
            -- }else
            --     gl_FragColor = finalColor;

local p = core.p3d_create(vs,ps);

-- core.p3d_set()

---@type UnitBase
local n = UnitBase:new();
local url="\\resource\\obj\\torus.obj";--bauul,triangle,torus

local _mater = tmat_create_empty();
core.p3d_set(_mater,p);
core.meterial.setCullface(_mater,GL.CULL_FACE_BACK);
-- core.meterial.setPolyMode(_mater,GL.GL_LINE);
n:load(url);
n:setmat(_mater);
tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");

local function updateMatirx()
    shader_updateVal(_mater,"perspective_matrix",core.cam:perctive());--透视矩阵
    shader_updateVal(_mater,"modelView_matrix",core.cam:model());--视图矩阵
    shader_updateVal(_mater,"normal_matrix",core.cam:normal());
    shader_updateVal(_mater,"base_matrix", n:base_matrix());
    shader_updateVal(_mater,"pvm_matrix",n:pvm_matrix());

    shader_updateVal(_mater,"lx",0.0);
    shader_updateVal(_mater,"ly",0.0);
    shader_updateVal(_mater,"lz",0.0);
    func_print("updateMatirx>>>");

end

-- n:scale(0.5);
-- n:set_position(0,0,-2.5);

evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx);



core.add(n);

core.cam:set_pos(0,0,-6);

-- core.setfps(24);

---@tyoe LineBox
local lb = LineBox:new();

lb:setRadius(0.25);

local kit = require("utils/kittools");
-- kit.checkComp();
kit.keyLis();
-- core.setTimeout(2000,function()
    -- core.print_info();
    -- core.p3d_del(p);
-- end);
-- kit.debugView();



---@type NSkin
local nskin = NSkin:new();
local x1=0;
local y1=0;
local z1=0;
nskin:load(
    [[
        <ui name="1" type="NPanel" line="1"  center="0" width="200" height="300" x="10" y="10"/>
        <ui name="pb_x" type="NScrollBar" x="0" y="0" parent="1"/>
        <ui name="pb_y" type="NScrollBar" x="0" y="20" parent="1"/>
        <ui name="pb_z" type="NScrollBar" x="0" y="40" parent="1"/>
        <ui name="desc" type="NLabel" y="60" label="desc" width="128" height="128" parent="1"/>
        <ui name="ck0" type="CheckBox" x="0" y="80" label="render" parent="1"/>

        
]]);

local namemap = nskin.namemap;
---@type NLabel
local desc = namemap["desc"];
local power = 5;
-- print(desc);
-- desc:set_text("dasdaksjdlkasjl");
local function updateDesc()
    local str = string.format("%.1f %.1f %.1f",x1,y1,z1);
    -- print();
    desc:set_text(str);
    lb:setPos(x1,y1,z1);
end
namemap["pb_x"]:bindCallback(function(v)
    -- print(_mater,"lx",10*v);
    x1 =power*(0.5-v);
    shader_updateVal(_mater,"lx",x1);
    updateDesc();
end);
namemap["pb_y"]:bindCallback(function(v)
    y1 =power*(0.5-v);
    shader_updateVal(_mater,"ly",y1);
    updateDesc();
end);
namemap["pb_z"]:bindCallback(function(v)
    z1 =power*(0.5-v);
    shader_updateVal(_mater,"lz",z1);
    updateDesc();
end);


local v = 0;
---@type CheckBox
local ck0 = namemap["ck0"];

local function rxBox()
    -- body
    v = v+ math.pi/16;
    core.cam:rx(v);
    -- core.cam:rz(v);
    -- core.cam:ry(v);
    ck0:setlabel(core.getPreciseDecimal(v%math.pi,2));
end

ck0:bind(function ()
    rxBox();
end)
rxBox();

local function f_onkey(data)
    local key = tonumber(data);
    -- func_print(string.format(">>>>>>>>>>>>>>>>>>>>> key = %s", key));
    if(key == core.KeyEvent.KEY_1) then
        rxBox();
    elseif(key == core.KeyEvent.KEY_2)then
        
    elseif(key == core.KeyEvent.KEY_3)then
       
    elseif(key == core.KeyEvent.KEY_4)then
        core.print_info();
    elseif(key == core.KeyEvent.KEY_ESC)then
        core.exit();
    end
end
evt_on(core.engine,core.ex_event.EVENT_ENGINE_KEYBOARD,f_onkey);
