local base = "acrylic_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local TryT = LANG.TryTranslation

	local row = 40
	local gap = 5

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 275, h = 130},
		minsize = {w = 225, h = 130}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.sri_text_width_padding = sri_text_width_padding
		--self.secondaryRoleInformationFunc = nil

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, true
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = 10 * self.scale, y = ScrH() - (10 * self.scale + self.size.h)}

		return const_defaults
	end

	function HUDELEMENT:PerformLayout()
		local defaults = self:GetDefaults()

		self.basecolor = self:GetHUDBasecolor()
		self.scale = math.min(self.size.w / defaults.minsize.w, self.size.h / defaults.minsize.h)
		self.row = math.Round(row * self.scale, 0)
		self.gap = math.Round(gap * self.scale, 0)

		BaseClass.PerformLayout(self)
	end

	-- Returns player's ammo information
	function HUDELEMENT:GetAmmo(ply)
		local weap = ply:GetActiveWeapon()

		if not weap or not ply:Alive() then
			return - 1
		end

		local ammo_inv = weap.Ammo1 and weap:Ammo1() or 0
		local ammo_clip = weap:Clip1() or 0
		local ammo_max = weap.Primary.ClipSize or 0

		return ammo_clip, ammo_max, ammo_inv
	end

	--[[
		This function expects to receive a function as a parameter which later returns a table with the following keys: { text: "", color: Color }
		The function should also take care of managing the visibility by returning nil to tell the UI that nothing should be displayed
	]]--
	function HUDELEMENT:SetSecondaryRoleInfoFunction(func)
		if func and isfunction(func) then
			self.secondaryRoleInformationFunc = func
		end
	end

	function HUDELEMENT:DrawRoleText(text, x, y, activeAndAlive)
		surface.SetFont("AcrylicRole")

		local role_text_width = surface.GetTextSize(string.upper(text)) * self.scale
		local role_scale_multiplier = (self.size.w - self.row - 2 * self.padding) / role_text_width

		if activeAndAlive and isfunction(self.secondaryRoleInformationFunc) then
			local secInfoTbl = self.secondaryRoleInformationFunc()

			if secInfoTbl and secInfoTbl.text then
				surface.SetFont("AcrylicBar")

				local sri_text_width = surface.GetTextSize(string.upper(secInfoTbl.text)) * self.scale
				local sri_width = sri_text_width + self.pad * 2

				role_scale_multiplier = (self.size.w - self.row - 4 * self.pad - sri_width) / role_text_width
			end
		end

		role_scale_multiplier = math.Clamp(role_scale_multiplier, 0.55, 0.85) * self.scale

		draw.AdvancedText(text, "AcrylicRole", x, y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, role_scale_multiplier)
	end

	local watching_icon = Material("vgui/ttt/watching_icon")

	local icon_armor = Material("vgui/ttt/hud_armor")
	local icon_armor_rei = Material("vgui/ttt/hud_armor_reinforced")
	local icon_ammo = Material("vgui/ttt/hud_ammo")
	local icon_health = Material("vgui/ttt/hud_health")
	local icon_sprint = Material("vgui/ttt/hud_sprint")

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local calive = client:Alive() and client:IsTerror()
		local cactive = client:IsActive()

		local rd = client:GetSubRoleData()

		local c, text

		if cactive then
			c = client:GetRoleColor()
			text = TryT(rd.name)
		else
			c = self.basecolor
			text = TryT(self.roundstate_string[GAMEMODE.round_state])
		end

		-- player informations
		if calive then
			-- precalc sizes
			local role_x = self.pos.x
			local role_y = self.pos.y
			local role_w = self.size.w
			local role_h = self.row

			local health_x = self.pos.x
			local health_y = self.pos.y + self.row + self.gap
			local health_w = (self.size.w - self.gap) * 0.5
			local health_h = self.row

			local armor_x = self.pos.x + health_w + self.gap
			local armor_y = self.pos.y + self.row + self.gap
			local armor_w = (self.size.w - self.gap) * 0.5
			local armor_h = self.row

			local ammo_x = self.pos.x
			local ammo_y = self.pos.y + 2 * (self.row + self.gap)
			local ammo_w = (self.size.w - self.gap) * 0.5
			local ammo_h = self.row

			-- TODO dependant on GetGlobalBool("ttt2_sprint_enabled", true)
			local sprint_x = self.pos.x + ammo_w + self.gap
			local sprint_y = self.pos.y + 2 * (self.row + self.gap)
			local sprint_w = (self.size.w - self.gap) * 0.5
			local sprint_h = self.row

			-- draw role box
			self:DrawBg(role_x, role_y, role_w, role_h, {r = c.r, g = c.g, b = c.b, a = self.basecolor.a})
			self:DrawLines(role_x, role_y, role_w, role_h)

			local img_size = role_h - 2 * self.gap

			if rd and cactive then
				draw.FilteredShadowedTexture(role_x + self.gap, role_y + self.gap, img_size, img_size, rd.iconMaterial, 255, COLOR_WHITE, self.scale)
			end

			if rd then
				self:DrawRoleText(text, role_x + (cactive and role_h or 2 * self.gap), role_y + 0.5 * role_h, calive and cactive)
			end

			-- icon size for all small icons
			local icon_size = 16 * self.scale
			local icon_pad = 0.5 * (self.row - icon_size)

			-- draw health box
			self:DrawBg(health_x, health_y, health_w, health_h, self.basecolor)
			self:DrawLines(health_x, health_y, health_w, health_h)

			draw.FilteredShadowedTexture(health_x + icon_pad, health_y + icon_pad, icon_size, icon_size, icon_health, 255, COLOR_WHITE, self.scale)
			draw.AdvancedText(math.max(0, client:Health()) .. " / " .. math.max(0, client:GetMaxHealth()), "AcrylicBar", health_x + health_h, health_y + 0.5 * health_h, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)

			-- draw armor box
			self:DrawBg(armor_x, armor_y, armor_w, armor_h, self.basecolor)
			self:DrawLines(armor_x, armor_y, armor_w, armor_h)

			local icon_mat = client:ArmorIsReinforced() and icon_armor_rei or icon_armor

			draw.FilteredShadowedTexture(armor_x + icon_pad, armor_y + icon_pad, icon_size, icon_size, icon_mat, 255, COLOR_WHITE, self.scale)
			draw.AdvancedText(client:GetArmor() .. " / " .. client:GetMaxArmor(), "AcrylicBar", armor_x + armor_h, armor_y + 0.5 * armor_h, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)

			-- draw ammo box
			self:DrawBg(ammo_x, ammo_y, ammo_w, ammo_h, self.basecolor)
			self:DrawLines(ammo_x, ammo_y, ammo_w, ammo_h)

			local ammo_string = "---"

			if client:GetActiveWeapon().Primary then
				local ammo_clip, _, ammo_inv = self:GetAmmo(client)

				if ammo_clip ~= -1 then
					ammo_string = string.format("%i + %02i", ammo_clip, ammo_inv)
				end
			end

			draw.FilteredShadowedTexture(ammo_x + icon_pad, ammo_y + icon_pad, icon_size, icon_size, icon_ammo, 255, COLOR_WHITE, self.scale)
			draw.AdvancedText(ammo_string, "AcrylicBar", ammo_x + ammo_h, ammo_y + 0.5 * ammo_h, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)

			-- draw sprint box
			self:DrawBg(sprint_x, sprint_y, sprint_w, sprint_h, self.basecolor)
			self:DrawLines(sprint_x, sprint_y, sprint_w, sprint_h)

			draw.FilteredShadowedTexture(sprint_x + icon_pad, sprint_y + icon_pad, icon_size, icon_size, icon_sprint, 255, COLOR_WHITE, self.scale)
			draw.AdvancedText(string.format("%03i", client.sprintProgress * 100), "AcrylicBar", sprint_x + sprint_h, sprint_y + 0.5 * sprint_h, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)
		else
			-- precalc sizes
			local box_x = self.pos.x
			local box_y = self.pos.y + self.size.w - self.row
			local box_w = self.size.w
			local box_h = self.row

			self:DrawBg(box_x, box_y, box_w, box_h, self.basecolor)
			self:DrawLines(box_x, box_y, box_w, box_h)
		end
	end
end
