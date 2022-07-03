require("core");
require("ui");
require("BauulAvatar");
require("utils/kittools");
local core = core;
core.init("//resource//texture//1");
kit.keyLis();
require("lightpanel");
local cam = core.cam;
local config = {
     camx = 2,
     camy = -10,
     camz = -10,
}

local function addBox(x,y,z)
    local p = UnitBase:new();
    local scale = 1;
    p:loadvbo("\\resource\\obj\\box.obj",
    "\\resource\\material\\bauul.mat",scale);
    p:set_position(x or 0,y or 0,z or 0);
    -- core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    core.meterial.setCullface(p:getMaterial(),GL.CULL_FACE_DISABLE);
    core.add(p);
end
local function addPlane()
    local p = UnitBase:new();
    local scale = 100;
    p:loadvbo("\\resource\\obj\\plane.obj",
    "\\resource\\material\\bauul2.mat",scale);
    p:set_position(0,0,0);
    -- core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    core.meterial.setCullface(p:getMaterial(),GL.CULL_FACE_DISABLE);
    core.add(p);
end

local function createModel(url,x,y,z,renderlist,cam3d,scale)
    local vs,ps;
vs = [[
#version 430
layout (location = 0) in vec3 _Position;
layout (location = 1) in vec2 _TexCoord;
layout (location = 2) in vec3 _Normal;
varying vec2 out_texcoord;
uniform mat4 base_matrix;
uniform mat4 perspective_matrix;
uniform mat4 modelView_matrix;

varying vec4 position;  

void main(){
    out_texcoord = _TexCoord.st;
    position = modelView_matrix * vec4(_Position,1.0);
    gl_Position = perspective_matrix * modelView_matrix * base_matrix * vec4(_Position, 1.0);
}
]];


ps = [[
#version 430
//  https://www.csdn.net/tags/OtDaQg5sNTUxMjctYmxvZwO0O0OO0O0O.html
//  https://blog.csdn.net/master_cui/article/details/119219771

uniform sampler2D texture1;
varying vec2 out_texcoord;
layout( location = 0 ) out vec4 FragColor;
uniform float zFar;  
uniform float zNear;
uniform float fov;

varying vec4 position;  

void main(void){
	//FragColor = texture2D(texture1, out_texcoord);
    float zDiff = zFar - zNear;  
    float interpolatedDepth = (position.w / position.z) * zFar * zNear / zDiff + 0.5 * (zFar + zNear) / zDiff + 0.5;  
    FragColor = vec4(vec3(pow(interpolatedDepth, fov)), 1.0);  
}
]]
    local p = core.p3d_create(vs,ps);
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    core.meterial.setCullface(_mater,GL.CULL_FACE_BACK);

    ---@type UnitBase
    local n = UnitBase:new();
    n:loadvbo("\\resource\\obj\\"..url..".obj",0,scale or 1);--teapot   torus
    n:set_position(x,y,z);
    n:setmat(_mater);--设置第一根管线
    n:double_face();
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");

    core.add(n,renderlist);
    -------------------------------------------------------------
    local function f_updateMatrix(_mater)
        shader_updateVal(_mater,"perspective_matrix",cam3d:perctive());
        shader_updateVal(_mater,"modelView_matrix",cam3d:model());
        shader_updateVal(_mater,"base_matrix",n:base_matrix());
        shader_updateVal(_mater,"zNear",0.1);
        shader_updateVal(_mater,"zFar",10000);
        shader_updateVal(_mater,"fov",45);
    end

    local function updateMatirx()
        --更新管线矩阵
        f_updateMatrix(_mater);
        -- n:rotate_vec(core.get_time()/2048,0,1,0);
    end
    core.frameloop(1000/30,updateMatirx);
    return n;
end

local function fboView()
    local w = 256;
    local h = 256;

    local _model;

    local nskin = NSkin:new();
    nskin:load(
[[
<ui name="1" type="NPanel" drag="1" center="0" x="0" y="0" width="256" height="700" line="1"/>
<ui name="bg" type="Shape" x="0" y="0" w="256" h="256 r="0" g="0" b="0" line="0" parent="1"/>
<ui name="fbo1" type="Nfbo" x="0" y="0" w="256" h="256" parent="1"/>
<ui name="sc1" type="NScrollBar" x="0" y="256" parent="1"/>
]]
);
-- 
    local fbo1 = nskin.namemap["fbo1"];
    
    local cam3d = Camera:new(fbo1:get_3dcam());
    local function updateMatirx()
        --更新管线矩阵
        --f_updateMatrix(_mater);
        --n:rotate_vec(core.get_time()/2048,0,1,0);
        local v = nskin.namemap["sc1"]:getProgressValue()*-5-2;
        cam3d:set_pos(v,-2,v);
    end
    -- evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx);
    core.frameloop(1000/30,updateMatirx);


    _model = createModel("box",0,0,0,fbo1.renderlist,cam3d);
    cam3d:setTarget(_model);

    createModel("teapot",0,0,1,fbo1.renderlist,cam3d);
    createModel("bplane",0,0,0,fbo1.renderlist,cam3d,0.1);
    -- _model:dispose();
    -- nskin:dispose();
    -- core.alert("asdsadhaAAs");
end
local function createSence()
    -- addPlane();
    -- addBox(0,0.5,0);
    -- addBox(2,0.5,2);
    fboView(); 
    
end

createSence();

-- cam:set_rotate(-math.pi/4,0,0);
-- cam:set_pos(config.camx,config.camy,config.camz);


