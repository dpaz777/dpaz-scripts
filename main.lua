
--========================================================
-- BAD BOYS | DEXTER MORGAN V6.0 ULTIMATE
-- BLOOD EDITION | MOBILE
--========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- CONFIGURAÇÕES
local C = {
    Black = Color3.fromRGB(8,5,7),
    Dark = Color3.fromRGB(20,12,15),
    Red = Color3.fromRGB(175,0,25),
    Blood = Color3.fromRGB(100,0,15),
    White = Color3.fromRGB(245,240,240),
    Gray = Color3.fromRGB(145,135,135)
}

local ghost = false
local transparency = 0.80
local scaleValue = 1
local favorites = {}
local currentPage = "COMANDOS"

-- COMANDOS
local commands = {
    {name="MAT FAL",message="/Mat [FAL]"},
    {name="MAT AK-47",message="/Mat [AK-47]"},
    {name="MAT M4A1",message="/Mat [M4A1]"},
    {name="RENDER",message="/render"},
    {name="TRACER",message="/tracer"},
    {name="BAZUCA",message="/bazuca"},
    {name="PATRULHA",message="/patrulha"},
    {name="SOCORRO",message="/socorro"}
}

-- LIMPEZA
pcall(function()
    local old = CoreGui:FindFirstChild("BAD_BOYS_DEXTER_V6")
    if old then old:Destroy() end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BAD_BOYS_DEXTER_V6"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

local ok = pcall(function()
    gui.Parent = CoreGui
end)

if not ok or not gui.Parent then
    gui.Parent = Player:WaitForChild("PlayerGui")
end

local function corner(obj,r)
    local x = Instance.new("UICorner")
    x.CornerRadius = UDim.new(0,r)
    x.Parent = obj
end

local function stroke(obj,color,thickness)
    local x = Instance.new("UIStroke")
    x.Color = color
    x.Thickness = thickness
    x.Parent = obj
    return x
end

local function label(parent,text,size,pos,color)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Size = size
    x.Position = pos
    x.Text = text
    x.TextColor3 = color
    x.Font = Enum.Font.GothamBold
    x.TextSize = 10
    x.Parent = parent
    return x
end

local function makeButton(parent,text,size,pos,color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or C.Dark
    b.Text = text
    b.TextColor3 = C.White
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b,5)
    return b
end

-- NOTIFICAÇÕES
local function notify(message)
    local n = Instance.new("TextLabel")
    n.Size = UDim2.fromOffset(210,34)
    n.Position = UDim2.new(0.5,-105,0.12,0)
    n.BackgroundColor3 = C.Dark
    n.TextColor3 = C.White
    n.Text = message
    n.TextSize = 10
    n.Font = Enum.Font.GothamBold
    n.ZIndex = 20
    n.Parent = gui
    corner(n,7)
    stroke(n,C.Red,1.5)

    n.BackgroundTransparency = ghost and transparency or 0

    task.delay(2,function()
        if n.Parent then
            local t = TweenService:Create(
                n,TweenInfo.new(0.3),
                {TextTransparency=1,BackgroundTransparency=1}
            )
            t:Play()
            t.Completed:Connect(function()
                n:Destroy()
            end)
        end
    end)
end

-- CHAT
local function sendChat(message)
    local success,err = pcall(function()
        local channels = TextChatService:WaitForChild("TextChannels",5)
        assert(channels,"Chat não encontrado")

        local channel = channels:FindFirstChild("RBXGeneral")

        if not channel then
            for _,v in ipairs(channels:GetChildren()) do
                if v:IsA("TextChannel") then
                    channel = v
                    break
                end
            end
        end

        assert(channel,"Canal indisponível")
        channel:SendAsync(message)
    end)

    if success then
        notify("COMANDO ENVIADO")
    else
        warn("[DEXTER] "..tostring(err))
        notify("FALHA NO ENVIO")
    end
end

-- BOTÃO FLUTUANTE
local ball = makeButton(
    gui,"JK",
    UDim2.fromOffset(43,43),
    UDim2.new(0,12,0.42,0),
    C.Black
)
ball.Name = "JK_BUTTON"
ball.TextSize = 17
ball.Font = Enum.Font.GothamBlack
corner(ball,100)
stroke(ball,C.Red,2)

-- PAINEL
local panel = Instance.new("Frame")
panel.Name = "MAIN_PANEL"
panel.Size = UDim2.fromOffset(245,340)
panel.Position = UDim2.new(0.5,-122,0.5,-170)
panel.BackgroundColor3 = C.Black
panel.Visible = false
panel.ClipsDescendants = true
panel.Parent = gui
corner(panel,10)
stroke(panel,C.Red,1.5)

local uiScale = Instance.new("UIScale")
uiScale.Scale = scaleValue
uiScale.Parent = panel

-- CABEÇALHO
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,53)
header.BackgroundColor3 = C.Dark
header.Parent = panel
corner(header,9)

