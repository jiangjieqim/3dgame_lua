--����������
Animator = {
	p,--	TYPE_OBJ_VBO_FILE����
};
Animator.__index = Animator;
function Animator:new(p)
	local s = {};
    setmetatable(s,Animator);
	s.p = p;
    return s;
end

function Animator:dispose()
	func_clearTableItem(self);
end

--- ��ȡ��������
function Animator:total()
	return change_attr(self.p,"animtor_total");
end

function Animator:cur_frame()
	return change_attr(self.p,"animtor_curFrame");
end

--�Ƿ��ڲ���
function Animator:isPlaying()
	if(change_attr(self.p,"animtor_isPlaying") == 1) then
		return true;
	end
end
--����fbs
function Animator:set_fps(v)
	change_attr(self.p,"fps",tostring(v))
end

--[[
	��ʼ������(����ɶ�̬���������ļ�,������һ���༭���༭��Щ���ź�ƫ���������md2�ļ�)
	����ָ���Ķ���
	"�ɲ��Զ���ģ�� \\resource\\material\\bauul.mat"
	"stand",0,39
	"run",40,45
	"jump",66,71
--]]
function Animator:play(anim)
	local o = self.p;
	--self:pause();
	if(anim) then
		change_attr(o,"animtor_setcur",anim);--ָ����ǰ�Ķ���
	end
	change_attr(o,"animtor_play");
end

--�ָ��
function Animator:push(animname,s,e)
	change_attr(self.p,"animtor_push",animname,string.format('%s,%s',s,e));
end

--�������䲥�Ŷ���
function Animator:play_to(s,e)
	change_attr(self.p,"animtor_play_start_end",string.format('%d,%d',s,e));
	self:play();
end

--��ͣ���Ŷ���
function Animator:pause()
	change_attr(self.p,"animtor_pause");
end