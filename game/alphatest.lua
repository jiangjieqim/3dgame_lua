require("core");
require("ui")
local core = core;


-- https://www.jianshu.com/p/22b2e158d895

--[[

// -- GL_ZERO�� ��ʾʹ��0.0��Ϊ���ӣ�ʵ�����൱�ڲ�ʹ��������ɫ���������㡣
// -- GL_ONE�� ��ʾʹ��1.0��Ϊ���ӣ�ʵ�����൱����ȫ��ʹ����������ɫ���������㡣
// -- GL_SRC_ALPHA����ʾʹ��Դ��ɫ��alphaֵ����Ϊ���ӡ�
// -- GL_DST_ALPHA����ʾʹ��Ŀ����ɫ��alphaֵ����Ϊ���ӡ�
// -- GL_ONE_MINUS_SRC_ALPHA����ʾ��1.0��ȥԴ��ɫ��alphaֵ����Ϊ���ӡ�
// -- GL_ONE_MINUS_DST_ALPHA����ʾ��1.0��ȥĿ����ɫ��alphaֵ����Ϊ���ӡ� �������⣬����GL_SRC_COLOR����Դ��ɫ���ĸ������ֱ���Ϊ���ӵ��ĸ�������


��Ȼ��ƺͻ��ͬʱ���ڵĳ�������˳��

1���� ����ɰ�glDepthMask( GL_TRUE )
2�����κ�˳��������в�͸���Ķ���
3���ر��������glDepthMask( GL_FALSE )
4����BLEND_MODE
5�����ƴ���Զ���������İ�͸������
void Draw {
   /**������Ȳ���*/ 
   glEnable( GL_DEPTH_TEST );
  /**�����������*/ 
  glDepthMask( GL_TRUE );
 /**���Ʋ�͸������*/
  DrawA();
  DrawB();  
 /**�ر��������*/
  glDepthMask( GL_FALSE );
 
 /**�������*/  
  glEnable( GL_BLEND );
/**��Ϸ���*/
  glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  
/**���ƴ���Զ���������İ�͸������*/
  DrawC(); 
  DrawD();
  /**�رջ��*/ 
   glDisable( GL_BLEND );  
}
]]


require("utils/kittools");

core.init("//resource//texture//1");
kit.keyLis();




-- require("BauulAvatar");


local function createPlane(scale,res)

    local ps = [[
        #version 110
        uniform sampler2D texture1;
        varying vec2 out_texcoord;
        void main(void){
            vec4 finalColor=texture2D(texture1, out_texcoord);
            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//������ɫ������
            }
            gl_FragColor = finalColor;
        }
    ]];

    local vs=[[
        #version 110
        attribute vec3 _Position;
        attribute vec2 _TexCoord;
        varying vec2 out_texcoord;
        uniform mat4 _mat1;
        uniform float _mUvScale;
        void main(){
            out_texcoord =vec2(_TexCoord.x * _mUvScale,_TexCoord.y*_mUvScale);
            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    
    shader_updateVal(_mater,"_mUvScale",1);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\horse.bmp");
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\"..(res or "plane")..".obj",_mater,scale or 1);
    floor:reverse_face();
    -- floor:double_face();
    core.add(floor);
    return floor;
end

local function createBox(res)

    local ps = [[
        #version 110
        uniform sampler2D texture1;
        varying vec2 out_texcoord;
        uniform float mAlpha;
        void main(void){
            vec4 finalColor=texture2D(texture1, out_texcoord);
            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//������ɫ������
            }
            finalColor.a = mAlpha;//����alpha
            gl_FragColor = finalColor;
        }
    ]];

    local vs=[[
        #version 110
        attribute vec3 _Position;
        attribute vec2 _TexCoord;
        varying vec2 out_texcoord;
        uniform mat4 _mat1;
        void main(){
            out_texcoord =vec2(_TexCoord.x,_TexCoord.y);
            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");
    -- core.meterial.setAlpha(_mater,0.5);

    
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\"..(res or "box")..".obj",_mater,1);
    -- floor:set_position(0,-1,0);
    floor:double_face();
    -- floor:reverse_face();
    core.add(floor);
    return floor;
end



local plane = createPlane(2);


local box = createBox("box");
box:set_position(0,0,1);
---------------------------------------------
core.cam:set_pos(0,-2,-2);
core.cam:setTarget(box);
core.cam:refresh();

local function onLookAtEvt()
    local v= core.get_time()/1000;
    -- print();
    local alpha = (math.sin(v)+1)/2;--  0-1
    core.meterial.setAlpha( box:getMaterial(),alpha);

    box:rotate_vec(v,0,1,0);
end
core.frameloop(1000/20,onLookAtEvt);

