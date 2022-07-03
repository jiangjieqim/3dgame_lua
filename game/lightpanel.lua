require("core");
require("BauulAvatar");
local config = {
    -- scale = 1,
    isInit = 0,
    curTarget = 0,--当前的对象句柄
    curName = "";
    camx = 0,
    camy = -20,
    camz = -20;

    ---选取的对象坐标
    -- ox=0;oy=0;oz=0;
}
local cam = core.cam;
local function fcv(v,s)
    v = (v - 0.5) * s * -1;
    return  v;
end

---cam缩放  
---v: 0 ~ 1
local function controlCamScale(v)
    -- v = v - 0.5;
    -- print(v);
    local x,y,z = config.camx,config.camy,config.camz;--cam:get_pos();
    local speed = math.abs(config.camz)-2;
    local tx = y+v*speed
    local tz = z+v*speed;
    cam:set_pos(0,tx,tz);
    -- print(speed,cam:get_pos());
end
--- p;15;0;1;0 将物件15设置到坐标0,1,0坐标
--- t;15 
--- c;0;0;0 设置cam坐标
local function cmd(str)
    -- print("cmd is:",str);
    local _l = func_split(str,";");
    local c = _l[1];
    if(c == "p")then
        local name = _l[2];
        local obj = core.find_name(name);
        if(obj~=0)then
            -- local ox,oy,oz =  get_attr(obj,"xyz");
            func_set_position(obj,tostring(_l[3]),tostring(_l[4]),tostring(_l[5]));
            func_print("set postion "..str);
        end
        return;
    end
    if(c == "t")then
        local name = _l[2];
        local obj = core.find_name(name);
        if(obj~=0)then
            config.curName = name;
            config.curTarget = obj;
            --config.ox,config.oy,config.oz = func_get_position(obj);
            func_print("set target "..str);
        end
        return;
    end
    if(c == "c")then
        cam:set_pos(tostring(_l[2]),tostring(_l[3]),tostring(_l[4]));        
        func_print("set cam pos "..str);
        return;
    end

end

local function lightpanel()
    if(config.isInit == 1)then
        func_warn("lightpanel is already initialization!");
        return;
    end
    config.isInit = 1;
    local uistr =   [[
        <ui name="1" type="NPanel" line="0"  center="0" width="256" height="200" x="0" y="360" bgColor="0.0,0.1,0"/>
        <ui name="lx" type="NScrollBar" x="0" y="0"   parent="1" label="lightx"/>
        <ui name="ly" type="NScrollBar" x="0" y="20"  parent="1" label="lighty"/>
        <ui name="lz" type="NScrollBar" x="0" y="40"  parent="1" label="lightz"/>
        <ui name="scale" type="NScrollBar" x="0" y="60" parent="1" label="lightscale"/>
        
        <ui name="camsc" type="NScrollBar" x="0" y="100" func="f_callBack_camScale" parent="1" label="camScale"/>
        <ui name="info" type="NLabel" width="200" height="200" x="0" y="120" parent="1" label="L1"/>

        <ui name="bg1" type="Shape" x="0" y="140" w="256" h="20" r="0" g="0" b="0" line="0" parent="1"/>
        <ui name="cmdinput1" type="Input" x="0" y="140" w="256" h="20" parent="1"/>
        <ui name="cmdok" type="NButton" x="0" y="160" w="50" h="14" parent="1" func="f_callBack_ok"/>
        ]];
        -- <ui name="target" type="CheckBox" x="128" y="80" w="50" h="14" parent="1" label="Target"  func="f_callBack_setTarget"/>
        -- <ui name="bg" type="Shape" x="0" y="80" w="128" h="20" r="0" g="0" b="0" line="0" parent="1"/>
        --         <ui name="input1" type="Input" x="0" y="80" w="128" h="20" parent="1"/>


    local nskin = NSkin:new();

    nskin.f_callBack_ok=function()        
        local nameMap = nskin:getNameMap();
        local input = nameMap['cmdinput1'];
        if(input )then
            local str = input:input_getText();
            -- print('[',str,"]");
            if(#str > 0)then
                cmd(str);
            end
            -- local obj = core.find_name(input:input_getText());
            -- -- print('[',obj,']');
           
            -- if(obj~=0)then
            --     ox,oy,oz =  get_attr(obj,"xyz");
            --     -- print(ox,oy,oz);
            -- end
        end
    end
    nskin.f_callBack_camScale = controlCamScale;
    nskin:load(uistr);
    local lightBox = BauulAvatar:new();lightBox:init({res=BauulAvatar.Res.Box});
    lightBox:setColor(0,1,0);

    local linenode = LineNode:new(2);
    linenode:setcolor(1,0,1);
    linenode:push(0,0,0);
	linenode:push(1,1,1);
	linenode:graphics_end();
    core.add(linenode);

    local function updateMatirx1()
        local nameMap = nskin:getNameMap();
        local infoLabel = nameMap["info"];

        local ox = 0;
        local oy = 0;
        local oz = 0; 
        if(config.curTarget~=0) then
            ox,oy,oz = func_get_position(config.curTarget);
        end
        local cs = 1+ nameMap["scale"]:getProgressValue() * 20;
        local lx = fcv(nameMap["lx"]:getProgressValue(),cs);
        local ly = fcv(nameMap["ly"]:getProgressValue(),cs);
        local lz = fcv(nameMap["lz"]:getProgressValue(),cs);

        core.light.x = lx + ox;
        core.light.y = ly + oy;
        core.light.z = lz + oz;
        
        lightBox:set_position(core.light.x,core.light.y,core.light.z);
        local lposx,lposy,lposz = lightBox:get_pos();
        if(config.curTarget~=0) then
            --linenode:mod(0,func_get_position(config.curTarget));
        end
        linenode:mod(1,lposx,lposy,lposz);

        -- local lx,ly,lz = lightBox:get_pos();
        nameMap["lx"]:set_text(string.format("lx %.2f",lx));
        nameMap["ly"]:set_text(string.format("ly %.2f",ly));
        nameMap["lz"]:set_text(string.format("lz %.2f",lz));
        nameMap["scale"]:set_text(string.format("s %.2f",cs));
        local camx,camy,camz = cam:get_pos();
        infoLabel:set_text(string.format("name[%s] %.1f %.1f %.1f cam: %.1f %.1f %.1f",config.curName,ox,oy,oz,camx,camy,camz));
    end
    core.frameloop(1000/30,updateMatirx1);
end
lightpanel();