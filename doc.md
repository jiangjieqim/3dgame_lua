emmylua��Դ��ַ https://github.com/EmmyLua/VSCode-EmmyLua

# emmylua_new
**1.��װEmmyLua for VSCode***

https://emmylua.github.io/

(1).create a launch.json ---> EmmyLua New Debugger ---> ����json�ļ�
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "emmylua_new",
            "request": "launch",
            "name": "EmmyLua New Debug",
            "host": "localhost",
            "port": 9966,
            "ext": [
                ".lua",
                ".lua.txt",
                ".lua.bytes"
            ],
            "ideConnectDebugger": true
        }
    ]
}
```

**2.����������������**  
(1)������test.exe��������  
(2)
``` 
--��emmyģ��dll���ص�����  
package.cpath = package.cpath .. ";c:/Users/TR/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"  
--Ҳ�����Զ���dll·�� package.cpath = package.cpath .. ";c:/3dgame_lua/emmy/emmy_core.dll";

--����ģ��emmy_core  
dbg = require("emmy_core");  

--tcp�����˿�9966,�ö˿ڶ�Ӧlaunch.json��port����  
dbg.tcpListen("localhost", 9966);  

--emmy�汾  
print(dbg);--[EMMY]lua version: 51

```

**�ϵ�**  
> dbg.breakHere()  
����Ҫ�¶ϵ�ĵط����ô˽ӿ�

> dbg.waitIDE();  
����Ҫ�ȴ�ide���õ�ʱ����,��ʵԭ�������socket��������������,�ȵ�����������ѽ��̡�

# emmylua_attach
```
{
    "type": "emmylua_attach",
    "request": "attach",
    "name": "Attach by process id",
    "pid": 0
},
```
�󶨽���id����  
> test.c�ӿ�GetCurrentProcessId();
