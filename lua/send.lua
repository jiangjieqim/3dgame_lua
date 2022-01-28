
--添加lua脚本路径
require("core");
require("utils/kittools");

local Byte = require("utils/byte");

core.debug(1);
    -- local img = Image:new(100,50);
    -- img:seticon(url or "smallbtn.png");
  

-- local s = core.ui.Shape:new();
-- s:setcolor(1,0,0);
--     --core.print_info();
--     local i = 0;
--     core.setTimeout(1000,function ()
--         local n = 1;
--         i = i + 1;
--         func_gc();
--         core.print_info();

--         end,
--         0
--     );


-- func_gc();

-- local mem = NLabel:new(200,200);
-- mem:set_text(1);


-- local mem = NLabel:new();
-- mem:set_pos(100,0);

-- local function showtxt()
--     local n = 0;
--     core.setTimeout(1000,function ()
--         if(mem)then
--             local disableBytes,totalBytes = core.memory_info();
--             -- local use = totalBytes - disableBytes;
--             mem:set_text(disableBytes.."/"..totalBytes);
--             -- mem1:set_text(math.random());
--             if(n % 2 == 1) then
--                 mem:set_pos(2,2);
--             else
--                 mem:set_pos(0,0);
--             end
--             n = n + 1;
--         end
--     end,0,true)
-- end

-- showtxt();

--[[

local btn1 = Button:new();
btn1:set_label("gc");
btn1:set_pos(0,40);

btn1:bind_click(function()
    -- local obj = NUnit

    func_gc();
    -- core.print_info();

    -- func_lua_gc();

    -- n:scale(0.05);

end);


]]
-- local Shape = core.ui.Shape;
local n;
local function f_onkey(data)
    local key = tonumber(data);
    func_print(string.format(">>>>>>>>>>>>>>>>>>>>> key = %s", key));
    if(key == core.KeyEvent.KEY_1) then
        -- func_lua_gc();
        func_gc();
        
    elseif(key == core.KeyEvent.KEY_2)then
        if(n == nil) then
            -- n =  Shape:new(50,25);
            -- n:setcolor(1);
--[[
           
			
			n=LineNode:new(4);
			n:push(-0.5,0.4,0.5);
			n:push( 0.5, 0.0, 0.5);
			n:push( -0.5, -0.49, -0.5);
			n:push( 0, 0, -10);
			n:setcolor(1,0,0);
			n:graphics_end();
            core.add(n);
            
            n = FboRender:new(100,100);
            n:mouseEnable(true);
            n:set_pos(10,100);

            n = Shape:new(50,25);
            n:setcolor(1);
            n:set_pos(100,0);

]]
            n =  Button:new();
            
                    
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

kit.checkComp();
kit.debugView();

-- require("editor");
-- local e1 = Editor:new();
-- e1:createLine();
-- e1:createAxis();
-- e1:showfps();

--[[
-- print('>>'..core.get_time());
local curtime = core.get_time();
local code,_socket = lsocket_connect("127.0.0.1",6000);
print("connect use "..(core.get_time()-curtime).." ms code:"..code);
local modelstr =  func_loadfile("\\resource\\md2\\horse.md2");
-- local modelstr =  func_loadfile("\\resource\\md2\\horse.md2");--teapot.obj  code.min.js    sphere
-- local modelstr =  func_loadfile("\\resource\\obj\\code.min.js");
local _bytesLen = string.len(modelstr);
-- print("modelstr:"..bytesLength.." byte");
--print('['..modelstr..']');


-- local bs = Byte.new(_bytesLen+4);
-- Byte.writeUTF(bs,modelstr);
-- Byte.check(bs);

if(code == 0) then
    -- lsocket_send(_socket,"jiangjieqi".. math.random());
    local getTime = os.date("%c");

    local btn = Button:new();
    btn:set_label("send data");
    local a = 0;
    btn:bind_click(function()
       
        a = a + 1;
        local s = modelstr;
        -- for i=1,1,1 do
        --     s = s..s;
        -- end

        -- s = "ab";

        local t1 = core.get_time();
        local _scode = lsocket_send(_socket,s,_bytesLen);

     
        -- local _scode = lsocket_send(_socket,"ab",3);
        print("use "..(core.get_time()-t1).." ms sendcode:".._scode);
    end);

    local btn1 = Button:new();
    btn1:set_label("close");
    btn1:set_pos(0,20);
    btn1:bind_click(function()
        lsocket_close(_socket);
    end);
else
    print("connect fail!");
end
--]]

