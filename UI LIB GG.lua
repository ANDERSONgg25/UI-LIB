local UILibrary = {}

-- Helper function to create objects
local function createObject(className, properties)
    local object = Instance.new(className)
    for prop, value in pairs(properties) do
        object[prop] = value
    end
    return object
end

-- Function to create the main window
function UILibrary:CreateWindow(title, sizeX, sizeY)
    local ScreenGui = createObject("ScreenGui", {Name = "ExploitUI", Parent = game:GetService("CoreGui")})
    
    local MainFrame = createObject("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Size = UDim2.new(0, sizeX or 400, 0, sizeY or 500),
        Position = UDim2.new(0.5, -(sizeX or 400) / 2, 0.5, -(sizeY or 500) / 2)
    })
    
    local UICorner = createObject("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    })
    
    local TitleLabel = createObject("TextLabel", {
        Name = "Title",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 50),
        Font = Enum.Font.GothamBold,
        Text = title or "Exploit UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    local ContentFrame = createObject("ScrollingFrame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -70),
        Position = UDim2.new(0, 10, 0, 60),
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 10, 0), -- Dynamic canvas size based on content
    })

    return {Frame = MainFrame, Content = ContentFrame}
end

-- Function to create a button
function UILibrary:CreateButton(parent, text, callback)
    local Button = createObject("TextButton", {
        Name = "Button",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 40),
        Font = Enum.Font.Gotham,
        Text = text or "Button",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    createObject("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return Button
end

-- Function to create a toggle
function UILibrary:CreateToggle(parent, text, callback)
    local ToggleFrame = createObject("Frame", {
        Name = "ToggleFrame",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0, 200, 0, 40)
    })
    
    createObject("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleFrame})
    
    local Label = createObject("TextLabel", {
        Name = "Label",
        Parent = ToggleFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text or "Toggle",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    local ToggleButton = createObject("TextButton", {
        Name = "ToggleButton",
        Parent = ToggleFrame,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- Red for off
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Text = "",
    })
    
    createObject("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleButton})
    
    local toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Green for on, Red for off
        pcall(callback, toggled)
    end)
    
    return ToggleFrame
end

-- Function to create a slider
function UILibrary:CreateSlider(parent, text, minValue, maxValue, callback)
    local SliderFrame = createObject("Frame", {
        Name = "SliderFrame",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0, 200, 0, 40)
    })
    
    createObject("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SliderFrame})
    
    local Label = createObject("TextLabel", {
        Name = "Label",
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text or "Slider",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    local SliderBar = createObject("Frame", {
        Name = "SliderBar",
        Parent = SliderFrame,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Size = UDim2.new(0.7, 0, 0.2, 0),
        Position = UDim2.new(0.15, 0, 0.5, -5)
    })
    
    local SliderHandle = createObject("TextButton", {
        Name = "SliderHandle",
        Parent = SliderBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 10, 1, 0),
        Text = ""
    })
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderHandle.Position = UDim2.new(pos, -SliderHandle.Size.X.Offset / 2, 0, 0)
        local value = math.floor(minValue + (pos * (maxValue - minValue)))
        pcall(callback, value)
    end
    
    SliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    SliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return SliderFrame
end

-- Function to create a dropdown list
function UILibrary:CreateDropdown(parent, text, options, callback)
    local DropdownFrame = createObject("Frame", {
        Name = "DropdownFrame",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0, 200, 0, 40)
    })
    
    createObject("UICorner", {CornerRadius = UDim.new(0, 8), Parent = DropdownFrame})
    
    local Label = createObject("TextLabel", {
        Name = "Label",
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text or "Dropdown",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    local DropButton = createObject("TextButton", {
        Name = "DropButton",
        Parent = DropdownFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "▼",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    local Open = false
    local OptionsFrame = createObject("Frame", {
        Name = "OptionsFrame",
        Parent = DropdownFrame,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        ClipsDescendants = true
    })
    
    DropButton.MouseButton1Click:Connect(function()
        Open = not Open
        OptionsFrame.Size = Open and UDim2.new(1, 0, 0, #options * 30) or UDim2.new(1, 0, 0, 0)
    end)
    
    for _, option in pairs(options) do
        local OptionButton = createObject("TextButton", {
            Name = option,
            Parent = OptionsFrame,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Size = UDim2.new(1, 0, 0, 30),
            Text = option,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham
        })
        
        OptionButton.MouseButton1Click:Connect(function()
            pcall(callback, option)
            Label.Text = option
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            Open = false
        end)
    end
    
    return DropdownFrame
end

return UILibrary
