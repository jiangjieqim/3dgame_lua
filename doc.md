emmylua开源地址 https://github.com/EmmyLua/VSCode-EmmyLua

# emmylua_new
**1.安装EmmyLua for VSCode***

https://emmylua.github.io/

(1).create a launch.json ---> EmmyLua New Debugger ---> 创建json文件
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

**2.代码中启动调试器**  
(1)先启动test.exe宿主进程(如D:\github\3dgame_ev_1_0_0\debug\test.exe)  
(2)
``` 
--将emmy模块dll加载到进程  
package.cpath = package.cpath .. ";c:/Users/TR/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"  
--也可以自定义dll路径 package.cpath = package.cpath .. ";c:/3dgame_lua/emmy/emmy_core.dll";

--加载模块emmy_core  
dbg = require("emmy_core");  

--tcp监听端口9966,该端口对应launch.json的port参数  
dbg.tcpListen("localhost", 9966);  

--emmy版本  
print(dbg);--[EMMY]lua version: 51

```

**断点**  
> dbg.breakHere()  
在需要下断点的地方调用此接口

> dbg.waitIDE();  
在需要等待ide启用的时候开启,其实原理就是用socket阻塞掉宿主进程,等调试器进入后换醒进程。

# emmylua_attach
```
{
    "type": "emmylua_attach",
    "request": "attach",
    "name": "Attach by process id",
    "pid": 0
},
```
绑定进程id调试  
> test.c接口GetCurrentProcessId();

# lua-debug调试Lua插件 
插件地址[https://marketplace.visualstudio.com/items?itemName=actboy168.lua-debug]
```
{
    "name": "launch",
    "type": "lua",
    "request": "launch",
    "stopOnEntry": false,//是否在入口断点

    "runtimeExecutable": "D:/github/3dgame_ev_1_0_0/debug/test.exe",
    "runtimeArgs": "-lua test1.lua",
    "consoleCoding": "utf8"
},
```