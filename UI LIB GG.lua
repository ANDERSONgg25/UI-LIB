local UILibrary = {}

-- Crea un nuevo objeto UI
local function createObject(class, properties)
    local obj = Instance.new(class)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

-- Crea una ventana principal
function UILibrary:CreateWindow(title, width, height)
    local ScreenGui = createObject("ScreenGui", {
        Name = "UI_Library",
        Parent = game:GetService("CoreGui")
    })
    
    local MainFrame = createObject("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
        Draggable = true,
        Active = true
    })

    local TitleBar = createObject("TextLabel", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Size = UDim2.new(1, 0, 0, 30),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })

    local Content = createObject("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        ClipsDescendants = true
    })
    
    local UIListLayout = createObject("UIListLayout", {
        Parent = Content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Content = Content
    }
end

-- Crea un botón
function UILibrary:CreateButton(parent, text, callback)
    local Button = createObject("TextButton", {
        Name = "Button",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, 0, 0, 40),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14
    })

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return Button
end

-- Crea un toggle
function UILibrary:CreateToggle(parent, text, callback)
    local Toggle = createObject("Frame", {
        Name = "Toggle",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, 0, 0, 40)
    })

    local Label = createObject("TextLabel", {
        Name = "Label",
        Parent = Toggle,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 1, 0),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Button = createObject("TextButton", {
        Name = "ToggleButton",
        Parent = Toggle,
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0.8, 0, 0, 0),
        Text = ""
    })

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        pcall(callback, state)
    end)

    return Toggle
end

-- Crea un slider
function UILibrary:CreateSlider(parent, text, min, max, callback)
    local SliderFrame = createObject("Frame", {
        Name = "SliderFrame",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, 0, 0, 40)
    })

    local Label = createObject("TextLabel", {
        Name = "Label",
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 1, 0),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Slider = createObject("TextButton", {
        Name = "Slider",
        Parent = SliderFrame,
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0.8, 0, 0, 0),
        Text = min
    })

    local dragging = false
    local currentValue = min

    Slider.MouseButton1Down:Connect(function()
        dragging = true
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local position = math.clamp(input.Position.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
            currentValue = math.floor(((position / SliderFrame.AbsoluteSize.X) * (max - min)) + min)
            Slider.Text = tostring(currentValue)
            pcall(callback, currentValue)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return SliderFrame
end

return UILibrary
