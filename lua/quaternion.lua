--cam:position(0, 0, -5);
-- cam:rx(PI * 1.7);
core.cam:set_pos(0,0,-5);

--FpsView:getIns():show();--��ʾfps

local function getMid(x0, y0, z0, x1, y1,z1)
	local x2,y2,z2 =vec3_normal(x0,y0,z0);
	local x3,y3,z3 =vec3_normal(x1,y1,z1);
	return vec3_add(x2, y2, z2, x3, y3, z3);
end

-- ��ֱ����
local function f_load_c()
	
  --[[  local box = UnitBase:new();
    box:loadbox();
    box:scale(0.25);--]]
	
	
	local zeroPoint = LineNode:new(1,true);
	zeroPoint:push(0,0,0);
	zeroPoint:setcolor(1,0,0);
	zeroPoint:graphics_end();

	
	
	
	--��ת������
	local tg = LineNode:new(2);
	tg:setcolor(0,1,0);
	tg:push(0,0,0);
	tg:push(0,1,0);
	tg:graphics_end();
	
	--Ŀ������
	local eg = LineNode:new(2);
	eg:setcolor(0,1,1);
	eg:push(0,0,0);
	eg:push(0,1,0);
	eg:graphics_end();
	
	--ƽ������
	local mid = LineNode:new(2);
	mid:setcolor(1,0,1);
	mid:push(0,0,0)
	mid:push(0,1,0);
	mid:graphics_end();

    -- ��Ϣ�ı�
    local tf = NLabel:new(256,256); 	--ftext_create(128, 128);
    -- tf_create(128,list.x,list.y + g_gap*(count),r,g,b);
    --ftext_setpos(tf, 0, 12);
	tf:set_pos(0,12);

	
    local sc = NScrollBar:new(0,100)
    
	local function quat_slerp(x0, y0, z0, x1, y1,z1, v)
		local _DEBUG_ = true;
		
		if(_DEBUG_) then
			local x2,y2,z2 =vec3_normal(x1,y1,z1);
			eg:mod(1,x2,y2,z2);
			
			
	--		mid:mod(1,0.707,-0.707,0);

			local x3,y3,z3 = getMid(x0, y0, z0, x1, y1,z1);
			x3,y3,z3=vec3_normal(x3,y3,z3);
			
			mid:mod(1,x3,y3,z3);--�����ص������
		end
		return quat("Quat_slerp", x0, y0,z0, x1, y1,z1, v);
	end
	local function scHandler(progress)
		local v = progress;
		
        -- print("����ģ��("..string.format("%#x",tonumber(model))..') fps = '..	string.format("%0.2f", v))

		
		
		--˳ʱ��
		--0 <= angle <=90			90
        --local x, y, z,w = quat_slerp(	0,1,0,	 1,0,0, v);
															
			
		--n 45												
		local x, y, z,w = quat_slerp(	0,1,0,	 -1,1,0, v);
		--s 45
		--local x, y, z,w = quat_slerp(	-1,1,0,	  0,1,0, v);

		
		-- 90<angle<=180		��ʱ�� 135
		--local x, y, z,w = quat_slerp(	1,	0,	0, 		-1,	1,	0, v);
									
			
		--		˳ʱ�� 135
		--local x, y, z,w = quat_slerp(-1,	1,	0, 		1,	0,	0, v);
									
		--		180
		--local x, y, z,w = quat_slerp(1,0,0, 		-1,	0,	0, v);
		
		
		--s 45
		--local x, y, z,w = quat_slerp(1,0,0, 		1,	-1,	0, v);
		
		
		--s 90
		--local x, y, z,w = quat_slerp(1,0,0, 		0,	-1,	0, v);
		
		--n 180
		--local x, y, z,w = quat_slerp(1,0,0, 		-1,	0,	0, v);
		
		--n 135
		--local x, y, z,w = quat_slerp(-1,0,0, 		1,	-1,	0, v);

		--local x, y, z,w = quat_slerp(1,0,0, 		-1,	0.1,	0, v);
		tg:mod(1,x,y,z);
	end
	
	sc:bindCallback(scHandler);
	
	scHandler(0);
    --scrollBar_setRange(sc, 0, 1)
	
	--local m = math.sqrt(0.707*0.707 + 0.707*0.707);	-- 1
	--print(m);
end


--[[


(-1,1)                       (0,1)y						(1,1)
                            ^
                            *
                            *
                            *
                            *
(-1,0)* * * * * * * * * * * * * * * * * * * * * * * *>x  (1,0)
                            *0
                            *
                            *
                            *
                            *
                            *
 (-1,-1)                    *(0.-1)						(1,-1)			


--]]


--local x, y, z = vec3_cross(0.72, -0.69, 0, 0, 0, 1);
--loadObj();

-- print(x, y, z);--��+90֮�������
f_load_c();

-- print(vec3_dot(0.72,-0.69, 0,       0,-1,0));
