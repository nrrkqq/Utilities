--!nolint UnknownGlobal
--!nocheck

local RunService = game:GetService("RunService")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nrrkqq/Utopia/refs/heads/main/Utopia.lua"))()

local Green = Color3.fromRGB(198, 255, 198)
local Red = Color3.fromRGB(255, 85, 85)

local W, H = 400, 160

local Outline = Instance.new("Frame")
Outline.Name = "InfoWindow"
Outline.AnchorPoint = Vector2.new(0.5, 0.5)
Outline.Size = UDim2.new(0, W + 10, 0, H + 10)
Outline.Position = UDim2.new(0.5, -(W / 2 + 565 - 5), 0.5, (H / 2 + 160 + 5))
Outline.BackgroundColor3 = Library.Theme["Window Background"]
Outline.BorderSizePixel = 0
Outline.Visible = false
Outline.ZIndex = 10
Outline.Parent = Library.Holder.Instance

do
	local s = Instance.new("UIStroke", Outline)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Miter
	s.Color = Library.Theme["Border"]
end

local Liner = Instance.new("Frame", Outline)
Liner.Name = "Liner"
Liner.Size = UDim2.new(1, 0, 0, 2)
Liner.BorderSizePixel = 0
Liner.BackgroundColor3 = Library.Theme["Accent"]
Liner.ZIndex = 11

do
	local g = Instance.new("UIGradient", Liner)
	g.Rotation = 90
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125)),
	})
end

local TitleLabel = Instance.new("TextLabel", Outline)
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 18)
TitleLabel.Position = UDim2.new(0, 8, 0, 4)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextSize = 12
TitleLabel.Text = "Target Information"
TitleLabel.TextColor3 = Library.Theme["Text"]
TitleLabel.FontFace = Library.Font or Font.fromEnum(Enum.Font.SourceSans)
TitleLabel.ZIndex = 11

local Inline = Instance.new("Frame", Outline)
Inline.Name = "Inline"
Inline.Position = UDim2.new(0, 5, 0, 22)
Inline.Size = UDim2.new(1, -10, 1, -27)
Inline.BackgroundColor3 = Library.Theme["Inline"]
Inline.BorderSizePixel = 0
Inline.ZIndex = 11

do
	local s = Instance.new("UIStroke", Inline)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Miter
	s.Color = Library.Theme["Outline"]
end

local Avatar = Instance.new("ImageLabel", Inline)
Avatar.Name = "Avatar"
Avatar.Position = UDim2.new(0, 6, 0, 6)
Avatar.Size = UDim2.new(0, 80, 0, 80)
Avatar.BackgroundColor3 = Library.Theme["Element"]
Avatar.BorderSizePixel = 0
Avatar.ScaleType = Enum.ScaleType.Fit
Avatar.Image = "rbxassetid://5205790785"
Avatar.ZIndex = 12

do
	local s = Instance.new("UIStroke", Avatar)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Miter
	s.Color = Library.Theme["Border"]

	local c = Instance.new("UICorner", Avatar)
	c.CornerRadius = UDim.new(0, 2)
end

local function MakeLabel(parent, yOffset, defaultText)
	local lbl = Instance.new("TextLabel", parent)
	lbl.Size = UDim2.new(1, -98, 0, 14)
	lbl.Position = UDim2.new(0, 92, 0, yOffset)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextSize = 11
	lbl.Text = defaultText
	lbl.TextColor3 = Library.Theme["Text"]
	lbl.FontFace = Library.Font or Font.fromEnum(Enum.Font.SourceSans)
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 12
	return lbl
end

local LabelUser = MakeLabel(Inline, 6, "Username: Unknown (@DisplayName)")
local LabelID = MakeLabel(Inline, 22, "User ID: 1")
local LabelLevel = MakeLabel(Inline, 38, "Level: 1")
local LabelScore = MakeLabel(Inline, 54, "Score: 1")
local LabelDistance = MakeLabel(Inline, 70, "Distance: 0m")
local LabelTool = MakeLabel(Inline, 84, "Equipped Tool: None")

