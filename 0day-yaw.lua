-- github https://github.com/YouRan4/primordial-script
require('callback')
require('Script Settings')
local bit = require('bit')
local ffi = require('ffi')
local chat = require('chat printing lib')
local notifications = require('notifications')
local json = require('JSON')
local print = function (obj)
    print(tostring(obj))
end
local function trueRandom(min,max)
    --得到一个时间字符串
    local strTime = tostring(client.get_unix_time())
    local strRes = string.reverse(strTime)
    local strRandomTime = string.sub(strRes,1,6)
    math.randomseed(strRandomTime)
    return math.random(min,max)
end
local ffiHand = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll','53 56 57 8B DA 8B F9 FF 15'))
local change_tag_fn = function (value)
    ffiHand(value,value)
end
local _,slowWalk =unpack(menu.find('misc','main','movement','slow walk'))
local _,autoPeek =unpack(menu.find('aimbot','general','misc','autopeek'))
local aimantin = menu.add_selection('AntiAim','antiaim state',{'Stand','Movine','Slowwalking','In Air','Duck','On Peek'},6)
local menuRef = {
    ['fakeLag']=menu.find('antiaim','main','fakelag','amount'),
    ['pitch']=menu.find('antiaim','main','angles','pitch'),
    ['yawBase']=menu.find('antiaim','main','angles','yaw base'),
    ['yawAdd']=menu.find('antiaim','main','angles','yaw add'),
    ['roTate']=menu.find('antiaim','main','angles','rotate'),
    ['roTateRange']=menu.find('antiaim','main','angles','rotate range'),
    ['roTateSpeed']=menu.find('antiaim','main','angles','rotate speed'),
    ['jitterMode']=menu.find('antiaim','main','angles','jitter mode'),
    ['jitterType']=menu.find('antiaim','main','angles','jitter type'),
    ['jitterAdd']=menu.find('antiaim','main','angles','jitter add'),
    ['bodyLean']=menu.find('antiaim','main','angles','body lean'),
    ['bodyLeanValue']=menu.find('antiaim','main','angles','body lean value'),
    ['movBodyLean']=menu.find('antiaim','main','angles','moving body lean'),
    ['desync']=menu.find('antiaim','main','desync','side#stand'),
    ['desyncm']=menu.find('antiaim','main','desync','override stand#move'),
    ['desyncs']=menu.find('antiaim','main','desync','override stand#slow walk'),
    ['ewm']=menu.find('antiaim','main','extended angles','enable while moving'),
    ['epitch']=menu.find('antiaim','main','extended angles','pitch'),
    ['etype']=menu.find('antiaim','main','extended angles','type'),
    ['eoffset']=menu.find('antiaim','main','extended angles','offset'),
    ['maxRoll']=menu.find('misc', 'main', 'server settings', 'max body lean')
}
local yawBase = {
    ['Stand'] = menu.add_selection('AntiAim','Stand Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek Yaw Base',{'none','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),}
local pitch = {
    ['Stand'] = menu.add_selection('AntiAim','Stand pitch',{'none','down','up','zero','jitter'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine pitch',{'none','down','up','zero','jitter'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking pitch',{'none','down','up','zero','jitter'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air pitch',{'none','down','up','zero','jitter'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck pitch',{'none','down','up','zero','jitter'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek pitch',{'none','down','up','zero','jitter'}),
}
local desync = {
    ['Stand'] = menu.add_selection('AntiAim','Stand desync',{'none','left','right','jitter','peek fake','peek real'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine desync',{'none','left','right','jitter','peek fake','peek real'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking desync',{'none','left','right','jitter','peek fake','peek real'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air desync',{'none','left','right','jitter','peek fake','peek real'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck desync',{'none','left','right','jitter','peek fake','peek real'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek desync',{'none','left','right','jitter','peek fake','peek real'}),
}
local yawAdd = {
    ['Stand'] = menu.add_slider('AntiAim','Stand Yaw Add ',-180,180,1,0,'°'),
    ['Movine'] = menu.add_slider('AntiAim','Movine Yaw Add ',-180,180,1,0,'°'),
    ['Slowwalking'] = menu.add_slider('AntiAim','Slowwalking Yaw Add ',-180,180,1,0,'°'),
    ['In Air'] = menu.add_slider('AntiAim','In Air Yaw Add ',-180,180,1,0,'°'),
    ['Duck'] = menu.add_slider('AntiAim','Duck Yaw Add ',-180,180,1,0,'°'),
    ['On Peek'] = menu.add_slider('AntiAim','On Peek Yaw Add ',-180,180,1,0,'°'),
}
local yawAddMode = {
    ['Stand'] = menu.add_selection('AntiAim','Stand Yaw Add Add Jitter Mode Left',{"none","static","random"}),
    ['Movine'] = menu.add_selection('AntiAim','Movine Yaw Add Add Jitter Mode Left',{"none","static","random"}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking Yaw Add Add Jitter Mode Left',{"none","static","random"}),
    ['In Air'] = menu.add_selection('AntiAim','In Air Yaw Add Add Jitter Mode Left',{"none","static","random"}),
    ['Duck'] = menu.add_selection('AntiAim','Duck Yaw Add Add Jitter Mode Left',{"none","static","random"}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek Yaw Add Add Jitter Mode Left',{"none","static","random"}),
}
local jitter = {
    ['Stand'] = menu.add_slider('AntiAim','Stand Yaw Add Jitter Left',-180,180,1,0,'°'),
    ['Movine'] = menu.add_slider('AntiAim','Movine Yaw Add Jitter Left',-180,180,1,0,'°'),
    ['Slowwalking'] = menu.add_slider('AntiAim','Slowwalking Yaw Add Jitter Left',-180,180,1,0,'°'),
    ['In Air'] = menu.add_slider('AntiAim','In Air Yaw Add Jitter Left',-180,180,1,0,'°'),
    ['Duck'] = menu.add_slider('AntiAim','Duck Yaw Add Jitter Left',-180,180,1,0,'°'),
    ['On Peek'] = menu.add_slider('AntiAim','On Peek Yaw Add Jitter Left',-180,180,1,0,'°'),
}
local jitterMode = {
    ['Stand'] = menu.add_selection('AntiAim','Stand jitter Mode ',{'none','static','random'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine jitter Mode ',{'none','static','random'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking jitter Mode ',{'none','static','random'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air jitter Mode ',{'none','static','random'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck jitter Mode ',{'none','static','random'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek jitter Mode ',{'none','static','random'}),
}
local jitterType = {
    ['Stand'] = menu.add_selection('AntiAim','Stand jitter Type ',{'offset','center'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine jitter Type ',{'offset','center'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking jitter Type ',{'offset','center'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air jitter Type ',{'offset','center'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck jitter Type ',{'offset','center'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek jitter Type ',{'offset','center'}),
}
local jitterAdd = {
    ['Stand'] = menu.add_slider('AntiAim','Stand Jitter Add ',-180,180,1,0,'°'),
    ['Movine'] = menu.add_slider('AntiAim','Movine Jitter Add ',-180,180,1,0,'°'),
    ['Slowwalking'] = menu.add_slider('AntiAim','Slowwalking Jitter Add ',-180,180,1,0,'°'),
    ['In Air'] = menu.add_slider('AntiAim','In Air Jitter Add ',-180,180,1,0,'°'),
    ['Duck'] = menu.add_slider('AntiAim','Duck Jitter Add ',-180,180,1,0,'°'),
    ['On Peek'] = menu.add_slider('AntiAim','On Peek Jitter Add ',-180,180,1,0,'°'),
}
local fakelagMode = {
    ['Stand'] = menu.add_selection('AntiAim','Stand fakelag Mode ',{'none','static','random'}),
    ['Movine'] = menu.add_selection('AntiAim','Movine fakelag Mode ',{'none','static','random'}),
    ['Slowwalking'] = menu.add_selection('AntiAim','Slowwalking fakelag Mode ',{'none','static','random'}),
    ['In Air'] = menu.add_selection('AntiAim','In Air fakelag Mode ',{'none','static','random'}),
    ['Duck'] = menu.add_selection('AntiAim','Duck fakelag Mode ',{'none','static','random'}),
    ['On Peek'] = menu.add_selection('AntiAim','On Peek fakelag Mode ',{'none','static','random'}),
}
local fakelag = {
    ['Stand'] = menu.add_slider("AntiAim","In Stand Fakelag",1,15),
    ['Movine'] = menu.add_slider("AntiAim","In Movin Fakelag",1,15),
    ['Slowwalking'] = menu.add_slider("AntiAim","In Walk Fakelag",1,15),
    ['In Air'] = menu.add_slider("AntiAim","In Air Fakelag",1,15),
    ['Duck'] = menu.add_slider("AntiAim","In Duck Fakelag",1,15),
    ['On Peek'] = menu.add_slider("AntiAim","In Peek Fakelag",1,15),
}
local fakelagmin = {
    ['Stand'] = menu.add_slider("AntiAim","In Stand Fakelag",1,15),
    ['Movine'] = menu.add_slider("AntiAim","In Movin Fakelag",1,15),
    ['Slowwalking'] = menu.add_slider("AntiAim","In Walk Fakelag",1,15),
    ['In Air'] = menu.add_slider("AntiAim","In Air Fakelag",1,15),
    ['Duck'] = menu.add_slider("AntiAim","In Duck Fakelag",1,15),
    ['On Peek'] = menu.add_slider("AntiAim","In Peek Fakelag",1,15),
}
local fakelagmax = {
    ['Stand'] = menu.add_slider("AntiAim","In Stand Fakelag",1,15),
    ['Movine'] = menu.add_slider("AntiAim","In Movin Fakelag",1,15),
    ['Slowwalking'] = menu.add_slider("AntiAim","In Walk Fakelag",1,15),
    ['In Air'] = menu.add_slider("AntiAim","In Air Fakelag",1,15),
    ['Duck'] = menu.add_slider("AntiAim","In Duck Fakelag",1,15),
    ['On Peek'] = menu.add_slider("AntiAim","In Peek Fakelag",1,15),
}
function uiupdate()
    local selectNam = aimantin:get_item_name(aimantin:get())
    for k,v in pairs(pitch) do
        if k==selectNam then
            pitch[k]:set_visible(true)
            yawBase[k]:set_visible(true)
            desync[k]:set_visible(true)
            fakelag[k]:set_visible(true)
            yawAdd[k]:set_visible(true)
            yawAddMode[k]:set_visible(true)
            jitterMode[k]:set_visible(true)
            jitterType[k]:set_visible(true)
            jitterAdd[k]:set_visible(true)
            jitter[k]:set_visible(true)
        else
            pitch[k]:set_visible(false)
            yawBase[k]:set_visible(false)
            desync[k]:set_visible(false)
            fakelag[k]:set_visible(false)
            yawAdd[k]:set_visible(false)
            yawAddMode[k]:set_visible(false)
            jitterMode[k]:set_visible(false)
            jitterType[k]:set_visible(false)
            jitterAdd[k]:set_visible(false)
            jitter[k]:set_visible(false)
        end
    end
end
uiupdate()
menu.add_callback(aimantin, function()
    uiupdate()
end)
local switch = false
local fswitch = false
local Animationdestruction = function(ctx)
    local choked = engine.get_choked_commands()
    if choked == 0 then
        return
    end
    local state = 'Stand'
    local lp = entity_list.get_local_player()
    if lp==nil then
        return
    end
    local velocity = lp:get_prop('m_vecVelocity')
    if not autoPeek:get() then
        if (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) and not slowWalk:get() and bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) ~= 0 and lp:get_prop('m_flDuckAmount')<=0.8 then
            state='Movine'
        elseif slowWalk:get() and (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) then
            state='Slowwalking'
        elseif bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) == 0 then
            state='In Air'
        elseif lp:get_prop('m_flDuckAmount') > 0.8 then
            state='Duck'
        end
    elseif autoPeek:get() then
        state='On Peek'
    end

    menuRef['pitch']:set(pitch[state]:get())
    menuRef['yawBase']:set(yawBase[state]:get())
    menuRef['desync']:set(desync[state]:get())
    menuRef['desyncm']:set(false)
    menuRef['desyncs']:set(false)
    menuRef['jitterMode']:set(jitterMode[state]:get())
    menuRef['jitterType']:set(jitterType[state]:get())
    menuRef['jitterAdd']:set(jitterAdd[state]:get())
    local yawAddValue = 0
    if yawAddMode[state]:get()==1 then
        yawAddValue=yawAdd[state]:get()
    elseif yawAddMode[state]:get()==2 then
        local side = switch and -1 or 1
        local jitter = jitter[state]:get() / 2 * side
        yawAddValue=(yawAdd[state]:get() + jitter)
        switch = not switch
    elseif yawAddMode[state]:get()==3 then
        yawAddValue=trueRandom(-(math.abs(jitter[state]:get())),math.abs(jitter[state]:get()))
    end

    local fakelagValue = 0
    if fakelagMode[state]:get()==1 then
        fakelagValue=fakelag[state]:get()
    elseif fakelagMode[state]:get()==2 then
        fakelagValue=fswitch and fakelagmin[state]:get() or fakelagmax[state]:get()
        fswitch = not fswitch
    elseif fakelagMode[state]:get()==3 then
        fakelagValue=trueRandom(fakelagmin[state]:get(),fakelagmax[state]:get())
    end
    menuRef['yawAdd']:set(yawAddValue)
    menuRef['fakeLag']:set(fakelagValue)
end

local uiUpdate = function ()
    change_tag_fn("0day-yaw.lua")
    if not menu.is_open() then
        return
    end
    local selectD = aimantin:get_item_name(aimantin:get())
    for k, v in pairs(jitterMode) do
        if k==selectD then
            if v:get()~=1 then
                jitterAdd[k]:set_visible(true)
                jitterType[k]:set_visible(true)
            else
                jitterAdd[k]:set_visible(false)
                jitterType[k]:set_visible(false)
            end
        end 
    end
    for k, v in pairs(yawAddMode) do
        if k==selectD then
            if v:get()~=1 then
                jitter[k]:set_visible(true)
            else
                jitter[k]:set_visible(false)
            end
        end 
    end
    for k, v in pairs(fakelagMode) do
        if k==selectD then
            if v:get()~=1 then
                fakelag[k]:set_visible(true)
                fakelagmin[k]:set_visible(false)
                fakelagmax[k]:set_visible(false)
            else
                fakelag[k]:set_visible(false)
                fakelagmin[k]:set_visible(true)
                fakelagmax[k]:set_visible(true)
            end
        end 
    end
end
print("github https://github.com/YouRan4/primordial-script")
print("github https://github.com/YouRan4/primordial-script")
print("github https://github.com/YouRan4/primordial-script")
print("github https://github.com/YouRan4/primordial-script")
print("github https://github.com/YouRan4/primordial-script")
callbacks.add(e_callbacks.PAINT, uiUpdate)
callbacks.add(e_callbacks.ANTIAIM,Animationdestruction)
