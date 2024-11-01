-- AdvancedUI.lua
local AdvancedUI = {}

-- Tema predeterminado
AdvancedUI.Theme = {
    backgroundColor = Color3.fromRGB(40, 40, 40),
    buttonColor = Color3.fromRGB(70, 130, 180),
    textColor = Color3.fromRGB(255, 255, 255),
    sliderColor = Color3.fromRGB(100, 100, 200),
    checkboxColor = Color3.fromRGB(60, 60, 60),
}

-- Aplicar un tema nuevo
function AdvancedUI.applyTheme(theme)
    AdvancedUI.Theme = theme
end

-- Crear una ventana básica
function AdvancedUI.newWindow(title, size)
    local Frame = Instance.new("Frame")
    Frame.Size = size or UDim2.new(0, 400, 0, 300)
    Frame.BackgroundColor3 = AdvancedUI.Theme.backgroundColor
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.Text = title or "Ventana"
    TitleBar.TextColor3 = AdvancedUI.Theme.textColor
    TitleBar.Font = Enum.Font.SourceSansBold
    TitleBar.TextSize = 18
    TitleBar.Parent = Frame

    return Frame
end

-- Crear un botón
function AdvancedUI.newButton(text, size, clickFunction)
    local Button = Instance.new("TextButton")
    Button.Size = size or UDim2.new(0, 100, 0, 50)
    Button.Text = text or "Botón"
    Button.BackgroundColor3 = AdvancedUI.Theme.buttonColor
    Button.TextColor3 = AdvancedUI.Theme.textColor
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16

    if clickFunction then
        Button.MouseButton1Click:Connect(clickFunction)
    end

    return Button
end

-- Crear un slider
function AdvancedUI.newSlider(size, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = size or UDim2.new(0, 200, 0, 20)
    Slider.BackgroundColor3 = AdvancedUI.Theme.sliderColor
    Slider.BorderSizePixel = 0

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = AdvancedUI.Theme.buttonColor
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

-- Crear un checkbox
function AdvancedUI.newCheckbox(size, callback)
    local Checkbox = Instance.new("Frame")
    Checkbox.Size = size or UDim2.new(0, 20, 0, 20)
    Checkbox.BackgroundColor3 = AdvancedUI.Theme.checkboxColor
    Checkbox.BorderSizePixel = 0

    local Checked = Instance.new("TextLabel")
    Checked.Size = UDim2.new(1, 0, 1, 0)
    Checked.Text = "✓"
    Checked.TextColor3 = AdvancedUI.Theme.textColor
    Checked.Visible = false
    Checked.Parent = Checkbox

    Checkbox.MouseButton1Click:Connect(function()
        Checked.Visible = not Checked.Visible
        callback(Checked.Visible)
    end)

    return Checkbox
end

return AdvancedUI
