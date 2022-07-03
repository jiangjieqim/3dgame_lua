--描边球
function lightTest()
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
        
        if(cklight == 1.0){
            FragColor = finalColor * diff * lamberFactor;
        }else{
            FragColor = finalColor * lamberFactor;
        }
    }
    ]];

    local function create_mat1()

    end

    local _cklight = 1;
    local _renderTex = 1;

    local p = core.p3d_create(vs,ps);
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    core.meterial.setCullface(_mater,GL.CULL_FACE_BACK);
    local n = UnitBase:new();
    n:loadvbo("\\resource\\obj\\torus1.obj",0,3);--teapot   torus
    n:setmat(_mater);--设置第一根管线
    
    -- local _mater1 = create_mat1();
    -- n:push_material(_mater1);--添加第二根管线
    
    n:set_position(-6,0,-6);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\bump2.tga");
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");

    core.add(n);
    local function f_updateMatrix(_mater)
        shader_updateVal(_mater,"perspective_matrix",core.cam:perctive());
        shader_updateVal(_mater,"modelView_matrix",core.cam:model());
        shader_updateVal(_mater,"normal_matrix",core.cam:normal());
        shader_updateVal(_mater,"base_matrix",n:base_matrix());
        -- shader_updateVal(_mater,"pvm_matrix",n:pvm_matrix());
        shader_updateVal(_mater,"renderTex",_renderTex);
        shader_updateVal(_mater,"cklight",_cklight);
        print("==============>!!!");
    end
    
    local function updateMatirx()
        --更新管线矩阵
        f_updateMatrix(_mater);
        -- f_updateMatrix(_mater1);
        -- n:rotate_vec(core.get_time()/1024,1,0,1);
    end

    evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx);
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
            <ui name="1" type="NPanel" line="0"  center="1" width="200" height="100" x="300" y="300"/>
            <ui name="ck0" type="CheckBox" x="0" y="0" label="bump" func="f_callBack_ck0" parent="1"/>
            <ui name="cklight" type="CheckBox" x="0" y="20" label="light" func="f_callBack_cklight" parent="1"/>
    ]]);

    -- <ui name="lineck" type="CheckBox" x="0" y="40" label="lineck" func="f_callBack_lineck" parent="1"/>

    
end
