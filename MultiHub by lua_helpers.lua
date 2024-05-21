script_author("t.me/lua_helpers")
script_name("MultiHub")
script_version("Alpha")

local tag = "[MultiHub]: "

local ffi = require("ffi")
local imgui = require("mimgui")
local encoding = require("encoding")
encoding.default = "CP1251"
local u8 = encoding.UTF8
local fa = require("fAwesome6")
local requests = require("requests")
local sampev = require("samp.events")

local inicfg = require("inicfg")
local ini = inicfg.load({
	cfg =
	    {
	    	theme = 1,
            checkUpdates = false
    	}
}, thisScript().name..".ini")

local tab = 1

local colorList = {u8("Красная"), u8("Зелёная"),u8("Синяя"), u8("Темная"), u8("Фиолетовая"), u8("Фиолетовая #2"), u8("Красная #2")}
local colorListNumber = imgui.new.int(ini.cfg.theme)
local colorListBuffer = imgui.new["const char*"][#colorList](colorList)

local WinState = imgui.new.bool(false)

local checkUpdates = imgui.new.bool(ini.cfg.checkUpdates)

imgui.OnFrame(function()
	return WinState[0]
end, function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(thisScript().name.." by "..fa("paper_plane").." lua_helpers", WinState, imgui.WindowFlags.NoResize)
		if imgui.Button(fa("user")..u8(" Основное"), imgui.ImVec2(170, 60)) then tab = 1 end
		if imgui.Button(fa("gear")..u8(" Настройки"), imgui.ImVec2(170, 60)) then tab = 2 end
		if imgui.Button(fa("info")..u8(" Информация"), imgui.ImVec2(170, 60)) then tab = 3 end
		imgui.SetCursorPos(imgui.ImVec2(175, 33))
		if imgui.BeginChild("main", imgui.ImVec2(700, 250), true) then
			if tab == 1 then
			elseif tab == 2 then
                if imgui.Checkbox(u8("Проверять обновления"), checkUpdates) then
                    ini.cfg.checkUpdates = checkUpdates[0]
                    cfg_save()
                end
				if imgui.Combo(u8("Темы"), colorListNumber, colorListBuffer, #colorList) then
					theme[colorListNumber[0]+1].change()
					ini.cfg.theme = colorListNumber[0]
					cfg_save()
				end
				if imgui.Button(fa("rotate_right") .. u8(" Перезагрузить")) then thisScript().reload() end
				if imgui.Button(fa("trash") .. u8(" Выгрузить")) then thisScript().unload() end
			elseif tab == 3 then
				imgui.Text(u8("Автор(ы)"))
				imgui.TextWrapped(u8("Для перехода нажмите на текст"))
				imgui.TextWrapped(u8("t.me/beavers_best - Разработчик"))
				if imgui.IsItemClicked() then openLink("https://t.me/beavers_best") end
				imgui.TextWrapped(u8("t.me/lua_helpers - Канал разработчика"))
				if imgui.IsItemClicked() then openLink("https://t.me/lua_helpers") end
				imgui.TextWrapped(u8("Сделано при поддержке Arizona Fun"))
				if imgui.IsItemClicked() then openLink("https://rb.gy/cikr1u") end
			end
		imgui.EndChild()
		end
	imgui.End()
end)

function cfg_save()
	inicfg.save(ini, thisScript().name..".ini")
end


function main()
	sampRegisterChatCommand("MultiHub", function()
		WinState[0] = not WinState[0]
	end)
	wait(-1)
end

function sampev.onSendSpawn()
    if ini.cfg.checkUpdates then
        if requests.get("https://raw.githubusercontent.com/DarkyDTM/MultiHub/main/version.txt").text ~= thisScript().version then
            sampAddChatMessage(tag.."Доступно обновление! Вы можете обновиться через меню скрипта", -1)
        end
    end
end

function downloadToFile(url, path)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    http.request({ method = "GET", url = url, sink = ltn12.sink.file(io.open(path, "wb")) })
end

ffi.cdef[[void _Z12AND_OpenLinkPKc(const char* link);]]

function openLink(link)
	local gta = ffi.load("GTASA")
	gta._Z12AND_OpenLinkPKc(link)
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	local config = imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
	imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85("duotune"), 17, config, iconRanges)
	decor()
	theme[colorListNumber[0]+1].change()
end)


