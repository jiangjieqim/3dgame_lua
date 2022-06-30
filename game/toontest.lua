function toontest(x,y,z,scale)
    local ps = [[
        #version 430
        varying vec3 normal;
        varying vec2 out_texcoord;
        uniform sampler2D texture1;
        uniform float renderTex;
        
        //light position
        varying vec3 vLightDir;

        layout( location = 0 ) out vec4 FragColor;
        void main(){


            float intensity;  
            vec4 color;  
            vec3 n = normalize(normal);  
            vec3 m = normalize(vLightDir);
            intensity = dot(m,n);

            if (intensity > 0.95)  
                color = vec4(1.0,0.5,0.5,1.0);
            else if (intensity <=0.95 && intensity > 0.5)  
                color = vec4(0.6,0.3,0.3,1.0);  
            else if (intensity > 0.25 && intensity<=0.5)  
                color = vec4(0.4,0.2,0.2,1.0);  
            else  
                color = vec4(0.2,0.1,0.1,1.0); 

            vec4 c2 = texture2D(texture1, out_texcoord);
            if(renderTex == 0.0){
                FragColor = color;
            }else{
                //FragColor = (c2+color) * 0.5;
                FragColor = c2* 0.2 + color * 0.8;
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
        varying vec2 out_texcoord;

    

        varying vec3 normal;

        varying vec3 vLightDir;

        
        void main(){
           normal = _Normal;
           out_texcoord = _TexCoord.st;

            float lx = 0;
            float ly = 1;
            float lz = 1;

           vec3 LightPosition = vec3(lx,ly,lz);

           vec4 v4 = modelView_matrix*vec4(_Position,1.0);

           vLightDir = normalize(vec3(LightPosition - vec3(v4.x,v4.y,v4.z)));

           gl_Position = perspective_matrix * modelView_matrix * base_matrix *vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    --shader_updateVal(_mater,"_mUvScale",20);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\torus1.obj",_mater,scale);
    floor:set_position(x,y,z);
    -- floor:reverse_face();
    floor:double_face();
    core.add(floor);

    local _renderTex = 0;

    local function f_updateMatrix1(_mater)
        shader_updateVal(_mater,"perspective_matrix",core.cam:perctive());--??????
        shader_updateVal(_mater,"modelView_matrix",core.cam:model());--???????
        shader_updateVal(_mater,"base_matrix",floor:base_matrix());
        shader_updateVal(_mater,"renderTex",_renderTex);

    
        local v = core.get_time() / 1024;
        --  floor:rotate_vec(v,1,1,0);
    end
    
    local function updateMatirx1()
        --更新管线矩阵
        f_updateMatrix1(_mater);
    end

    evt_on(core.engine,core.ex_event.EVENT_CAM_REFRESH,updateMatirx1);
    -------------------------------------------------------------------
    local nskin = NSkin:new();
    nskin.f_callBack_ck0 = function(_selected)
        local v = _selected and 1 or 0;
        _renderTex= v;
        updateMatirx1();
    end
  
    nskin:load(
        [[
            <ui name="1" type="NPanel" line="0"  center="0" width="100" height="50" x="200" y="30"/>
            <ui name="ck0" type="CheckBox" x="0" y="0" label="tex" func="f_callBack_ck0" parent="1"/>
    ]]);
    local namemap = nskin.namemap;

    return floor;
end