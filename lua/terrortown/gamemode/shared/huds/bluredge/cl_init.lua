local surface = surface

-- Fonts
surface.CreateAdvancedFont("BlurEdgeMSTACKImageMsg", {font = "Octin Sports RG", size = 20, weight = 600})
surface.CreateAdvancedFont("BlurEdgeMSTACKMsg", {font = "Octin Sports RG", size = 14, weight = 600})
surface.CreateAdvancedFont("BlurEdgeRole", {font = "Octin Sports RG", size = 28, weight = 600})
surface.CreateAdvancedFont("BlurEdgeBar", {font = "Octin Sports RG", size = 20, weight = 300})
surface.CreateAdvancedFont("BlurEdgeWep", {font = "Octin Sports RG", size = 21, weight = 900})
surface.CreateAdvancedFont("BlurEdgeWepNum", {font = "Octin Sports RG", size = 21, weight = 600})
surface.CreateAdvancedFont("BlurEdgeItemInfo", {font = "Octin Sports RG", size = 14, weight = 600})

local base = "scalable_hud"

DEFINE_BASECLASS(base)

HUD.Base = base

HUD.defaultcolor = Color(0, 0, 0, 80)
HUD.previewImage = Material("vgui/ttt/huds/bluredge/preview.png")


function HUD:Initialize()
	self:ForceElement("bluredge_playerinfo")
	--self:ForceElement("bluredge_roundinfo")
	--self:ForceElement("bluredge_teamindicator")
	--self:ForceElement("bluredge_miniscoreboard")
	--self:ForceElement("bluredge_wswitch")
	self:ForceElement("bluredge_drowning")
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
