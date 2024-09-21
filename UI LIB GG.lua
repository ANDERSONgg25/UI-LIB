-- UI Library Avanzada
local UILibrary = {}
UILibrary.__index = UILibrary

-- Crear una ventana (Window)
function UILibrary:CreateWindow(options)
    local window = {}
    window.Title = options.Title or "Window"
    window.Size = options.Size or UDim2.new(0, 450, 0, 400)
    window.Position = options.Position or UDim2.new(0.5, -225, 0.5, -200)
    window.MinimizeKey = options.MinimizeKey or Enum.KeyCode.M

    -- Crear ScreenGui y Frame principal
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")

    ScreenGui.Name = "AdvancedUILibrary"
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = window.Size
    MainFrame.Position = window.Position
    MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainFrame.BorderSizePixel = 0

    -- Título de la ventana
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Text = window.Title
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.TextSize = 18

    -- Botón de cerrar
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18

    -- Función de cerrar ventana
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Función para minimizar la ventana
    local isMinimized = false
    game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == window.MinimizeKey then
            isMinimized = not isMinimized
            if isMinimized then
                MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            else
                MainFrame:TweenSize(window.Size, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            end
        end
    end)

    -- Función para mover la ventana (draggable)
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Función para agregar pestañas
    function window:AddTab(tabOptions)
        local tab = {}
        tab.Title = tabOptions.Title or "Tab"

        -- Crear botón de pestaña
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = MainFrame
        TabButton.Size = UDim2.new(0, 100, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, 40) -- Posición de prueba, puedes ajustarlo
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Text = tab.Title
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14

        function tab:AddButton(buttonOptions)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.Position = UDim2.new(0, 10, 0, 50) -- Posición de prueba
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Button.Text = buttonOptions.Title
            Button.Font = Enum.Font.Gotham
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14

            Button.MouseButton1Click:Connect(function()
                if buttonOptions.Callback then
                    buttonOptions.Callback()
                end
            end)
            Button.Parent = MainFrame
        end

        -- Función para añadir un toggle
        function tab:AddToggle(toggleOptions)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -20, 0, 40)
            Toggle.Position = UDim2.new(0, 10, 0, 100)
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Toggle.Text = toggleOptions.Title
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.TextSize = 14

            local toggled = false
            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                Toggle.Text = toggleOptions.Title .. " (" .. (toggled and "On" or "Off") .. ")"
                if toggleOptions.Callback then
                    toggleOptions.Callback(toggled)
                end
            end)
            Toggle.Parent = MainFrame
        end

        -- Función para añadir un slider
        function tab:AddSlider(sliderOptions)
            local Slider = Instance.new("TextButton")
            Slider.Size = UDim2.new(1, -20, 0, 40)
            Slider.Position = UDim2.new(0, 10, 0, 150)
            Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Slider.Text = sliderOptions.Title .. " (" .. tostring(sliderOptions.Default) .. ")"
            Slider.Font = Enum.Font.Gotham
            Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
            Slider.TextSize = 14

            local value = sliderOptions.Default or 50
            Slider.MouseButton1Click:Connect(function()
                value = value + 10 -- Incrementar el valor por 10 como ejemplo
                if value > sliderOptions.Max then value = sliderOptions.Max end
                Slider.Text = sliderOptions.Title .. " (" .. tostring(value) .. ")"
                if sliderOptions.Callback then
                    sliderOptions.Callback(value)
                end
            end)
            Slider.Parent = MainFrame
        end

        -- Función para añadir un dropdown
        function tab:AddDropdown(dropdownOptions)
            local Dropdown = Instance.new("TextButton")
            Dropdown.Size = UDim2.new(1, -20, 0, 40)
            Dropdown.Position = UDim2.new(0, 10, 0, 200)
            Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Dropdown.Text = dropdownOptions.Title
            Dropdown.Font = Enum.Font.Gotham
            Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.TextSize = 14

            Dropdown.MouseButton1Click:Connect(function()
                if dropdownOptions.Callback then
                    dropdownOptions.Callback(dropdownOptions.Options[1]) -- Devolver la primera opción como ejemplo
                end
            end)
            Dropdown.Parent = MainFrame
        end

        return tab
    end

    return window
end

-- Publicar la librería para que otros la usen
return UILibrary
