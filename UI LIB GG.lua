-- UI Library Avanzada y Completa
local Library = {}

-- Variables para personalización
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Guarda las configuraciones del usuario
local Configurations = {}

-- Guardar y cargar configuraciones
function Library:SaveConfig(name)
    writefile(name .. ".json", HttpService:JSONEncode(Configurations))
end

function Library:LoadConfig(name)
    if isfile(name .. ".json") then
        Configurations = HttpService:JSONDecode(readfile(name .. ".json"))
    end
end

-- Crear ventana principal con pestañas
function Library:CreateWindow(title)
    local Window = {}
    
    -- Creación de la interfaz
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "AdvancedUILibrary"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    -- Crear pestañas para la ventana
    local TabContainer = Instance.new("Frame", MainFrame)
    TabContainer.Size = UDim2.new(1, 0, 0.1, 0)
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabContent = Instance.new("Frame", MainFrame)
    TabContent.Size = UDim2.new(1, 0, 0.9, 0)
    TabContent.Position = UDim2.new(0, 0, 0.1, 0)
    TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    -- Función para crear pestañas
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.Text = tabName
        TabButton.Size = UDim2.new(0.2, 0, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14

        local TabFrame = Instance.new("Frame", TabContent)
        TabFrame.Name = tabName
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

        local TabLayout = Instance.new("UIListLayout", TabFrame)
        TabLayout.FillDirection = Enum.FillDirection.Vertical
        TabLayout.Padding = UDim.new(0, 10)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContent:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            TabFrame.Visible = true
        end)

        return TabFrame
    end

    -- Crear un botón
    function Window:CreateButton(parent, buttonName, callback)
        local Button = Instance.new("TextButton", parent)
        Button.Text = buttonName
        Button.Size = UDim2.new(1, 0, 0.1, 0)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 16

        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    -- Crear un toggle
    function Window:CreateToggle(parent, toggleName, callback)
        local Toggle = Instance.new("TextButton", parent)
        Toggle.Text = toggleName
        Toggle.Size = UDim2.new(1, 0, 0.1, 0)
        Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 16

        local isOn = false

        Toggle.MouseButton1Click:Connect(function()
            isOn = not isOn
            Toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
            Configurations[toggleName] = isOn
            pcall(callback, isOn)
        end)
    end

    -- Crear un slider
    function Window:CreateSlider(parent, sliderName, minValue, maxValue, callback)
        local SliderFrame = Instance.new("Frame", parent)
        SliderFrame.Size = UDim2.new(1, 0, 0.1, 0)
        SliderFrame.BackgroundTransparency = 1

        local SliderLabel = Instance.new("TextLabel", SliderFrame)
        SliderLabel.Text = sliderName .. ": " .. tostring(minValue)
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextSize = 16
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Size = UDim2.new(1, 0, 0.5, 0)

        local SliderBar = Instance.new("Frame", SliderFrame)
        SliderBar.Size = UDim2.new(1, 0, 0.5, 0)
        SliderBar.Position = UDim2.new(0, 0, 0.5, 0)
        SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

        local SliderKnob = Instance.new("Frame", SliderBar)
        SliderKnob.Size = UDim2.new(0, 10, 1, 0)
        SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local dragging = false
        SliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        SliderKnob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        SliderKnob.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
                local relativePos = (mousePos - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                relativePos = math.clamp(relativePos, 0, 1)

                local value = math.floor(minValue + (maxValue - minValue) * relativePos)
                SliderKnob.Position = UDim2.new(relativePos, -5, 0, 0)
                SliderLabel.Text = sliderName .. ": " .. tostring(value)
                Configurations[sliderName] = value
                pcall(callback, value)
            end
        end)
    end

    -- Crear dropdown
    function Window:CreateDropdown(parent, dropdownName, options, callback)
        local Dropdown = Instance.new("TextButton", parent)
        Dropdown.Text = dropdownName
        Dropdown.Size = UDim2.new(1, 0, 0.1, 0)
        Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        Dropdown.Font = Enum.Font.Gotham
        Dropdown.TextSize = 16

        local DropdownList = Instance.new("Frame", Dropdown)
        DropdownList.Size = UDim2.new(1, 0, 0.5, 0)
        DropdownList.Position = UDim2.new(0, 0, 1, 0)
        DropdownList.Visible = false

        local Layout = Instance.new("UIListLayout", DropdownList)
        Layout.FillDirection = Enum.FillDirection.Vertical

        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton", DropdownList)
            OptionButton.Text = option
            OptionButton.Size = UDim2.new(1, 0, 0.1, 0)
            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Text = option
                DropdownList.Visible = false
                Configurations[dropdownName] = option
                pcall(callback, option)
            end)
        end

        Dropdown.MouseButton1Click:Connect(function()
            DropdownList.Visible = not DropdownList.Visible
        end)
    end

    return Window
end

return Library
