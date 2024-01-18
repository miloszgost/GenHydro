# ---------FUNKCJE-------------
using Dates
using Test

mutable struct GenHydroSettings
    # EditSimulation
    frames_per_second::UInt8
    finish_time::UInt16
    # EditInputPlant
    input_power::UInt32
    # EditHydrogenPlant
    fuelcell_power::UInt32
    hydrogen_burn_rate_per_minute::Float32
    electrolizer_power::UInt32
    hydrogen_production_per_minute::Float32
    # EditReceiverPlant
    receiver_power::UInt32
    # EditEfficiency
    input_efficiency::UInt8
    fuelcell_efficiency::UInt8
    electrolizer_efficiency::UInt8
    # Internal Bools
    is_played::Bool
    is_paused::Bool
    is_stopped::Bool
    
    GenHydroSettings() = new(
        60, 1440,
        10000,
        3000, 0.6298110, 9600, 2.2308758,
        3000,
        100, 100, 100,
        false, false, false)
end

function on_clicked_widget(widget)
    println(" \" ", get_gtk_property(widget, :label, String), " \" has been clicked!")
end

function on_clicked_widget_hide(widget)
    widget_label = get_gtk_property(widget, :label, String)
    if widget_label == "Anuluj"
        hide(appSkeleton["Dialog"])
    elseif widget_label == "_Close" || widget_label == "Za_mknij"
        hide(appSkeleton["MainAbout"])
    end
end

function on_clicked_widget_save_form(widget)
    widget_label = get_gtk_property(widget, :label, String)
    e = nothing
    if widget_label == "Akceptuj"
        entry1 = get_gtk_property(appSkeleton["Entry1"], :text, String)
        println("W Parametr 1. wpisano: '$entry1'")
        entry2 = get_gtk_property(appSkeleton["Entry2"], :text, String)
        println("W Parametr 2. wpisano: '$entry2'")
        entry3 = get_gtk_property(appSkeleton["Entry3"], :text, String)
        println("W Parametr 3. wpisano: '$entry3'")
        entry4 = get_gtk_property(appSkeleton["Entry4"], :text, String)
        println("W Parametr 4. wpisano: '$entry4'")
        if get_gtk_property(appSkeleton["DialogLabel"], :label, String) == "Edycja symulacji zjawiska"
            
            try
                appSettings.frames_per_second = tryparse(UInt8, entry1)
                appSettings.finish_time = tryparse(UInt16, entry2)
            catch e
                showall(appSkeleton["LabelError"])
            end
            
        elseif get_gtk_property(appSkeleton["DialogLabel"], :label, String) == "Edycja elektrowni wejściowej"
            try
                appSettings.input_power = tryparse(UInt32, entry1)
            catch e
                showall(appSkeleton["LabelError"])
            end
        elseif get_gtk_property(appSkeleton["DialogLabel"], :label, String) == "Edycja elektrowni wodorowej"
            try
                appSettings.fuelcell_power = tryparse(UInt32, entry1)
                appSettings.hydrogen_burn_rate_per_minute = tryparse(Float32, entry2)
                appSettings.electrolizer_power = tryparse(UInt32, entry3)
                appSettings.hydrogen_production_per_minute = tryparse(Float32, entry4)
            catch e
                showall(appSkeleton["LabelError"])
            end
        elseif get_gtk_property(appSkeleton["DialogLabel"], :label, String) == "Edycja odbiorcy prądu"
            try
                appSettings.receiver_power = tryparse(UInt32, entry1)
            catch e
                showall(appSkeleton["LabelError"])
            end
        elseif get_gtk_property(appSkeleton["DialogLabel"], :label, String) == "Edycja sprawności"
            try
                appSettings.input_efficiency = tryparse(UInt8, entry1)
                appSettings.electrolizer_efficiency = tryparse(UInt8, entry2)
                appSettings.fuelcell_efficiency = tryparse(UInt8, entry3)
            catch e
                showall(appSkeleton["LabelError"])
            end
        end
        if isnothing(e) == true
            hide(appSkeleton["LabelError"])
            hide(appSkeleton["Dialog"])
        else
            println(e)
        end
    end
end

