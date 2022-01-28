TexCache = {
	
};
TexCache.__index = TexCache;

function TexCache:new()
    local self = {
        list={},
    }
    setmetatable(self, TexCache);

    return self;
end

local function f_getTex(list,icon)
	for k,v in pairs(list) do
		local t = list[k];
		--print(t);
		if(t.icon == icon) then
			return t.tex;
		end
	end
end
--从缓存中获取纹理句柄
function TexCache:get_tex(atals,icon)
    -- local _find;
    for k,v in pairs(self.list) do
        if(k == atals) then
            -- _find = true;

            local list = self.list[k];
            
			local tex = f_getTex(list,icon);
			if(tex~=nil) then
				return tex;
			end
        end
    end
    -- if(_find==nil) then
    --     local node = {};
    --     node.cnt  = 1;
    --     node.icon = icon;
    --     self.list[atals] = node;
    -- end
    return 0;
end
--返回删除完之后的引用个数
function TexCache:delTex(tex)

    for k,v in pairs(self.list) do

        local value= self.list[k];
        
        local node = value[tex];
        if(node~=nil) then

            node.cnt = node.cnt - 1;
            
            if(node.cnt==0) then
                func_print('TexCache:delTex,tex['..tex..'] icon = ['..(node.icon or 'nil')..'],you will be dispose this tex!');
                self.list[k][tex] = nil;
                func_clearTableItem(node);
                return 0;
            else
                func_print('TexCache:delTex,tex = ['..tex..'] cnt = '.. node.cnt..',you have cache!');
                return node.cnt;
            end
        end
    end
    -- func_error('didn`t find tex=['..tex..']');
end
function TexCache:info()
    local str = '';
    
    -- print(string.len(str));
    -- func_print('tex\ticon\tcnt');
    local space = '\t\t\t  ';
    for k,v in pairs(self.list) do

        local value= self.list[k];
		
		for k1,v1 in pairs(value) do
			local node = value[k1];
			
            -- func_print();
            str = str..space..node.tex..'\t'..node.icon..'\t'..node.cnt..'\n'
		end
    end

    if(string.len(str)>0) then 
        str = '\n'..space..'tex\ticon\tcnt\n'..str;
        str = string.sub(str,0,string.len(str)-1);
        func_print(str);
    end
end
---atals:图集引用
---icon :checkbox.png 纹理key
---tex  :纹理句柄
function TexCache:add_tex(atals,icon,tex)
	local node;
    if(self.list[atals] == nil) then
        self.list[atals] = {};
    end
    if(self.list[atals][tex] == nil) then
        node = {};
        node.cnt  = 1;
        node.icon = icon;
        node.tex = tex;
        self.list[atals][tex] = node;
    else
        node = self.list[atals][tex];
        node.cnt = node.cnt + 1;
    end
    func_print('TexCache:add_tex,tex = '..tex..',cache cnt = '..node.cnt);
end