local logo = label(
    header,"🩸",
    UDim2.fromOffset(37,37),
    UDim2.fromOffset(7,8),
    C.White
)
logo.BackgroundColor3 = C.Blood
logo.BackgroundTransparency = 0
logo.TextSize = 19
corner(logo,7)

local title = label(
    header,"DEXTER MORGAN",
    UDim2.new(1,-85,0,20),
    UDim2.fromOffset(51,7),
    C.White
)
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = label(
    header,"BAD BOYS | ULTIMATE V6.0",
    UDim2.new(1,-85,0,15),
    UDim2.fromOffset(51,28),
    C.Red
)
subtitle.TextSize = 8
subtitle.TextXAlignment = Enum.TextXAlignment.Left

local close = makeButton(
    header,"X",
    UDim2.fromOffset(24,24),
    UDim2.new(1,-30,0,8),
    C.Red
)

-- MENU
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(6,60)
sidebar.Size = UDim2.new(0,70,1,-66)
sidebar.BackgroundColor3 = C.Dark
sidebar.Parent = panel
corner(sidebar,7)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0,5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

-- ÁREA PRINCIPAL
local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(82,60)
content.Size = UDim2.new(1,-88,1,-66)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 2
content.ScrollBarImageColor3 = C.Red
content.CanvasSize = UDim2.new()
content.Parent = panel

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0,5)
contentLayout.Parent = content

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(
        0,0,0,contentLayout.AbsoluteContentSize.Y+10
    )
end)