function on_clicked_screenshot(widget)
    screenshot_name = Dates.now()
    screenshot_name = Dates.format(screenshot_name, "YYYY-mm-dd-HH-MM-SS")
    savefig(stepPlot, "screenshots\\$(screenshot_name).png")
    println("Took a screenshot!")
end

function on_clicked_play(widget)
    appSettings.is_played = true
    appSettings.is_paused = false
    appSettings.is_stopped = false
end

function on_clicked_pause(widget)
    appSettings.is_played = false
    appSettings.is_paused = true
    appSettings.is_stopped = false
end

function on_clicked_stop(widget)
    appSettings.is_played = false
    appSettings.is_paused = false
    appSettings.is_stopped = true
end

function on_clicked_apply(widget)

    global active_chart = get_gtk_property(appSkeleton["ChartTypeSelect"], :active_id, String)

    if active_chart == "PowerSource"
        global active_title = "Moc źródła [W]"
    elseif active_chart == "PowerReceiver"
        global active_title = "Moc obciążenia [W]"
    elseif active_chart == "PowerBalance"
        global active_title = "Bilans źródło/odbiorca [W]"
    elseif active_chart == "PowerBalanceOverall"
        global active_title = "Bilans energetyczny systemu [W]"
    elseif active_chart == "HydrogenProduction"
        global active_title = "Produkcja wodoru [H2mol]"
    elseif active_chart == "HydrogenBurn"
        global active_title = "Spalanie wodoru [H2mol]"
    elseif active_chart == "HydrogenBalance"
        global active_title = "Bilans wodoru [H2mol]"
    end
    
    global active_camera = get_gtk_property(appSkeleton["ChartCameraSelect"], :active_id, String)

    global active_color = get_gtk_property(appSkeleton["ChartColorSelect"], :active_id, String)
    if active_color == "Blue"
        active_color = :blues
    elseif active_color == "Red"
        active_color = :red
    elseif active_color == "Green"
        active_color = :green
    end
    global active_style = get_gtk_property(appSkeleton["ChartDrawStyleSelect"], :active_id, String)
    if active_style == "Line"
        active_style = :solid
    elseif active_style == "LineDash"
        active_style = :dash
    elseif active_style == "LineDot"
        active_style = :dot
    end
end

