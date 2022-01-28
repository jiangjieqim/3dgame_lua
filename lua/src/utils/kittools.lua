--小工具集合
kit = {};
kit.anim_label= function(x,y,ms)
    local label = NLabel:new();
    label:set_pos(x,y);
    
    local cnt = 0;
    core.setTimeout(ms or 1,function ()
        cnt = cnt + 1;
        label:set_text(cnt);
    end,nil,true);
 end

--组件检查用例
kit.checkComp = function()
    local ox = 10;
    local n = NLabel:new();
    n:set_pos(ox,0);
    n:set_text("Text");

    --按钮组件
    ---@type Button
    local btn1 = Button:new();
    btn1:set_label("button");
    btn1:set_pos(ox,20);
    btn1:bind_click(function ()
        func_print("button!");
    end);

    --绘制线段
    local n=LineNode:new(4);
    n:push(-0.5,0.4,0.5);
    n:push( 0.5, 0.0, 0.5);
    n:push( -0.5, -0.49, -0.5);
    n:push( 0, 0, -10);
    n:setcolor(1,0,0);
    -- n:mod(3,10,10,10);//error
    n:graphics_end();
    -- n:mod(3,10,10,10);
    core.add(n);
    ---------------------------------------------------
    --md2模型动画组件
    n = UnitBase:new();
    local url="\\resource\\md2\\triangle.md2";--bauul,triangle
    local mat = "//resource//material//bauul.mat";
    n:loadvbo(url,mat);
    -- n:scale(0.01);
    -- n:load_collide("\\resource\\obj\\box.obj",true);
    -- n:drawRayCollison(true);
    -- n:drawRayCollison(false);

    n:set_position(0,0,-2.5);
    local material = n:getMaterial();
    local _status = false;
    core.setTimeout(1000,function ()
        _status = not _status;
        -- e = (a > b and c) or d
        local _type = _status and GL.CULL_FACE_BACK or GL.CULL_FACE_FRONT;
        core.meterial.setCullface(material, _type);
    end,nil,true);
    core.add(n);
     --FboRender
     local n = FboRender:new(64,64);
     n:mouseEnable(true);
     n:set_pos(ox+50,100);

    local img =  Image:new(32,32,n:get_renderlist());
    img:seticon("dagou.png");
    img:set_pos(5,-10);

    --- 一个面包圈obj模型
    ---@type UnitBase
    n = UnitBase:new();
    
    local url="\\resource\\obj\\torus.obj";--bauul,triangle
    local mat = "//resource//material//triangle.mat";
    local _modelScale = 1.0;
    n:loadvbo(url,mat);
    n:set_position(0,0,-2.5);
    n:scale(_modelScale);
    n:load_collide("\\resource\\obj\\torus.obj",true,_modelScale);
    local material = n:getMaterial();
    shader_updateVal(material,"_Alpha",1.0);
    -- n:load_collide("\\resource\\obj\\torus.obj",true);
    core.add(n);
    -- n:setCam(cam);
    -- set_cam(n.p,cam);

    n = Shape:new(50,25);
    n:setcolor(1);
    n:set_pos(ox,40);

    n = Shape:new(50,25);
    n:setcolor(1);
    n:set_pos(ox,70);
    -- n:drawPloygonLine(true);
    n:polyMode(GL.GL_LINE);

    local n = Image:new();
    n:seticon("smallbtn.png");
    n:set_pos(ox,120);

    local n = CheckBox:new();
    n:set_pos(ox,150)
    n:setlabel("checkbox");

    ScrollViewCase1(120,10);
    example_input(ox,170);
   
end

kit.debugView = function()
    require("view/DebugView"):new();
end



local n;
kit.keyLis = function()
    local function f_onkey(data)
        local key = tonumber(data);
        func_print(string.format(">>>>>>>>>>>>>>>>>>>>> key = %s", key));
        if(key == core.KeyEvent.KEY_1) then
            -- func_lua_gc();
            func_gc();
        elseif(key == core.KeyEvent.KEY_2)then
            if(n == nil) then

            end
        elseif(key == core.KeyEvent.KEY_3)then
            if(n == nil) then
            else
                --func_print(">>>>>>>>>>>>>>>>");
                n:dispose();
                n=nil;
            end
        elseif(key == core.KeyEvent.KEY_4)then
            core.print_info();
        elseif(key == core.KeyEvent.KEY_ESC)then
            core.exit();
        end
    end
    evt_on(core.engine,core.ex_event.EVENT_ENGINE_KEYBOARD,f_onkey);
end


--创建箭头
local function f_craeteAxis(x,y,z)
    local ln= LineNode:new(2);
    local r,g,b = vec3_normal(x,y,z);
    ln:setcolor(r,g,b);
	ln:push(0,0,0);
	ln:push(x,y,z);
	ln:graphics_end();
	core.add(ln);
	return ln;
end
--- 创建红绿蓝的箭头
--- len线段的长度
kit.showAxis = function(len)   
    len = len or 1;
    f_craeteAxis(len,0,0);
    f_craeteAxis(0,len,0);
    f_craeteAxis(0,0,len);
end

return kit;