require("core");
require("ui");
require("BauulAvatar");
require("utils/kittools");
local core = core;
core.init("//resource//texture//1");
kit.keyLis();

require("lightpanel");

local config = {
     bRotate = true,--是否可旋转

    ---灯光坐标
     lx = 0,
     ly = 0,
     lz = 0,
     rSpeed = 0,
}

-- local function cvLight(offset,v)
--     local scale = 2;
--     return  offset +  (v-0.5) * scale;
--     -- return  offset +  v * scale;
-- end
local function toontest(x,y,z,scale)
    x = x or 0;
    y = y or 0;
    z = z or 0;
    scale = scale or 1;
    -- config.lx = x;
    -- config.ly = y;
    -- config.lz = z;
    local uistr =   [[
        <ui name="1" type="NPanel" line="0"  center="0" width="150" height="200" x="200" y="30" bgColor="0.0,0.1,0"/>
        <ui name="ck0" type="CheckBox" x="0" y="0" label="纹理混合" func="f_callBack_ck0" parent="1"/>
        <ui name="sc1" type="NScrollBar" x="0" y="20" func="f_callBack_camScale" parent="1" label="texRatio"/>
        <ui name="sc2" type="NScrollBar" x="0" y="40" func="f_callBack_rotate" parent="1" label="rotate"/>
        <ui name="info" type="NLabel" width="128" height="128" x="0" y="60" parent="1" label="L1"/>
        <ui name="rSpeed" type="NScrollBar" x="0" y="80" func="f_callBack_speed" parent="1" label="旋转速度"/>
    ]];
    -------------------------------------------------
    local ps = [[
        #version 430
        varying vec3 normal;
        varying vec2 out_texcoord;
        uniform sampler2D texture1;
        uniform float renderTex;
        uniform float texRatio;
        
        //light position
        varying vec3 vLightDir;
        varying float nDotL;

        layout( location = 0 ) out vec4 FragColor;
        void main(){
            float intensity;  
            vec4 color = vec4(1,0,0,0);  
            //vec3 n = normalize(normal);  
            //vec3 m = normalize(vLightDir);
            //intensity = dot(m,n);
            intensity = nDotL;
            if (intensity > 0.95)  
                color = vec4(1.0,0.5,0.5,1.0);
            else if (intensity <=0.95 && intensity > 0.75)  
                color = vec4(1.0,0.4,0.4,1.0);
            else if (intensity <=0.75 && intensity > 0.5)  
                color = vec4(0.6,0.3,0.3,1.0);  
            else if (intensity > 0.25 && intensity<=0.5)  
                color = vec4(0.4,0.2,0.2,1.0);  
            else if (intensity > 0.15 && intensity<=0.25)  
                color = vec4(0.3,0.1,0.1,1.0); 
            else  
                color = vec4(0.2,0.1,0.1,1.0); 
            
            //  color =  vec4(0.5,0.5,0.5,0)*intensity;//关闭卡通着色
            
            vec4 c2 = texture2D(texture1, out_texcoord);
            if(renderTex == 0.0){
                FragColor = color;
            }else{
                FragColor = c2* texRatio + color * (1-texRatio);
            }
        }
    ]];

    local vs=[[
        #version 430
        layout (location = 0) in vec3 _Position;
        layout (location = 1) in vec2 _TexCoord;
        layout (location = 2) in vec3 _Normal;
        
        uniform mat4 perspective_matrix;
        uniform mat4 base_matrix;
        uniform mat4 modelView_matrix;
        uniform mat4 normal_matrix;

        uniform mat4 _base_m_invert;//模型视图的逆的转置

        varying vec2 out_texcoord;

        varying vec3 normal;
        varying float nDotL;

        //ligit position
        uniform float lx;
        uniform float ly;
        uniform float lz;

        uniform mat4 _mat1;
        //光源方向
        varying vec3 vLightDir;
    
        void main(){
            _mat1;
            normal_matrix;
            _base_m_invert; //transpose(inverse(base_matrix) 模型矩阵的的逆的转置
           
           //normal = _Normal;
           //normal =  normalize(vec3( transpose(inverse(base_matrix) ) * vec4(_Normal,1.0)));

           normal =  normalize(vec3(_base_m_invert * vec4(_Normal,1.0)));

           vec3 LightPosition = vec3(lx,ly,lz);

           vec4 v4 =  _base_m_invert * vec4(_Position,1.0);
           
           vLightDir = normalize(vec3(LightPosition - vec3(v4.x,v4.y,v4.z)));

            nDotL = max(dot(vLightDir, normal), 0.0);

            out_texcoord = _TexCoord.st;

           gl_Position = perspective_matrix * modelView_matrix * base_matrix *vec4(_Position, 1.0);
           //gl_Position =  _mat1 *vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    --shader_updateVal(_mater,"_mUvScale",20);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");
    local model = UnitBase:new();
    model:loadvbo("\\resource\\obj\\teapot.obj",_mater,scale);--torus   teapot  torus1 sphere
    model:set_position(x,y,z);
    -- print(">>>",model:get_name());
    local s1 = string.format("toontest model name %s",model:get_name());
    print(s1);

    model:reverse_face();
    -- model:double_face();
    core.add(model);

    local _renderTex = 0;
    local texRatio = 0.2;
    
    -- local infoLabel;

    local function f_updateMatrix1(_mater)
        shader_updateVal(_mater,"perspective_matrix",core.cam:perctive());
        shader_updateVal(_mater,"modelView_matrix",core.cam:model());
        shader_updateVal(_mater,"base_matrix",model:base_matrix());
        shader_updateVal(_mater,"normal_matrix",core.cam:normal());
        shader_updateVal(_mater,"renderTex",_renderTex);
        shader_updateVal(_mater,"texRatio",texRatio);
        
        shader_updateVal(_mater,"lx",core.light.x);
        shader_updateVal(_mater,"ly",core.light.y);
        shader_updateVal(_mater,"lz",core.light.z);

        local v = core.get_time() / 1024;
    end
    
    -- local lightBox = BauulAvatar:new();lightBox:init({res=BauulAvatar.Res.Box});
    local nskin = NSkin:new();

    local function updateMatirx1()
        f_updateMatrix1(_mater);
        -- print(math.random());
        -- if(lightBox)then
            -- lightBox:set_position(config.lx,config.ly,config.lz);
        -- end
        local t = core.get_time()/1024/4*(1 + config.rSpeed*5);
        if(config.bRotate)then
            model:rotate_vec(t,1,1,0);
        end
        local nameMap = nskin:getNameMap();
        local infoLabel = nameMap["info"];
        if(infoLabel)then
            local x,y,z = model:get_pos();
            infoLabel:set_text(string.format("pos %.2f,%.2f,%.2f",x,y,z));
            -- nameMap["lx"]:set_text(string.format("lx %.2f",config.lx));
            -- nameMap["ly"]:set_text(string.format("ly %.2f",config.ly));
            -- nameMap["lz"]:set_text(string.format("lz %.2f",config.lz));
        end

    end
    core.frameloop(1000/30,updateMatirx1);
    -- evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx1);
    -------------------------------------------------------------------
    nskin.f_callBack_ck0 = function(_selected)
        _renderTex=  _selected and 1 or 0;
    end

    nskin.f_callBack_camScale = function(v)
        texRatio = v;
    end
    
    nskin.f_callBack_rotate = function(v)
        v = v - 0.5;
        model:rotate_vec(2 * math.pi*v,1,1,0);
    end

    -- nskin.f_callBack_x = function(v)
    --     local x,y,z = model:get_pos();
    --     config.lx = cvLight(x,v);
    -- end
    -- nskin.f_callBack_y = function(v)
    --     local x,y,z = model:get_pos();
    --     config.ly = cvLight(y,v);
    -- end
    -- nskin.f_callBack_z = function(v)
    --     local x,y,z = model:get_pos();
    --     config.lz = cvLight(z,v);
    -- end
    nskin.f_callBack_speed = function(v)
        config.rSpeed = v;
    end
    nskin:load(uistr);
    
    -- local namemap = nskin:getNameMap();
    -- infoLabel= namemap["info"];
    model:rotate_vec(2 * math.pi*(0.27-0.5),1,1,0);
    -- nskin:dispose();
    return model;
end
local function test(m)
    local len = 2;
    config.bRotate = true;
    m:set_position(1,1,0);
    -- core.cam:set_pos(len*1,len*-1,len*1);
    -- core.cam:setTarget(m);
end
local function test1(m)
    local len = 5;
    config.bRotate = true;
    core.cam:set_pos(len*1,len*-1,len*1);
    core.cam:setTarget(m);
end

-- toontest(0,0,0,1);
local m= toontest(0,0,0,1);

-- test1(m);