theme = {
	{
		change = function()
			local ImVec4 = imgui.ImVec4
			imgui.SwitchContext()
			imgui.GetStyle().Colors[imgui.Col.Text]				   = ImVec4(1.00, 1.00, 1.00, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = ImVec4(0.50, 0.50, 0.50, 1.00)
			imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.06, 0.06, 0.06, 0.94)
			imgui.GetStyle().Colors[imgui.Col.ChildBg]				= ImVec4(1.00, 1.00, 1.00, 0.00)
			imgui.GetStyle().Colors[imgui.Col.PopupBg]				= ImVec4(0.08, 0.08, 0.08, 0.94)
			imgui.GetStyle().Colors[imgui.Col.Border]				 = ImVec4(0.43, 0.43, 0.50, 0.50)
			imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = ImVec4(0.00, 0.00, 0.00, 0.00)
			imgui.GetStyle().Colors[imgui.Col.FrameBg]				= ImVec4(0.48, 0.16, 0.16, 0.54)
			imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = ImVec4(0.98, 0.26, 0.26, 0.40)
			imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = ImVec4(0.98, 0.26, 0.26, 0.67)
			imgui.GetStyle().Colors[imgui.Col.TitleBg]				= ImVec4(0.04, 0.04, 0.04, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = ImVec4(0.48, 0.16, 0.16, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = ImVec4(0.00, 0.00, 0.00, 0.51)
			imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = ImVec4(0.14, 0.14, 0.14, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= ImVec4(0.02, 0.02, 0.02, 0.53)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = ImVec4(0.31, 0.31, 0.31, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= ImVec4(0.51, 0.51, 0.51, 1.00)
			imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = ImVec4(0.88, 0.26, 0.24, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Button]				 = ImVec4(0.98, 0.26, 0.26, 0.40)
			imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = ImVec4(0.98, 0.06, 0.06, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Header]				 = ImVec4(0.98, 0.26, 0.26, 0.31)
			imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = ImVec4(0.98, 0.26, 0.26, 0.80)
			imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Separator]			  = ImVec4(0.43, 0.43, 0.50, 0.50)
			imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = ImVec4(0.75, 0.10, 0.10, 0.78)
			imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= ImVec4(0.75, 0.10, 0.10, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = ImVec4(0.98, 0.26, 0.26, 0.25)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = ImVec4(0.98, 0.26, 0.26, 0.67)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = ImVec4(0.98, 0.26, 0.26, 0.95)
			imgui.GetStyle().Colors[imgui.Col.Tab]					= ImVec4(0.98, 0.26, 0.26, 0.40)
			imgui.GetStyle().Colors[imgui.Col.TabHovered]			 = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TabActive]			  = ImVec4(0.98, 0.06, 0.06, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TabUnfocused]		   = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]	 = ImVec4(0.98, 0.26, 0.26, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = ImVec4(0.61, 0.61, 0.61, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = ImVec4(1.00, 0.43, 0.35, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = ImVec4(0.90, 0.70, 0.00, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = ImVec4(0.98, 0.26, 0.26, 0.35)
		end
	},
	{
		change = function()
			local ImVec4 = imgui.ImVec4
			imgui.SwitchContext()
			imgui.GetStyle().Colors[imgui.Col.Text]				   = ImVec4(0.90, 0.90, 0.90, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = ImVec4(0.60, 0.60, 0.60, 1.00)
			imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.08, 0.08, 0.08, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ChildBg]				= ImVec4(0.10, 0.10, 0.10, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PopupBg]				= ImVec4(0.08, 0.08, 0.08, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Border]				 = ImVec4(0.70, 0.70, 0.70, 0.40)
			imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = ImVec4(0.00, 0.00, 0.00, 0.00)
			imgui.GetStyle().Colors[imgui.Col.FrameBg]				= ImVec4(0.15, 0.15, 0.15, 1.00)
			imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = ImVec4(0.19, 0.19, 0.19, 0.71)
			imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = ImVec4(0.34, 0.34, 0.34, 0.79)
			imgui.GetStyle().Colors[imgui.Col.TitleBg]				= ImVec4(0.00, 0.69, 0.33, 0.80)
			imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = ImVec4(0.00, 0.74, 0.36, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = ImVec4(0.00, 0.69, 0.33, 0.50)
			imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = ImVec4(0.00, 0.80, 0.38, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= ImVec4(0.16, 0.16, 0.16, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= ImVec4(0.00, 1.00, 0.48, 1.00)
			imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = ImVec4(0.00, 0.77, 0.37, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Button]				 = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = ImVec4(0.00, 0.82, 0.39, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = ImVec4(0.00, 0.87, 0.42, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Header]				 = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = ImVec4(0.00, 0.76, 0.37, 0.57)
			imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = ImVec4(0.00, 0.88, 0.42, 0.89)
			imgui.GetStyle().Colors[imgui.Col.Separator]			  = ImVec4(1.00, 1.00, 1.00, 0.40)
			imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = ImVec4(1.00, 1.00, 1.00, 0.60)
			imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= ImVec4(1.00, 1.00, 1.00, 0.80)
			imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = ImVec4(0.00, 0.76, 0.37, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = ImVec4(0.00, 0.86, 0.41, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = ImVec4(0.00, 0.74, 0.36, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = ImVec4(0.00, 0.69, 0.33, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = ImVec4(0.00, 0.69, 0.33, 0.72)
		end
	},
	{
		change = function()
			local ImVec4 = imgui.ImVec4
			imgui.SwitchContext()
			imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.08, 0.08, 0.08, 1.00)
			imgui.GetStyle().Colors[imgui.Col.FrameBg]				= ImVec4(0.16, 0.29, 0.48, 0.54)
			imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = ImVec4(0.26, 0.59, 0.98, 0.40)
			imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = ImVec4(0.26, 0.59, 0.98, 0.67)
			imgui.GetStyle().Colors[imgui.Col.TitleBg]				= ImVec4(0.04, 0.04, 0.04, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = ImVec4(0.16, 0.29, 0.48, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = ImVec4(0.00, 0.00, 0.00, 0.51)
			imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = ImVec4(0.26, 0.59, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = ImVec4(0.24, 0.52, 0.88, 1.00)
			imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = ImVec4(0.26, 0.59, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Button]				 = ImVec4(0.26, 0.59, 0.98, 0.40)
			imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = ImVec4(0.26, 0.59, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = ImVec4(0.06, 0.53, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Header]				 = ImVec4(0.26, 0.59, 0.98, 0.31)
			imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = ImVec4(0.26, 0.59, 0.98, 0.80)
			imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = ImVec4(0.26, 0.59, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.Separator]			  = ImVec4(0.43, 0.43, 0.50, 0.50)
			imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = ImVec4(0.26, 0.59, 0.98, 0.78)
			imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= ImVec4(0.26, 0.59, 0.98, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = ImVec4(0.26, 0.59, 0.98, 0.25)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = ImVec4(0.26, 0.59, 0.98, 0.67)
			imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = ImVec4(0.26, 0.59, 0.98, 0.95)
			imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = ImVec4(0.26, 0.59, 0.98, 0.35)
			imgui.GetStyle().Colors[imgui.Col.Text]				   = ImVec4(1.00, 1.00, 1.00, 1.00)
			imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = ImVec4(0.50, 0.50, 0.50, 1.00)
			imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.06, 0.53, 0.98, 0.70)
			imgui.GetStyle().Colors[imgui.Col.ChildBg]				= ImVec4(0.10, 0.10, 0.10, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PopupBg]				= ImVec4(0.06, 0.53, 0.98, 0.70)
			imgui.GetStyle().Colors[imgui.Col.Border]				 = ImVec4(0.43, 0.43, 0.50, 0.50)
			imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = ImVec4(0.00, 0.00, 0.00, 0.00)
			imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = ImVec4(0.14, 0.14, 0.14, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= ImVec4(0.02, 0.02, 0.02, 0.53)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = ImVec4(0.31, 0.31, 0.31, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
			imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= ImVec4(0.51, 0.51, 0.51, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = ImVec4(0.61, 0.61, 0.61, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = ImVec4(1.00, 0.43, 0.35, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = ImVec4(0.90, 0.70, 0.00, 1.00)
			imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
		end
	},
{
		change = function()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10

	--==[ BORDER ]==--
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1

	--==[ ROUNDING ]==--
	imgui.GetStyle().WindowRounding = 5
	imgui.GetStyle().ChildRounding = 5
	imgui.GetStyle().FrameRounding = 5
	imgui.GetStyle().PopupRounding = 5
	imgui.GetStyle().ScrollbarRounding = 5
	imgui.GetStyle().GrabRounding = 5
	imgui.GetStyle().TabRounding = 5

	--==[ ALIGN ]==--
	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	
	--==[ COLORS ]==--
	imgui.GetStyle().Colors[imgui.Col.Text]				   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ChildBg]				= imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg]				= imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Border]				 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg]				= imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg]				= imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Button]				 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header]				 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Separator]			  = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	imgui.GetStyle().Colors[imgui.Col.Tab]					= imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabHovered]			 = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabActive]			  = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]		   = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]	 = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	imgui.GetStyle().Colors[imgui.Col.DragDropTarget]		 = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	imgui.GetStyle().Colors[imgui.Col.NavHighlight]		   = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]	  = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]	   = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end
},

{
		change = function()
			local ImVec4 = imgui.ImVec4
	imgui.GetStyle().FramePadding = imgui.ImVec2(3.5, 3.5)
	imgui.GetStyle().FrameRounding = 3
	imgui.GetStyle().ChildRounding = 2
	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().WindowRounding = 2
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5.0, 4.0)
	imgui.GetStyle().ScrollbarSize = 13.0
	imgui.GetStyle().ScrollbarRounding = 0
	imgui.GetStyle().GrabMinSize = 8.0
	imgui.GetStyle().GrabRounding = 1.0
	imgui.GetStyle().WindowPadding = imgui.ImVec2(4.0, 4.0)
	imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)

	imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.14, 0.12, 0.16, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.30, 0.20, 0.39, 0.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.05, 0.05, 0.10, 0.90)
	imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.89, 0.85, 0.92, 0.30)
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.30, 0.20, 0.39, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.68)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.45)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.41, 0.19, 0.63, 0.35)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.30, 0.20, 0.39, 0.57)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.30, 0.20, 0.39, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.31)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.56, 0.61, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.24)
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.41, 0.19, 0.63, 0.44)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.64, 0.33, 0.94, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.41, 0.19, 0.63, 0.76)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.41, 0.19, 0.63, 0.20)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.43)
end
},