local HealthTrack = Instance.new("Frame", Inline)
HealthTrack.Name = "HealthTrack"
HealthTrack.Position = UDim2.new(0, 6, 1, -16)
HealthTrack.Size = UDim2.new(1, -12, 0, 8)
HealthTrack.BackgroundColor3 = Library.Theme["Element"]
HealthTrack.BorderSizePixel = 0
HealthTrack.ZIndex = 12

do
	local s = Instance.new("UIStroke", HealthTrack)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Miter
	s.Color = Library.Theme["Outline"]
end

local HealthFill = Instance.new("Frame", HealthTrack)
HealthFill.Name = "HealthFill"
HealthFill.Size = UDim2.new(1, 0, 1, 0)
HealthFill.BackgroundColor3 = Green
HealthFill.BorderSizePixel = 0
HealthFill.ZIndex = 13

local MaxHealth = 115

local function SetHealth(current)
	local ratio = math.clamp(current / MaxHealth, 0, 1)
	HealthFill.Size = UDim2.new(ratio, 0, 1, 0)
	HealthFill.BackgroundColor3 = Green:Lerp(Red, 1 - ratio)
end

local ShowingInfo = nil
local InformationWindow = {}

function InformationWindow:SetVisible(bool)
	Outline.Visible = bool
end

function InformationWindow:Show(Player)
	if Player == nil then
		ShowingInfo = nil
		return
	end
	if ShowingInfo == Player then
		return
	end

	self:SetVisible(true)

	local userId = Player.UserId
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size180x180
	local content, isReady = Player:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	if GetFlag("HidePlayerNames") then
		userId = 0
		Avatar.Image = "rbxassetid://5205790785"
	else
		Avatar.Image = (isReady and content) or "rbxassetid://0"
	end

	LabelUser.Text = "Username: " .. Player.Name .. " (@" .. Player.DisplayName .. ")"
	LabelID.Text = "User ID: " .. Player.UserId

	ShowingInfo = Player

	task.spawn(function()
		while ShowingInfo == Player do
			local Leaderstats = Player:FindFirstChild("leaderstats")
			if Leaderstats then
				LabelLevel.Text = "Level: " .. Leaderstats.Level.Value
				LabelScore.Text = "Score: " .. Leaderstats.Score.Value
			else
				break
			end

			local Character = Framework:GetCharacter(Player)
			local OurCharacter = Framework:GetCharacter(LocalPlayer)

			if Character then
				local Tool = Character:FindFirstChildOfClass("Tool")
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local OurHuman = OurCharacter and OurCharacter:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					if Humanoid.Health <= 0 then
						break
					end

					local Root = Humanoid.RootPart
					local OurRoot = OurHuman and OurHuman.RootPart
					if Root and OurRoot then
						local dist = (Root.Position - OurRoot.Position).Magnitude
						LabelDistance.Text = "Distance: " .. math.round(dist) .. "m"
					end

					SetHealth(Humanoid.Health)
				else
					break
				end
				LabelTool.Text = Tool and ("Equipped Tool: " .. Tool.Name) or "Equipped Tool: None"
			else
				break
			end

			RunService.RenderStepped:Wait()
		end

		if ShowingInfo == nil then
			LabelTool.Text = "Equipped Tool: None"
			LabelDistance.Text = "Distance: 0m"
			SetHealth(0)
			self:SetVisible(false)
		end

		if ShowingInfo == Player then
			LabelTool.Text = "Equipped Tool: None"
			LabelDistance.Text = "Distance: 0m"
			SetHealth(0)
			task.wait(2)
			ShowingInfo = nil
			self:SetVisible(false)
		end
	end)
end

local function ShowInformation(Player)
	InformationWindow:Show(Player)
end

return InformationWindow, ShowInformation