local function clear()
    for _,v in ipairs(content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= contentLayout then
            v:Destroy()
        end
    end
    content.CanvasPosition = Vector2.new(0,0)
end

local function section(text)
    local x = label(
        content,text,
        UDim2.new(1,-4,0,22),
        UDim2.new(),
        C.Red
    )
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextSize = 10
end

local function inputBox(placeholder,default)
    local x = Instance.new("TextBox")
    x.Size = UDim2.new(1,-4,0,31)
    x.BackgroundColor3 = C.Dark
    x.Text = default or ""
    x.PlaceholderText = placeholder
    x.PlaceholderColor3 = C.Gray
    x.TextColor3 = C.White
    x.Font = Enum.Font.Gotham
    x.TextSize = 10
    x.ClearTextOnFocus = false
    x.Parent = content
    corner(x,5)
    return x
end

local function action(text,callback,color)
    local b = makeButton(
        content,text,
        UDim2.new(1,-4,0,30),
        UDim2.new(),
        color or C.Dark
    )
    stroke(b,C.Blood,1)
    b.Activated:Connect(callback)
    return b
end

-- PÁGINAS
local showCommands
local showEditor
local showMat
local showFaction
local showSettings
local showFavorites

-- ITEM DE COMANDO
local function commandRow(cmd,index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,68)
    row.BackgroundColor3 = C.Dark
    row.Parent = content
    corner(row,5)

    local name = label(
        row,cmd.name,
        UDim2.new(1,-10,0,18),
        UDim2.fromOffset(5,2),
        C.White
    )
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextSize = 9

    local send = makeButton(
        row,"ENVIAR",
        UDim2.new(0.43,-4,0,23),
        UDim2.fromOffset(5,23),
        C.Red
    )

    send.Activated:Connect(function()
        sendChat(cmd.message)
    end)

    local edit = makeButton(
        row,"EDITAR",
        UDim2.new(0.43,-4,0,23),
        UDim2.new(0.46,0,0,23),
        Color3.fromRGB(55,45,48)
    )

    edit.Activated:Connect(function()
        showEditor(index)
    end)

    local fav = makeButton(
        row,favorites[index] and "★" or "☆",
        UDim2.fromOffset(25,23),
        UDim2.new(1,-30,0,23),
        C.Blood
    )

    fav.Activated:Connect(function()
        favorites[index] = not favorites[index]
        fav.Text = favorites[index] and "★" or "☆"
        notify(favorites[index] and "FAVORITO ADICIONADO" or "FAVORITO REMOVIDO")
    end)
end

-- COMANDOS
showCommands = function()
    currentPage = "COMANDOS"
    clear()
    section("COMANDOS BAD BOYS")

    for i,cmd in ipairs(commands) do
        commandRow(cmd,i)
    end
end

-- EDITOR
showEditor = function(index)
    currentPage = "EDITOR"
    clear()
    section(index and "EDITAR COMANDO" or "CRIAR COMANDO")

    local cmd = index and commands[index]
    local name = inputBox("Nome do comando",cmd and cmd.name)
    local message = inputBox("Mensagem enviada",cmd and cmd.message)

    action("SALVAR COMANDO",function()
        if name.Text:gsub("%s","") == ""
        or message.Text:gsub("%s","") == "" then
            notify("PREENCHA OS CAMPOS")
            return
        end

        local item = {
            name=name.Text:sub(1,35),
            message=message.Text:sub(1,150)
        }

        if index then
            commands[index] = item
        else
            table.insert(commands,item)
        end

        notify("COMANDO SALVO")
        showCommands()
    end,C.Blood)

    if index then
        action("EXCLUIR COMANDO",function()
            table.remove(commands,index)
            favorites[index] = nil
            notify("COMANDO EXCLUÍDO")
            showCommands()
        end)
    end

    action("VOLTAR",showCommands)
end

-- MAT
showMat = function()
    currentPage = "MAT"
    clear()
    section("CRIADOR DE MAT")

    local weapon = inputBox("Nome da arma","FAL")

    action("CRIAR MAT",function()
        local value = weapon.Text:gsub("[%c%[%]]",""):sub(1,35)
        if value:gsub("%s","") == "" then
            notify("NOME INVÁLIDO")
            return
        end

        table.insert(commands,{
            name="MAT "..value,
            message="/Mat ["..value.."]"
        })

        notify("MAT CRIADO")
        showCommands()
    end,C.Blood)

    action("VOLTAR",showCommands)
end

-- FACÇÃO
showFaction = function()
    currentPage = "FACÇÃO"
    clear()
    section("IDENTIDADE BAD BOYS")

    action("URSO",function()
        sendChat("BAD BOYS - URSO")
    end)

    action("BANDEIRA VERMELHA",function()
        sendChat("BAD BOYS - BANDEIRA VERMELHA")
    end)

    action("SAUDAÇÃO",function()
        sendChat("BAD BOYS - RESPEITO E LEALDADE")
    end)

    action("VOLTAR",showCommands)
end

-- FAVORITOS
showFavorites = function()
    currentPage = "FAVORITOS"
    clear()
    section("COMANDOS FAVORITOS")

    local count = 0

    for i,cmd in ipairs(commands) do
        if favorites[i] then
            count = count+1
            commandRow(cmd,i)
        end
    end

    if count == 0 then
        section("NENHUM FAVORITO AINDA")
    end

    action("VOLTAR",showCommands)
end

--========================================================
-- GHOST MODE
--========================================================

local function applyTransparency(obj)
    if obj:IsA("GuiObject") then
        if obj:GetAttribute("BB_BG") == nil then
            obj:SetAttribute("BB_BG",obj.BackgroundTransparency)
        end

        local original = obj:GetAttribute("BB_BG") or 0
        local amount = transparency

        if obj.Name == "GHOST_TOGGLE" then
            amount = 0.25
        end

        obj.BackgroundTransparency =
            original+(1-original)*amount

        if obj:IsA("TextLabel")
        or obj:IsA("TextButton")
        or obj:IsA("TextBox") then

            if obj:GetAttribute("BB_TXT") == nil then
                obj:SetAttribute("BB_TXT",obj.TextTransparency)
            end

            local originalText = obj:GetAttribute("BB_TXT") or 0
            local textAmount = 0.45

            if obj.Name == "GHOST_TOGGLE" then
                textAmount = 0.05
            end

            obj.TextTransparency =
                originalText+(1-originalText)*textAmount
        end

        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            if obj:GetAttribute("BB_IMG") == nil then
                obj:SetAttribute("BB_IMG",obj.ImageTransparency)
            end

            local originalImage = obj:GetAttribute("BB_IMG") or 0
            obj.ImageTransparency =
                originalImage+(1-originalImage)*transparency
        end

    elseif obj:IsA("UIStroke") then
        if obj:GetAttribute("BB_STROKE") == nil then
            obj:SetAttribute("BB_STROKE",obj.Transparency)
        end

        local original = obj:GetAttribute("BB_STROKE") or 0
        obj.Transparency = original+(1-original)*0.75
    end
end

local function restoreTransparency(obj)
    if obj:IsA("GuiObject") then
        local bg = obj:GetAttribute("BB_BG")
        if bg ~= nil then
            obj.BackgroundTransparency = bg
        end

        local txt = obj:GetAttribute("BB_TXT")
        if txt ~= nil then
            obj.TextTransparency = txt
        end

        local img = obj:GetAttribute("BB_IMG")
        if img ~= nil and (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then
            obj.ImageTransparency = img
        end

    elseif obj:IsA("UIStroke") then
        local value = obj:GetAttribute("BB_STROKE")
        if value ~= nil then
            obj.Transparency = value
        end
    end
end

local function refreshGhost()
    for _,obj in ipairs(gui:GetDescendants()) do
        if ghost then
            applyTransparency(obj)
        else
            restoreTransparency(obj)
        end
    end
end

gui.DescendantAdded:Connect(function(obj)
    if ghost then
        task.defer(function()
            if obj.Parent then
                applyTransparency(obj)
            end
        end)
    end
end)

local function setGhost(state)
    ghost = state
    refreshGhost()
    notify(ghost and "GHOST MODE ATIVADO" or "GHOST MODE DESATIVADO")
end

-- CONFIGURAÇÕES
showSettings = function()
    currentPage = "CONFIGURAÇÕES"
    clear()
    section("CONFIGURAÇÕES")

    local ghostButton = action(
        ghost and "GHOST MODE: ON" or "GHOST MODE: OFF",
        function()
            setGhost(not ghost)
            ghostButton.Text = ghost and "GHOST MODE: ON" or "GHOST MODE: OFF"
        end,
        C.Blood
    )
    ghostButton.Name = "GHOST_TOGGLE"

    action("MAIS VISÍVEL (+)",function()
        transparency = math.max(0.30,transparency-0.10)
        refreshGhost()
        notify("TRANSPARÊNCIA: "..math.floor(transparency*100).."%")
    end)

    action("MENOS VISÍVEL (-)",function()
        transparency = math.min(0.95,transparency+0.05)
        refreshGhost()
        notify("TRANSPARÊNCIA: "..math.floor(transparency*100).."%")
    end)

    action("AUMENTAR TAMANHO",function()
        scaleValue = math.min(1.20,scaleValue+0.05)
        uiScale.Scale = scaleValue
        notify("TAMANHO AUMENTADO")
    end)

    action("DIMINUIR TAMANHO",function()
        scaleValue = math.max(0.75,scaleValue-0.05)
        uiScale.Scale = scaleValue
        notify("TAMANHO REDUZIDO")
    end)

    action("RESTAURAR TAMANHO",function()
        scaleValue = 1
        uiScale.Scale = 1
        notify("TAMANHO PADRÃO")
    end)

    action("VOLTAR",showCommands)

    refreshGhost()
end

-- MENU LATERAL
local function sideButton(text,order,callback)
    local b = makeButton(
        sidebar,text,
        UDim2.new(1,-6,0,34),
        UDim2.new(),
        Color3.fromRGB(38,20,24)
    )
    b.LayoutOrder = order
    b.TextSize = 8
    b.Activated:Connect(callback)
end

sideButton("CMD",1,showCommands)
sideButton("EDITOR",2,function()
    showEditor(nil)
end)
sideButton("MAT",3,showMat)
sideButton("FAC",4,showFaction)
sideButton("FAV ★",5,showFavorites)
sideButton("CONFIG",6,showSettings)

-- ARRASTAR COM SUPORTE TOUCH E MOUSE
local function makeDraggable(obj,handle)
    local active = false
    local startPos
    local startPointer

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            startPos = obj.Position
            startPointer = input.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not active then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position-startPointer

            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset+delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)
end

makeDraggable(ball,ball)
makeDraggable(panel,header)

-- ABRIR E FECHAR
local opened = false
local busy = false

local function togglePanel()
    if busy then return end

    opened = not opened
    busy = true

    if opened then
        panel.Visible = true
        panel.Size = UDim2.fromOffset(245,0)

        local tween = TweenService:Create(
            panel,
            TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(245,340)}
        )

        tween:Play()
        tween.Completed:Connect(function()
            busy = false
            refreshGhost()
        end)
    else
        local tween = TweenService:Create(
            panel,
            TweenInfo.new(0.18,Enum.EasingStyle.Quad),
            {Size=UDim2.fromOffset(245,0)}
        )

        tween:Play()
        tween.Completed:Connect(function()
            panel.Visible = false
            busy = false
        end)
    end
end

ball.Activated:Connect(togglePanel)

close.Activated:Connect(function()
    if opened then
        togglePanel()
    end
end)

-- INICIALIZAÇÃO
showCommands()

notify("DEXTER V6.0 CARREGADO")

print("====================================")
print("BAD BOYS | DEXTER MORGAN V6.0")
print("ULTIMATE BLOOD EDITION")
print("GHOST MODE: READY")
print("====================================")