{
		change = function()
			local ImVec4 = imgui.ImVec4
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	imgui.GetStyle().WindowPadding = imgui.ImVec2(4, 4)
	imgui.GetStyle().FramePadding = imgui.ImVec2(4, 3)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(8, 4)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(4, 4)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)

	imgui.GetStyle().IndentSpacing = 21
	imgui.GetStyle().ScrollbarSize = 14
	imgui.GetStyle().GrabMinSize = 10

	imgui.GetStyle().WindowBorderSize = 0
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 0

	imgui.GetStyle().WindowRounding = 5
	imgui.GetStyle().ChildRounding = 5
	imgui.GetStyle().PopupRounding = 5
	imgui.GetStyle().FrameRounding = 5
	imgui.GetStyle().ScrollbarRounding = 2.5
	imgui.GetStyle().GrabRounding = 5
	imgui.GetStyle().TabRounding = 5

	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.50, 0.50)

	-->> Colors
	colors[clr.Text]				   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]		   = ImVec4(0.50, 0.50, 0.50, 1.00)

	colors[clr.WindowBg]			   = ImVec4(0.15, 0.16, 0.37, 1.00)
	colors[clr.ChildBg]				= ImVec4(0.17, 0.18, 0.43, 1.00)
	colors[clr.PopupBg]				= colors[clr.WindowBg]

	colors[clr.Border]				 = ImVec4(0.33, 0.34, 0.62, 1.00)
	colors[clr.BorderShadow]		   = ImVec4(0.00, 0.00, 0.00, 0.00)

	colors[clr.TitleBg]				= ImVec4(0.18, 0.20, 0.46, 1.00)
	colors[clr.TitleBgActive]		  = ImVec4(0.18, 0.20, 0.46, 1.00)
	colors[clr.TitleBgCollapsed]	   = ImVec4(0.18, 0.20, 0.46, 1.00)
	colors[clr.MenuBarBg]			  = colors[clr.ChildBg]

	colors[clr.ScrollbarBg]			= ImVec4(0.14, 0.14, 0.36, 1.00)
	colors[clr.ScrollbarGrab]		  = ImVec4(0.22, 0.22, 0.53, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.20, 0.21, 0.53, 1.00)
	colors[clr.ScrollbarGrabActive]	= ImVec4(0.25, 0.25, 0.58, 1.00)

	colors[clr.Button]				 = ImVec4(0.25, 0.25, 0.58, 1.00)
	colors[clr.ButtonHovered]		  = ImVec4(0.23, 0.23, 0.55, 1.00)
	colors[clr.ButtonActive]		   = ImVec4(0.27, 0.27, 0.62, 1.00)

	colors[clr.CheckMark]			  = ImVec4(0.39, 0.39, 0.83, 1.00)
	colors[clr.SliderGrab]			 = ImVec4(0.39, 0.39, 0.83, 1.00)
	colors[clr.SliderGrabActive]	   = ImVec4(0.48, 0.48, 0.96, 1.00)

	colors[clr.FrameBg]				= colors[clr.Button]
	colors[clr.FrameBgHovered]		 = colors[clr.ButtonHovered]
	colors[clr.FrameBgActive]		  = colors[clr.ButtonActive]

	colors[clr.Header]				 = colors[clr.Button]
	colors[clr.HeaderHovered]		  = colors[clr.ButtonHovered]
	colors[clr.HeaderActive]		   = colors[clr.ButtonActive]

	colors[clr.Separator]			  = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.SeparatorHovered]	   = colors[clr.SliderGrabActive]
	colors[clr.SeparatorActive]		= colors[clr.SliderGrabActive]

	colors[clr.ResizeGrip]			 = colors[clr.Button]
	colors[clr.ResizeGripHovered]	  = colors[clr.ButtonHovered]
	colors[clr.ResizeGripActive]	   = colors[clr.ButtonActive]

	colors[clr.Tab]					= colors[clr.Button]
	colors[clr.TabHovered]			 = colors[clr.ButtonHovered]
	colors[clr.TabActive]			  = colors[clr.ButtonActive]
	colors[clr.TabUnfocused]		   = colors[clr.Button]
	colors[clr.TabUnfocusedActive]	 = colors[clr.Button]

	colors[clr.PlotLines]			  = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]	   = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]		  = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)

	colors[clr.TextSelectedBg]		 = ImVec4(0.33, 0.33, 0.57, 1.00)
	colors[clr.DragDropTarget]		 = ImVec4(1.00, 1.00, 0.00, 0.90)

	colors[clr.NavHighlight]		   = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.NavWindowingHighlight]  = ImVec4(1.00, 1.00, 1.00, 0.70)
	colors[clr.NavWindowingDimBg]	  = ImVec4(0.80, 0.80, 0.80, 0.20)

	colors[clr.ModalWindowDimBg]	   = ImVec4(0.00, 0.00, 0.00, 0.90)
