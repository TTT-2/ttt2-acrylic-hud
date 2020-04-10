local blur_hud, blur_base

HUD.popupPaint = function(s, w, h)
	if not hudelements or not huds then return end

	blur_hud = blur_hud or huds.GetStored("acrylic")
	blur_base = blur_base or hudelements.GetStored("acrylic_element")

	if not blur_hud or not blur_base then return end

	if not blur_hud.basecolor then return end

	blur_base:DrawBg(0, 0, w, h, {r = s.paintColor.r, g = s.paintColor.g, b = s.paintColor.b, a = blur_hud.basecolor.a})
	blur_base:DrawLines(0, 0, w, h)
end
