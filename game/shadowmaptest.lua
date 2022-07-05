require("core");
require("ui");
require("BauulAvatar");
require("utils/kittools");
local core = core;
core.init("//resource//texture//1");
kit.keyLis();
-- require("lightpanel");
local cam = core.cam;
local config = {
    --- real cam position 
     camx =  -3,
     camy = -3,
     camz = -3,

     ---light position
     lx = -3;
     ly = -3;
     lz = -3;

    ---zdepth Texure hander
     shodowTex = 0;
    ---光照cam3d,renderlist
     renderlist = nil;

    nskin = nil;

    m1 = {
        x=0;
        y=2;
        z=0;
        scale = 1;
        url = "teapot";--teapot
    };

     m2 = {
        x = 0;
        y = 0;
        z = 0;
        scale =1;
        url = "bplane";
    }

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

local function createBase(vs,ps,url,x,y,z,scale)
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
    return n;
end

local function createModel(obj,renderlist,cam3d)
    local x = obj.x;
    local y = obj.y;
    local z = obj.z;
    local scale = obj.scale;
    local url = obj.url;
    -- local cam3d;
    if(renderlist == nil) then
     --   cam3d = core.cam;
    end
    local vs,ps,n;

    if(renderlist==nil)then
vs = [[
    #version 430
    layout (location = 0) in vec3 _Position;
    layout (location = 1) in vec2 _TexCoord;
    layout (location = 2) in vec3 _Normal;
    varying vec2 out_texcoord;
    uniform mat4 base_matrix;
    uniform mat4 perspective_matrix;
    uniform mat4 modelView_matrix;
    
    // 以光源为观察点的投影矩阵
    uniform mat4 light_perspective_matrix;
    uniform mat4 light_modelView_matrix;
    uniform mat4 normal_matrix;//= inverse of modelView_matrix
    
    varying vec4 v_PositionFromLight;
    
    void main(){
        out_texcoord = _TexCoord.st;
        mat4 t = (light_perspective_matrix * light_modelView_matrix );
        t = normal_matrix;
        v_PositionFromLight = (t) * vec4(_Position,1.0); // 以光源为观察点的坐标
        gl_Position = perspective_matrix * modelView_matrix * base_matrix * vec4(_Position, 1.0);
    }
    ]];
    
    
    ps = [[
    #version 430
    
    uniform sampler2D texture1; //shadow texture
    uniform sampler2D texture2; //color
    
    varying vec2 out_texcoord;
    
    varying vec4 v_PositionFromLight; // 以光源为观察点的坐标
    
    layout( location = 0 ) out vec4 FragColor;
    
    void main(void){
    
        vec3 shadowCoord = (v_PositionFromLight.xyz/v_PositionFromLight.w)/2.0 + 0.5; // mvp矩阵处理完的坐标还会被自动转化成裁剪空间的坐标，范围在[0,1]区间，所以这里也要做归一化
    
        vec4 rgbaDepth = texture2D(texture1, shadowCoord.xy); // 拿到深度纹理中对应坐标存储的数据
        float depth = rgbaDepth.r; // 拿到深度纹理中对应坐标存储的深度
        //float visibility = (shadowCoord.z > depth) ? 0.3 : 1.0; // 判断片元是否在阴影中
    
        float visibility = (shadowCoord.z > depth + 0.15) ? 1.0 : 0.5; // 控制阈值大小:0.15 -> 0.01
    
        vec4 v_Color = texture2D(texture2, out_texcoord);
    
        FragColor = vec4(v_Color.rgb * visibility, v_Color.a);
    
    
    }
    ]]

    n = createBase(vs,ps,url,x,y,z,scale);

        tmat_pushTex(n:getMaterial(),config.shodowTex);
        local function f_updateMatrix(_mater)
            shader_updateVal(_mater,"perspective_matrix",cam3d:perctive());
            shader_updateVal(_mater,"modelView_matrix",cam3d:model());
            shader_updateVal(_mater,"base_matrix",n:base_matrix());
            local lightCam = config.cam3d;            
            shader_updateVal(_mater,"normal_matrix",lightCam:normal());

            shader_updateVal(_mater,"light_perspective_matrix",lightCam:perctive());
            shader_updateVal(_mater,"light_modelView_matrix",lightCam:model());
        end
        local function updateMatirx()
            f_updateMatrix(n:getMaterial());
            -- if(r) then n:rotate_vec(core.get_time()/2048,0,1,0);end
        end
        core.frameloop(1000/30,updateMatirx);
        core.add(n,renderlist);
    else
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
        //  https://juejin.cn/post/6940078211967483911
        
        uniform sampler2D texture1;
        varying vec2 out_texcoord;
        layout( location = 0 ) out vec4 FragColor;
        uniform float zFar;  
        uniform float zNear;
        uniform float fov;
        
        uniform float rgb;
        
        varying vec4 position;  
        
        void main(void){
            float zDiff = zFar - zNear;  
            float interpolatedDepth = (position.w / position.z) * zFar * zNear / zDiff + 0.5 * (zFar + zNear) / zDiff + 0.5;  
            FragColor = vec4(vec3(pow(interpolatedDepth, fov)), 1.0);  
        }
        ]]
        
        
        -------------------------------------------------------------
        n = createBase(vs,ps,url,x,y,z,scale);

        local function f_updateMatrix(_mater)
            shader_updateVal(_mater,"perspective_matrix",cam3d:perctive());
            shader_updateVal(_mater,"modelView_matrix",cam3d:model());
            shader_updateVal(_mater,"base_matrix",n:base_matrix());
            shader_updateVal(_mater,"zNear",0.1);
            shader_updateVal(_mater,"zFar",10000);
            shader_updateVal(_mater,"fov",45);
        end
        local function updateMatirx()
            f_updateMatrix(n:getMaterial());
            -- if(r)then n:rotate_vec(core.get_time()/2048,0,1,0);end
        end
        core.frameloop(1000/30,updateMatirx);
        core.add(n,renderlist);
    end


    return n;
