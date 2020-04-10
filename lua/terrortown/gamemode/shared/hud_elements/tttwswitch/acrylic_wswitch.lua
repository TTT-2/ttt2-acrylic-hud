local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

local base = "base_stacking_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	-- color defines
	local color_empty = Color(200, 20, 20, 255)
	local color_empty_dark = Color(200, 20, 20, 100)

	local element_height = 28
	local margin = 5
	local lpw = 30 -- left panel width

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 365, h = 28},
		minsize = {w = 240, h = 28}
	}

	function HUDELEMENT:PreInitialize()
		self.drawer = hudelements.GetStored("acrylic_element")
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.element_height = element_height
		self.margin = margin
		self.lpw = lpw

		WSWITCH:UpdateWeaponCache()

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = ScrW() - (self.size.w + self.margin * 2), y = ScrH() - self.margin}

		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		self.element_height = math.Round(element_height * self.scale)
		self.margin = math.Round(margin * self.scale)
		self.lpw = math.Round(lpw * self.scale)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:DrawBarBg(x, y, w, h, active)
		local ply = LocalPlayer()

		local c_main = self.basecolor
		local c_tip = (active and ply:GetRoleColor() or ply:GetRoleDkColor()) or Color(100, 100, 100)

		c_tip = ColorAlpha(c_tip, self.basecolor.a)

		if active then
			c_main = util.ColorLighten(c_main, 25)
			c_tip = util.ColorLighten(c_tip, 25)
		end

		self.drawer:DrawBg(x + self.lpw + 0.5 * self.drawer.padding, y, w - self.lpw - 0.5 * self.drawer.padding, h, c_main)
		self.drawer:DrawLines(x + self.lpw + 0.5 * self.drawer.padding, y, w - self.lpw - 0.5 * self.drawer.padding, h)

		-- Draw the colour tip
		self.drawer:DrawBg(x, y, self.lpw, h, c_tip)
		self.drawer:DrawLines(x, y, self.lpw, h)

		return c_tip
	end

	function HUDELEMENT:DrawWeapon(x, y, active, wep, tip_color)
		if not IsValid(wep) or not IsValid(wep.Owner) or not isfunction(wep.Owner.GetAmmoCount) then
			return false
		end

		--define colors
		local text_color = util.GetDefaultColor(self.basecolor)
		text_color = active and text_color or Color(text_color.r, text_color.g, text_color.b, text_color.r > 128 and 100 or 180)

		local number_color = util.GetDefaultColor(tip_color)
		number_color = active and number_color or Color(number_color.r, number_color.g, number_color.b, number_color.r > 128 and 100 or 180)

		local empty_color = active and color_empty or color_empty_dark

		local name = TryTranslation(wep:GetPrintName() or wep.PrintName or "...")
		local cl1, am1 = wep:Clip1(), (wep.Ammo1 and wep:Ammo1() or false)
		local ammo = false

		-- Clip1 will be -1 if a melee weapon
		-- Ammo1 will be false if weapon has no owner (was just dropped)
		if cl1 ~= -1 and am1 ~= false then
			ammo = Format("%i + %02i", cl1, am1)
		end

		-- Slot
		draw.AdvancedText(MakeKindValid(wep.Kind), "AcrylicWepNum", x + self.lpw * 0.5, y + self.element_height * 0.5, number_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		-- Name
		draw.AdvancedText(string.upper(name), "AcrylicWep", x + self.lpw + 1.5 * self.drawer.padding, y + self.element_height * 0.5, text_color, nil, TEXT_ALIGN_CENTER, true, self.scale)

		if ammo then
			local col = (wep:Clip1() == 0 and wep:Ammo1() == 0) and empty_color or text_color

			-- Ammo
			draw.AdvancedText(tostring(ammo), "AcrylicWep", x + self.size.w - self.drawer.padding, y + self.element_height * 0.5, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, true, self.scale)
		end

		return true
	end

	function HUDELEMENT:ShouldDraw()
		return HUDEditor.IsEditing or WSWITCH.Show
	end

	function HUDELEMENT:Draw()
		local weaponList = {}
		local weps = WSWITCH.WeaponCache
		local count = table.Count(weps)

		for i = 1, count do
			table.insert(weaponList, {h = self.element_height})
		end

		self:SetElements(weaponList)
		self:SetElementMargin(self.margin)

		BaseClass.Draw(self)
	end

	function HUDELEMENT:DrawElement(i, x, y, w, h)
		local active = WSWITCH.Selected == i

		local tipCol = self:DrawBarBg(x, y, w, h, active)

		if not self:DrawWeapon(x, y, active, WSWITCH.WeaponCache[i], tipCol) then
			WSWITCH:UpdateWeaponCache()

			return
		end
	end
end
