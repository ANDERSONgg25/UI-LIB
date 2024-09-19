-- UI Library avanzada
local UILib = {}
UILib.__index = UILib

function UILib:CreateWindow(options)
    local window = {}
    window.title = options.Title or "Advanced UI"
    window.size = options.Size or UDim2.fromOffset(600, 400)
    window.theme = options.Theme or "Dark"
    window.tabs = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = window.size
    mainFrame.Position = UDim2.new(0.5, -window.size.X.Offset/2, 0.5, -window.size.Y.Offset/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = window.title
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.Parent = mainFrame

    -- Tab creation
    function window:AddTab(tabOptions)
        local tab = {}
        tab.title = tabOptions.Title or "New Tab"
        tab.elements = {}

        local tabButton = Instance.new("TextButton")
        tabButton.Text = tab.title
        tabButton.Size = UDim2.new(0, 120, 0, 40)
        tabButton.Position = UDim2.new(0, #window.tabs * 130, 0, 0)
        tabButton.Parent = mainFrame

        function tab:AddButton(buttonOptions)
            local button = Instance.new("TextButton")
            button.Text = buttonOptions.Title or "Button"
            button.Size = UDim2.new(0, 200, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            button.Parent = mainFrame

            button.MouseButton1Click:Connect(buttonOptions.Callback)
            table.insert(tab.elements, button)
        end
        
        function tab:AddToggle(toggleOptions)
            local toggle = Instance.new("TextButton")
            toggle.Text = toggleOptions.Title or "Toggle"
            toggle.Size = UDim2.new(0, 200, 0, 40)
            toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            toggle.Parent = mainFrame

            local state = false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggleOptions.Callback(state)
                toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end)

            table.insert(tab.elements, toggle)
        end

        function tab:AddSlider(sliderOptions)
            local slider = Instance.new("TextButton")
            slider.Text = sliderOptions.Title or "Slider"
            slider.Size = UDim2.new(0, 200, 0, 40)
            slider.Parent = mainFrame

            local value = sliderOptions.Default or 0
            slider.MouseButton1Click:Connect(function()
                value = value + 1
                slider.Text = sliderOptions.Title .. ": " .. value
                sliderOptions.Callback(value)
            end)

            table.insert(tab.elements, slider)
        end

        table.insert(window.tabs, tab)
        return tab
    end

    return window
end

-- Cargar la UI Library para los usuarios
return UILib