"""
    Funkcja rozpatruje dalsze akcje 
    po naciśnięciu danego przycisku edycji.
    Wykrywa przycisk na podstawie etykiety (:label).
"""
function on_clicked_edit_button(widget)

    set_gtk_property!(appSkeleton["Dialog"], :title, get_gtk_property(widget, :label, String))
    showall(appSkeleton["Dialog"])
    hide(appSkeleton["LabelError"])
    if get_gtk_property(widget, :label, String) == "EditSimulation"
        set_gtk_property!(appSkeleton["DialogLabel"], :label, "Edycja symulacji zjawiska")
        set_gtk_property!(appSkeleton["Label1"], :label, "Liczba FPS [Hz]")
        set_gtk_property!(appSkeleton["Label2"], :label, "Czas symulowany [min]")
        set_gtk_property!(appSkeleton["Label3"], :label, "???")
        set_gtk_property!(appSkeleton["Label4"], :label, "???")
        set_gtk_property!(appSkeleton["Entry1"], :text, appSettings.frames_per_second)
        set_gtk_property!(appSkeleton["Entry2"], :text, appSettings.finish_time)
        set_gtk_property!(appSkeleton["Entry3"], :text, "")
        set_gtk_property!(appSkeleton["Entry4"], :text, "")
        hide(appSkeleton["Label3"])
        hide(appSkeleton["Entry3"])
        hide(appSkeleton["Label4"])
        hide(appSkeleton["Entry4"])

    elseif get_gtk_property(widget, :label, String) == "EditInputPlant"
        set_gtk_property!(appSkeleton["DialogLabel"], :label, "Edycja elektrowni wejściowej")
        set_gtk_property!(appSkeleton["Label1"], :label, "Moc elektrowni [W]")
        set_gtk_property!(appSkeleton["Label2"], :label, "???")
        set_gtk_property!(appSkeleton["Label3"], :label, "???")
        set_gtk_property!(appSkeleton["Label4"], :label, "???")
        set_gtk_property!(appSkeleton["Entry1"], :text, appSettings.input_power)
        set_gtk_property!(appSkeleton["Entry2"], :text, "")
        set_gtk_property!(appSkeleton["Entry3"], :text, "")
        set_gtk_property!(appSkeleton["Entry4"], :text, "")
        hide(appSkeleton["Label2"])
        hide(appSkeleton["Entry2"])
        hide(appSkeleton["Label3"])
        hide(appSkeleton["Entry3"])
        hide(appSkeleton["Label4"])
        hide(appSkeleton["Entry4"])

    elseif get_gtk_property(widget, :label, String) == "EditHydrogenPlant"
        set_gtk_property!(appSkeleton["DialogLabel"], :label, "Edycja elektrowni wodorowej")
        set_gtk_property!(appSkeleton["Label1"], :label, "Moc ogniwa paliwowego [W]")
        set_gtk_property!(appSkeleton["Label2"], :label, "Tempo spalania wodoru [mol/min]")
        set_gtk_property!(appSkeleton["Label3"], :label, "Moc elektrolizera [W]")
        set_gtk_property!(appSkeleton["Label4"], :label, "Tempo produkcji wodoru [mol/min]")
        set_gtk_property!(appSkeleton["Entry1"], :text, appSettings.fuelcell_power)
        set_gtk_property!(appSkeleton["Entry2"], :text, appSettings.hydrogen_burn_rate_per_minute)
        set_gtk_property!(appSkeleton["Entry3"], :text, appSettings.electrolizer_power)
        set_gtk_property!(appSkeleton["Entry4"], :text, appSettings.hydrogen_production_per_minute)

    elseif get_gtk_property(widget, :label, String) == "EditReceiverPlant"
        set_gtk_property!(appSkeleton["DialogLabel"], :label, "Edycja odbiorcy prądu")
        set_gtk_property!(appSkeleton["Label1"], :label, "Moc obciążenia [W]")
        set_gtk_property!(appSkeleton["Label2"], :label, "???")
        set_gtk_property!(appSkeleton["Label3"], :label, "???")
        set_gtk_property!(appSkeleton["Label4"], :label, "???")
        set_gtk_property!(appSkeleton["Entry1"], :text, appSettings.receiver_power)
        set_gtk_property!(appSkeleton["Entry2"], :text, "")
        set_gtk_property!(appSkeleton["Entry3"], :text, "")
        set_gtk_property!(appSkeleton["Entry4"], :text, "")
        hide(appSkeleton["Label2"])
        hide(appSkeleton["Entry2"])
        hide(appSkeleton["Label3"])
        hide(appSkeleton["Entry3"])
        hide(appSkeleton["Label4"])
        hide(appSkeleton["Entry4"])
    
    elseif get_gtk_property(widget, :label, String) == "EditEfficiency"
        set_gtk_property!(appSkeleton["DialogLabel"], :label, "Edycja sprawności")
        set_gtk_property!(appSkeleton["Label1"], :label, "Sprawność elektrowni wejściowej [%]")
        set_gtk_property!(appSkeleton["Label2"], :label, "Sprawność elektrolizera [%]")
        set_gtk_property!(appSkeleton["Label3"], :label, "Sprawność ogniwa paliwowego [%]")
        set_gtk_property!(appSkeleton["Label4"], :label, "???")
        set_gtk_property!(appSkeleton["Entry1"], :text, appSettings.input_efficiency)
        set_gtk_property!(appSkeleton["Entry2"], :text, appSettings.electrolizer_efficiency)
        set_gtk_property!(appSkeleton["Entry3"], :text, appSettings.fuelcell_efficiency)
        set_gtk_property!(appSkeleton["Entry4"], :text, "")
        hide(appSkeleton["Label4"])
        hide(appSkeleton["Entry4"])

    end
    
end

function on_clicked_Start(widget)
    showall(app)
end

function on_clicked_About(widget)
    showall(about)
    set_gtk_property!(about, :version, APP_VERSION)
    hide(appSkeleton["AboutButtons"][2])
end


function on_clicked_hyperlink(widget)
    println(" \" ", get_gtk_property(widget, :name, String), " \" has been clicked!")
    link = get_gtk_property(widget, :uri, String)
    strip(link, ''')
    open_link = Cmd(`xdg-open $link`, detach=true)
    run(open_link)
    return true
end