end

---构建场景
local function createSenceByType(shodow)
    local cam3d = core.cam;
    local renderlist;
    if(shodow)then
        cam3d = config.cam3d;
        renderlist =  config.renderlist;
    end
    local _model = createModel(config.m1,renderlist,cam3d);
    cam3d:setTarget(_model);
    createModel(config.m2,renderlist,cam3d);
end
local function fboView()

    local nskin = NSkin:new();
    nskin:load(
[[
<ui name="1" type="NPanel" drag="1" center="0" x="0" y="0" width="256" height="700" line="1"/>
<ui name="bg" type="Shape" x="0" y="0" w="128" h="128 r="1" g="0" b="1" line="0" parent="1"/>
<ui name="fbo1" type="Nfbo" x="0" y="0" w="128" h="128" parent="1"/>
<ui name="sc1" type="NScrollBar" x="0" y="256" parent="1"/>
]]
);
    config.nskin = nskin;
    local fbo1 = nskin.namemap["fbo1"];
    
    local cam3d = Camera:new(fbo1:get_3dcam());
    local function updateMatirx()
        local v = nskin.namemap["sc1"]:getProgressValue()*-20-2;
        -- cam3d:set_pos(0,v,v);
        --print(v,-2,v);
    end

    config.renderlist = fbo1.renderlist;
    config.cam3d = cam3d;

    
    cam3d:set_pos(config.lx,config.ly,config.lz);
    -- evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx);
    core.frameloop(1000/30,updateMatirx);

    
    createSenceByType(true);


    -- _model:dispose();
    -- nskin:dispose();
    -- core.alert("asdsadhaAAs");
    
    -- nskin:visible(false);

   
    return fbo1;
end

local function createSence()
    -- addPlane();
    -- addBox(0,0.5,0);
    -- addBox(2,0.5,2);
    local fbo = fboView();
    -- print('***********',fbo:get_tex());
    config.shodowTex = fbo:get_tex();
    createSenceByType();
end

createSence();


core.frameloop(1,function()
    local v = config.nskin.namemap["sc1"]:getProgressValue();
    local cam1 = config.cam3d;
    cam1 = core.cam;
    cam1:set_pos(config.lx,config.ly,config.lz + math.sin(core.get_time()/1024) * 5 + v);
end)

-- tmat_pushTex(_mater,tex);

-- cam:set_rotate(-math.pi/4,0,0);
-- cam:set_pos(config.camx,config.camy,config.camz);


