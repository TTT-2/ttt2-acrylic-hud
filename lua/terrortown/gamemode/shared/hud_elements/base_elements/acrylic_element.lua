local base = "dynamic_hud_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local padding = 10

	HUDELEMENT.padding = padding
	HUDELEMENT.blurMaterial = Material("pp/blurscreen")

	--HUDELEMENT.darkOverlayColor = Color(0, 0, 0, 100)
	--HUDELEMENT.healthBarColor = Color(234, 41, 41)
	--HUDELEMENT.ammoBarColor = Color(238, 151, 0)
	--HUDELEMENT.extraBarColor = Color(36, 154, 198)
	HUDELEMENT.outlineColor = Color(245, 250, 255, 80)
	HUDELEMENT.edgeColor = Color(245, 250, 255, 150)

	function HUDELEMENT:DrawBg(x, y, w, h, color)
		local X, Y = 0, 0

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(self.blurMaterial)

		for i = 1, 2 do
			self.blurMaterial:SetFloat("$blur", i * 2)
			self.blurMaterial:Recompute()

			render.UpdateScreenEffectTexture()

			render.SetScissorRect(x, y, x + w, y + h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
			render.SetScissorRect(0, 0, 0, 0, false)
		end

		DrawHUDElementBg(x, y, w, h, color)
	end

	function HUDELEMENT:DrawSimpleOutline(x, y, w, h)
		draw.OutlinedBox(x, y, w, h, 1, self.outlineColor)
	end

	function HUDELEMENT:DrawLines(x, y, w, h)
		self:DrawSimpleOutline(x, y, w, h)

		local edgesize = 8
		local edgewidth = 2

		-- top left corner
		DrawHUDElementBg(x, y, edgesize, edgewidth, self.edgeColor)
		DrawHUDElementBg(x, y + edgewidth, edgewidth, edgesize - edgewidth, self.edgeColor)

		-- top right corner
		DrawHUDElementBg(x + w - edgesize, y, edgesize, edgewidth, self.edgeColor)
		DrawHUDElementBg(x + w - edgewidth, y + edgewidth, edgewidth, edgesize - edgewidth, self.edgeColor)

		-- bottom left corner
		DrawHUDElementBg(x, y + h - edgewidth, edgesize, edgewidth, self.edgeColor)
		DrawHUDElementBg(x, y + h - edgesize, edgewidth, edgesize - edgewidth, self.edgeColor)

		-- bottom right corner
		DrawHUDElementBg(x + w - edgesize, y + h - edgewidth, edgesize, edgewidth, self.edgeColor)
		DrawHUDElementBg(x + w - edgewidth, y + h - edgesize, edgewidth, edgesize - edgewidth, self.edgeColor)
	end

	function HUDELEMENT:PerformLayout()
		self.padding = math.Round(padding * self:GetHUDScale(), 0)

		BaseClass.PerformLayout(self)
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}
end