end
},

{
		change = function()
	local ImVec4 = imgui.ImVec4
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1

	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1
	imgui.GetStyle().WindowRounding = 8
	imgui.GetStyle().ChildRounding = 8
	imgui.GetStyle().FrameRounding = 8
	imgui.GetStyle().PopupRounding = 8
	imgui.GetStyle().ScrollbarRounding = 8
	imgui.GetStyle().GrabRounding = 8
	imgui.GetStyle().TabRounding = 8

	imgui.GetStyle().Colors[imgui.Col.Text]				   = ImVec4(1.00, 1.00, 1.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = ImVec4(1.00, 1.00, 1.00, 0.43);
	imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.00, 0.00, 0.00, 0.90);
	imgui.GetStyle().Colors[imgui.Col.ChildBg]				= ImVec4(1.00, 1.00, 1.00, 0.07);
	imgui.GetStyle().Colors[imgui.Col.PopupBg]				= ImVec4(0.00, 0.00, 0.00, 0.94);
	imgui.GetStyle().Colors[imgui.Col.Border]				 = ImVec4(1.00, 1.00, 1.00, 0.00);
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = ImVec4(1.00, 0.00, 0.00, 0.32);
	imgui.GetStyle().Colors[imgui.Col.FrameBg]				= ImVec4(1.00, 1.00, 1.00, 0.09);
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = ImVec4(1.00, 1.00, 1.00, 0.17);
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = ImVec4(1.00, 1.00, 1.00, 0.26);
	imgui.GetStyle().Colors[imgui.Col.TitleBg]				= ImVec4(0.19, 0.00, 0.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = ImVec4(0.46, 0.00, 0.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = ImVec4(0.20, 0.00, 0.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = ImVec4(0.14, 0.03, 0.03, 1.00);
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= ImVec4(0.19, 0.00, 0.00, 0.53);
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = ImVec4(1.00, 1.00, 1.00, 0.11);
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.24);
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= ImVec4(1.00, 1.00, 1.00, 0.35);
	imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = ImVec4(1.00, 1.00, 1.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = ImVec4(1.00, 0.00, 0.00, 0.34);
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = ImVec4(1.00, 0.00, 0.00, 0.51);
	imgui.GetStyle().Colors[imgui.Col.Button]				 = ImVec4(1.00, 0.00, 0.00, 0.19);
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = ImVec4(1.00, 0.00, 0.00, 0.31);
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = ImVec4(1.00, 0.00, 0.00, 0.46);
	imgui.GetStyle().Colors[imgui.Col.Header]				 = ImVec4(1.00, 0.00, 0.00, 0.19);
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = ImVec4(1.00, 0.00, 0.00, 0.30);
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = ImVec4(1.00, 0.00, 0.00, 0.50);
	imgui.GetStyle().Colors[imgui.Col.Separator]			  = ImVec4(1.00, 0.00, 0.00, 0.41);
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = ImVec4(1.00, 1.00, 1.00, 0.78);
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= ImVec4(1.00, 1.00, 1.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = ImVec4(0.19, 0.00, 0.00, 0.53);
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = ImVec4(0.43, 0.00, 0.00, 0.75);
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = ImVec4(0.53, 0.00, 0.00, 0.95);
	imgui.GetStyle().Colors[imgui.Col.Tab]					= ImVec4(1.00, 0.00, 0.00, 0.27);
	imgui.GetStyle().Colors[imgui.Col.TabHovered]			 = ImVec4(1.00, 0.00, 0.00, 0.48);
	imgui.GetStyle().Colors[imgui.Col.TabActive]			  = ImVec4(1.00, 0.00, 0.00, 0.60);
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]		   = ImVec4(1.00, 0.00, 0.00, 0.27);
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]	 = ImVec4(1.00, 0.00, 0.00, 0.54);
	imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = ImVec4(0.61, 0.61, 0.61, 1.00);
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = ImVec4(1.00, 0.43, 0.35, 1.00);
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = ImVec4(0.90, 0.70, 0.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00);
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = ImVec4(1.00, 1.00, 1.00, 0.35);
	imgui.GetStyle().Colors[imgui.Col.DragDropTarget]		 = ImVec4(1.00, 1.00, 0.00, 0.90);
	imgui.GetStyle().Colors[imgui.Col.NavHighlight]		   = ImVec4(0.26, 0.59, 0.98, 1.00);
	imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = ImVec4(1.00, 1.00, 1.00, 0.70);
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]	  = ImVec4(0.80, 0.80, 0.80, 0.20);
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]	   = ImVec4(0.80, 0.80, 0.80, 0.35);
end
}
}

function decor()
	imgui.SwitchContext()
	local ImVec4 = imgui.ImVec4
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1
	imgui.GetStyle().WindowRounding = 8
	imgui.GetStyle().ChildRounding = 8
	imgui.GetStyle().FrameRounding = 8
	imgui.GetStyle().PopupRounding = 8
	imgui.GetStyle().ScrollbarRounding = 8
	imgui.GetStyle().GrabRounding = 8
	imgui.GetStyle().TabRounding = 8
end
