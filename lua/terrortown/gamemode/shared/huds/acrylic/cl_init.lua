local surface = surface

-- Fonts
surface.CreateAdvancedFont("AcrylicMSTACKImageMsg", {font = "Octin Sports RG", size = 20, weight = 600})
surface.CreateAdvancedFont("AcrylicMSTACKMsg", {font = "Octin Sports RG", size = 14, weight = 600})
surface.CreateAdvancedFont("AcrylicRole", {font = "Octin Sports RG", size = 28, weight = 600})
surface.CreateAdvancedFont("AcrylicBar", {font = "Octin Sports RG", size = 20, weight = 300})
surface.CreateAdvancedFont("AcrylicWep", {font = "Octin Sports RG", size = 21, weight = 900})
surface.CreateAdvancedFont("AcrylicWepNum", {font = "Octin Sports RG", size = 21, weight = 600})
surface.CreateAdvancedFont("AcrylicItemInfo", {font = "Octin Sports RG", size = 14, weight = 600})

local base = "scalable_hud"

DEFINE_BASECLASS(base)

HUD.Base = base

HUD.defaultcolor = Color(0, 0, 0, 80)
HUD.previewImage = Material("vgui/ttt/huds/acrylic/preview.png")


function HUD:Initialize()
	self:ForceElement("acrylic_playerinfo")
	self:ForceElement("bluredge_roundinfo")
	self:ForceElement("bluredge_teamindicator")
	--self:ForceElement("bluredge_miniscoreboard")
	--self:ForceElement("bluredge_wswitch")
	self:ForceElement("acrylic_drowning")
	--self:ForceElement("bluredge_mstack")
	--self:ForceElement("bluredge_sidebar")
	--self:ForceElement("bluredge_punchometer")
	--self:ForceElement("bluredge_target")
	--self:ForceElement("bluredge_pickup")

	BaseClass.Initialize(self)
end

-- Voice overriding
--include("cl_voice.lua")

-- Popup overriding
--include("cl_popup.lua")
