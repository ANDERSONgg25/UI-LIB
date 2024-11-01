-- AdvancedUILib.lua

local AdvancedUILibrary = {}

-- Tema predeterminado
AdvancedUILibrary.Theme = {
    backgroundColor = Color3.fromRGB(40, 40, 40),
    buttonColor = Color3.fromRGB(70, 130, 180),
    textColor = Color3.fromRGB(255, 255, 255),
    sliderColor = Color3.fromRGB(100, 100, 200),
    checkboxColor = Color3.fromRGB(60, 60, 60),
}

-- Función para aplicar el tema
function AdvancedUILibrary.applyTheme(theme)
    AdvancedUILibrary.Theme = theme
end

-- Módulo de Ventana
function AdvancedUILibrary.newWindow(title, size)
    local Frame = Instance.new("Frame")
    Frame.Size = size or UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = AdvancedUILibrary.Theme.backgroundColor
    Frame.BorderSizePixel = 0

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.Text = title or "Window"
    TitleBar.TextColor3 = AdvancedUILibrary.Theme.textColor
    TitleBar.Parent = Frame

    return Frame
end

-- Módulo de Botón
function AdvancedUILibrary.newButton(text, size, clickFunction)
    local Button = Instance.new("TextButton")
    Button.Size = size or UDim2.new(0, 100, 0, 50)
    Button.Text = text or "Button"
    Button.BackgroundColor3 = AdvancedUILibrary.Theme.buttonColor
    Button.TextColor3 = AdvancedUILibrary.Theme.textColor

    if clickFunction then
        Button.MouseButton1Click:Connect(clickFunction)
    end

    return Button
end

-- Módulo de Slider
function AdvancedUILibrary.newSlider(size, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = size or UDim2.new(0, 200, 0, 20)
    Slider.BackgroundColor3 = AdvancedUILibrary.Theme.sliderColor
    Slider.BorderSizePixel = 0

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = AdvancedUILibrary.Theme.buttonColor
    Fill.Parent = Slider

    local UserInputService = game:GetService("UserInputService")
    local dragging = false

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newSize = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(newSize, 0, 1, 0)
            callback(math.floor(newSize * (max - min) + min))
        end
    end)

    return Slider
end

-- Módulo de Checkbox
function AdvancedUILibrary.newCheckbox(size, callback)
    local Checkbox = Instance.new("Frame")
    Checkbox.Size = size or UDim2.new(0, 20, 0, 20)
    Checkbox.BackgroundColor3 = AdvancedUILibrary.Theme.checkboxColor
    Checkbox.BorderSizePixel = 0

    local Checked = Instance.new("TextLabel")
    Checked.Size = UDim2.new(1, 0, 1, 0)
    Checked.Text = "✓"
    Checked.TextColor3 = AdvancedUILibrary.Theme.textColor
    Checked.Visible = false
    Checked.Parent = Checkbox

    Checkbox.MouseButton1Click:Connect(function()
        Checked.Visible = not Checked.Visible
        callback(Checked.Visible)
    end)

    return Checkbox
end

return AdvancedUILibrary
