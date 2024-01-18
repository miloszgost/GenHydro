using Pkg
Pkg.activate(".")
using Gtk, Plots, Random
include("events.jl")
include("powerplant.jl")

# zaimportuj plik .glade jako XML do kodu
appSkeleton = GtkBuilder(filename="xml\\GenHydro.glade")

APP_VERSION = "v1.0"
OPTION_NAMES = ("New", "Open", "Save", "SaveAs", "Info", 
"Play", "Pause", "Stop", "EditSimulation", 
"EditInputPlant", "EditHydrogenPlant", "EditReceiverPlant", "EditEfficiency")
OPTION_NUMBER = length(OPTION_NAMES)

# ---------FUNKCJE--------------
chart_arrays = Array{Vector{Float64}}(undef, 7)
for i in eachindex(chart_arrays)
    chart_arrays[i] = []
end
# println(chart_arrays)
function get_chart_array(x::Vector, chart_type)

    function update_chart_arrays(x::Vector)
        push!(chart_arrays[1], current_input_power(x))
        push!(chart_arrays[2], current_receiver_power(x))
        push!(chart_arrays[3], current_balance_power(x))
        push!(chart_arrays[4], current_balance_power_overall(x))
        push!(chart_arrays[5], current_hydrogen_production(x))
        push!(chart_arrays[6], current_hydrogen_burn(x))
        push!(chart_arrays[7], current_hydrogen_balance(x))
    end
    
    update_chart_arrays(x)

    if chart_type == "PowerSource"
        result = chart_arrays[1]
    elseif chart_type == "PowerReceiver"
        result = chart_arrays[2]
    elseif chart_type == "PowerBalance"
        result = chart_arrays[3]
    elseif chart_type == "PowerBalanceOverall"
        result = chart_arrays[4]
    elseif chart_type == "HydrogenProduction"
        result = chart_arrays[5]
    elseif chart_type == "HydrogenBurn"
        result = chart_arrays[6]
    elseif chart_type == "HydrogenBalance"
        result = chart_arrays[7]
    end
    return result
end

function get_camera_range(x::Vector, camera_range)
    result = 1
    if camera_range == "Everything"
        result = last(x)
    elseif camera_range == "Last10"
        result = 10
    elseif camera_range == "Last60"
        result = 60
    elseif camera_range == "Last100"
        result = 100
    elseif camera_range == "Last600"
        result = 600
    end
    return result
end

function draw_simulation(settings::GenHydroSettings, startstep::Int)
    sleep_rate = 1/settings.frames_per_second
    for currentstep in startstep:settings.finish_time + 1

        sleep(sleep_rate)
        if settings.is_played
            if currentstep == 1
                # zmiana elementow wykresu
                Plots.title!("Data Analysis Visualization")
                Plots.xlabel!("X-axis")
                Plots.ylabel!("Y-axis")
                savefig(stepPlot, "plot.png")
            end
            # rysowanie animacji
            push!(x, currentstep-1)
            
            chosen_camera_range = get_camera_range(x, active_camera)
            chosen_chart_array = get_chart_array(x, active_chart)
            
            global stepPlot = Plots.plot(x, chosen_chart_array, legend=false, linecolor=active_color, linestyle=active_style)
            Plots.xlims!(last(x) - chosen_camera_range, last(x))
            Plots.title!(active_title)
            Plots.xlabel!("t [min]")
            
            savefig(stepPlot, "plot.png")
            new_image = GdkPixbuf(filename = "plot.png", width=-1, height=-1)
            set_gtk_property!(PlotArea, :pixbuf, new_image)
            
        elseif settings.is_paused
            global timestep = currentstep
            break
        elseif settings.is_stopped
            global stepPlot = Plots.plot()
            savefig(stepPlot, "plot.png")
            blank_chart = GdkPixbuf(filename = "plot.png", width=-1, height=-1)
            set_gtk_property!(PlotArea, :pixbuf, blank_chart)
            break
        end
    end
    println("DONE")
end

# ---------SKRYPT--------------

# parsowanie
start   = appSkeleton["MainMenu"]
signal_connect(on_clicked_Start, appSkeleton["Start"], "clicked")
about   = appSkeleton["MainAbout"]
aboutButtons = appSkeleton["AboutButtons"]
signal_connect(on_clicked_About, appSkeleton["Info"], "clicked")

signal_connect(on_clicked_widget, aboutButtons[1], "clicked")
signal_connect(on_clicked_widget, aboutButtons[2], "clicked")
signal_connect(on_clicked_widget, aboutButtons[3], "clicked")
signal_connect(on_clicked_widget_hide, aboutButtons[3], "clicked")

dialog = appSkeleton["Dialog"]
signal_connect(on_clicked_widget_hide, appSkeleton["DialogCancel"], "clicked")
signal_connect(on_clicked_widget_save_form, appSkeleton["DialogAccept"], "clicked")

app     = appSkeleton["MainApp"]
PlotArea = appSkeleton["PlotArea"]
# println(PlotArea)
set_gtk_property!(app, :title, "GenHydro $(APP_VERSION)")

# przypisz sygnały przyciskom menu głównego
buttons_MainApp = Array{GtkToolButtonLeaf}(undef, OPTION_NUMBER)
for i in eachindex(OPTION_NAMES)
    buttons_MainApp[i] = appSkeleton[OPTION_NAMES[i]]
    label = get_gtk_property(buttons_MainApp[i], :label, String)
    signal_connect(on_clicked_widget, buttons_MainApp[i], "clicked")
    if occursin("Edit", label)
        signal_connect(on_clicked_edit_button, buttons_MainApp[i], "clicked")
    elseif occursin("SaveAs", label)
        signal_connect(on_clicked_screenshot, buttons_MainApp[i], "clicked")
    elseif occursin("Play", label)
        signal_connect(on_clicked_play, buttons_MainApp[i], "clicked")
    elseif occursin("Pause", label)
        signal_connect(on_clicked_pause, buttons_MainApp[i], "clicked")
    elseif occursin("Stop", label)
        signal_connect(on_clicked_stop, buttons_MainApp[i], "clicked")
    end
end

# zmienne wykresu
x = []
y = rand(10)
# println(typeof(y))
abs_sine = abs.(1000*sin.(x/(6.08544*pi)))
stepPlot = Plots.plot(x, abs_sine, label="Data")

# zmienne globalne
active_chart = "PowerSource"
active_title = "Moc źródła [W]"
active_camera = "Everything"
active_color = :blues
active_style = :solid
signal_connect(on_clicked_apply, appSkeleton["ChartApplySettings"], "clicked")
appSettings = GenHydroSettings()

showall(app)

is_running = true
timestep = 1
while is_running
    sleep(1)
    
    if get_gtk_property(app, :visible, String) == "FALSE"
        global is_running = false
    end

    if appSettings.is_played == true
        draw_simulation(appSettings, timestep)
        global timestep = 1
        global x = []
        for i in eachindex(chart_arrays)
            chart_arrays[i] = []
        end
        appSettings.is_played = false
    elseif appSettings.is_paused == true
        
    elseif appSettings.is_stopped == true
        global timestep = 1
        global x = []
        for i in eachindex(chart_arrays)
            chart_arrays[i] = []
        end
        draw_simulation(appSettings, timestep)
        appSettings.is_stopped = false
    end
end
