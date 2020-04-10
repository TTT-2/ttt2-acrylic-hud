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
	self:ForceElement("acrylic_roundinfo")
	self:ForceElement("acrylic_teamindicator")
	self:ForceElement("acrylic_miniscoreboard")
	self:ForceElement("acrylic_wswitch")
	self:ForceElement("acrylic_drowning")
	--self:ForceElement("acrylic_mstack")
	--self:ForceElement("acrylic_sidebar")
	--self:ForceElement("acrylic_punchometer")
	--self:ForceElement("acrylic_target")
	--self:ForceElement("acrylic_pickup")

	BaseClass.Initialize(self)
end

-- Voice overriding
include("cl_voice.lua")

-- Popup overriding
include("cl_popup.lua")
