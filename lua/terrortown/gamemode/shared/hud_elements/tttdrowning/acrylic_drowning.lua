local base = "acrylic_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 90, h = 40},
		minsize = {w = 75, h = 40}
	}

	function HUDELEMENT:Initialize()
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = ScrH() - self.padding - self.size.h}

		return const_defaults
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDEditor.IsEditing or client.drowningProgress and client:Alive() and client.drowningProgress ~= -1
	end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.PerformLayout(self)
	end

	local icon_drowning = Material("vgui/ttt/hud_drowning")

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h

		-- icon size for all small icons
		local icon_size = 16 * self.scale
		local icon_pad = 0.5 * (h - icon_size)

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)
		self:DrawLines(x, y, w, h)

		draw.FilteredShadowedTexture(x + icon_pad, y + icon_pad, icon_size, icon_size, icon_drowning, 255, COLOR_WHITE, self.scale)
		draw.AdvancedText(string.format("%03i", (client.drowningProgress or 1) * 100) .. "%", "AcrylicBar", x + h, y + 0.5 * h, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)
	end
end
