print('#######################\t���ʲ���\t#######################')
local function createMaterial()
	func_error("δʵ��");
end
--����һ��obj ʹ��vboģʽ
local function func_loadobj(objName,tex,nName)
	local name
	if(nName==nil) then
		name = getName()
	else
		name = nName
	end
	objName = objName or 'quad';
	local defalutTex = '1.tga'

	tex = tex or defalutTex

	local o;
	local _path = "\\resource\\obj\\"..objName..".obj";
	local _shader;
	local _texturePath = "\\resource\\texture\\"..tex;

	
	_shader = "diffuse";
	
	-- o=load_model(name,_path,0,0,0,1.0);	
	o = nil;

	setv(o,FLAGS_VISIBLE);
	
	--print("===============>",_texturePath,string.format("���ص�ģ��(%s),ģ����(%s)�Ƿ���VBOģʽ:%s",_path,nName,tostring(vbo)));

	local m=createMaterial(_shader,_texturePath);
	
	core.meterial.set(o,m);
	return o;
	--]]
end
--����glsl����
--�п��ܵ�ǰ���ʵ���ɫ��������û�йؼ���key,��ô��ʱ������ֵ��ʱ��ͻ�ʧ��
local function func_set_glsl_parms(o,key,v)
	func_error("func_set_glsl_parms");
	---	change_attr(o,"glslParms",string.format('%s,%s',key,tostring(v)))
end

--����һ���̶�����ģ������md2,obj
local function func_fixed_load(url,scale,texpath)
	local o=load_model(core.getName(),url or "\\resource\\obj\\torus.obj",0,0,0,scale or 1.0)
	local mat1=createMaterial("diffuse",texpath or ("\\resource\\texture\\1.tga"),"")
	core.meterial.set(o,mat1);
	setv(o,FLAGS_VISIBLE);
	return o;
end

--�Ƿ���õ���VBOģʽ��Ⱦ��
local function func_is_vbo(obj)
    if(core.get_type_str(obj)=="vbo") then
		return true
	end
	return false
end

--local _model_ptr;

-- ��ʼ����ʾ
local function f_set_obj_flags(o)
    setv(o, FLAGS_VISIBLE);
    -- setv(o,FLAGS_GLSL_OUTLINE);
    --  setv(o,FLAGS_DRAW_PLOYGON_LINE);--�߿���Ⱦ
    -- setv(o,FLAGS_DRAW_NORMAL);


    -- ����ʰȡ
    --- [[
    setv(o, FLAGS_RAY);
    setv(o, FLAGS_DRAW_RAY_COLLISION);
    setv(o, FLAGS_RENDER_BOUND_BOX);
    -- ]]

end

-- ����һ����͸��ͨ������Ҷģ��
local function load_alpha_model(objName)
    -- local time = func_get_longTime()
    objName = objName or "quad"
    local o = func_loadobj(objName)
    -- load_VBO_model(name,"\\resource\\obj\\"..objName..".obj");
    local m = createMaterial("vboDiffuse", "\\resource\\texture\\leaf.tga");
    core.meterial.set(o, m);
    f_set_obj_flags(o);
    -- func_print(string.format('load_alpha_model ���� %d ms', func_get_longTime() - time));
    return o;
end
local function f_setLabel(label, obj)

    if (label == 'diffuse') then

    elseif (label == 'ploygonLine') then

        -- setv(obj, FLAGS_DRAW_PLOYGON_LINE)

    elseif (label == 'outline') then

        -- setv(obj,FLAGS_DISABLE_CULL_FACE)--������˫��
        if (func_is_vbo(obj)) then
            func_error("vbo��֧��!!!")
        end
        setv(obj, FLAGS_OUTLINE)
    elseif (label == 'point') then

        setv(obj, FLAGS_DRAW_PLOYGON_POINT)

    elseif (label == 'glslOutline') then
        -- setv(obj,FLAGS_DRAW_PLOYGON_LINE)

        -- ��һЩ�����ɫ����û����Щ�����ͻ�������Ч

        -- func_set_glsl_parms(obj, 'lineWidth', 0.05)
        -- func_set_glsl_parms(obj, 'alpha', 0.5)

        setv(obj, FLAGS_GLSL_OUTLINE)
        -- print('***')
    elseif (label == 'normal') then
        if (func_is_vbo(obj)) then
            func_error("vbo��֧��!!!")
        end
        setv(obj, FLAGS_DRAW_NORMAL)
        -- ���Ʒ���

    elseif (label == 'drawCollison') then
        if (func_is_vbo(obj)) then
            func_error("vbo��֧��!!!")
        end

        setv(obj, FLAGS_DRAW_RAY_COLLISION)
    end

end

local g_model;
local function f_listCallBack(self,index,param)
	--	list
	
	--local index = listbox_get_index(list);
	 --local _l = listbox;
		
	--print(g_model);

	if (g_model) then
		core.ptr_remove(g_model);
		--return;
	end


	-- local t = func_get_longTime();
	local obj = func_fixed_load()
	core.cam:bind(obj);
	
	if (obj) then

		g_model = obj;
		
	    
		local label = self:getLabelByIndex(index);--listbox_get_select_label(list);
		
		local s = string.format('index = %d\tlabel = [%s]\t	vbo:%s',index,label,tostring(func_is_vbo(obj)))

		-- print(s..","..(func_get_longTime() - t));

		f_setLabel(label, g_model);
	end
end

-- ###############################################################
-- ��ʼ��listbox,�������Բ�ͬ�Ĳ���
local function f_shader_init()
	--local list = listbox_new(0,50);
	local list = NListBox:new(0,0,128);
	list:addItem("diffuse");
	list:addItem("ploygonLine");
	list:addItem("outline");
	list:addItem("point");
	list:addItem("drawCollison");
	
	list:addItem("glslOutline");
	list:addItem("normal");
	
--	list:addItem("���ʲ���");

	list:bind(f_listCallBack);

    return list;
end

-- #########################################################

-- load_alpha_model()

local list = f_shader_init();

-- listbox_select(list,0)--Ĭ��ѡ��һ��
