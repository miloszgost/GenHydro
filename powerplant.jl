# liczba moli w 1 normalnym metrze sześciennym
# MOL_COUNT_PER_NM3 = 44.617516
# HYDROGEN_BURN_VALUE = 285.8 # kJ/mol

# ------------------------------

function current_input_power(x::Vector)
    last_x = last(x)
    equation = abs(appSettings.input_power*cos(last_x/(6.08544*pi)))
    # equation = abs(appSettings.input_power*cos(last_x/(6.08544*pi)))/sqrt((0.1*last_x)/(6.08544*pi))
    equation *= appSettings.input_efficiency/100
    return equation
end

function current_receiver_power(x::Vector)
    last_x = last(x)
    equation = appSettings.receiver_power
    return equation
end

function current_balance_power(x::Vector)
    equation = current_input_power(x) - current_receiver_power(x)
    return equation
end

function current_balance_power_overall(x::Vector)
    current_power_fuelcell = (current_hydrogen_burn(x)/appSettings.hydrogen_burn_rate_per_minute
    * appSettings.fuelcell_power * (appSettings.fuelcell_efficiency/100))
    current_power_electrolizer = (current_hydrogen_production(x)/appSettings.hydrogen_production_per_minute
    * appSettings.electrolizer_power * (appSettings.electrolizer_efficiency/100))
    equation = current_balance_power(x) + current_power_electrolizer - current_power_fuelcell 
    return equation
end

function current_hydrogen_production(x::Vector)
    balance_power = current_balance_power(x)

    if balance_power > appSettings.electrolizer_power
        equation = appSettings.hydrogen_production_per_minute
    elseif 0 < balance_power && balance_power <= appSettings.electrolizer_power
        equation = appSettings.hydrogen_production_per_minute * (balance_power / appSettings.electrolizer_power)
    else
        equation = 0
    end
    
    return equation
end

function current_hydrogen_burn(x::Vector)
    
    balance_power = current_balance_power(x)
    if balance_power < 0 && balance_power < -(appSettings.fuelcell_power)
        equation = appSettings.hydrogen_burn_rate_per_minute
    elseif balance_power < 0
        equation = appSettings.hydrogen_burn_rate_per_minute * (abs(balance_power) / appSettings.fuelcell_power)
    else
        equation = 0
    end
    
    return equation
end

function current_hydrogen_balance(x::Vector)
    
    hydrogen_production = chart_arrays[5]
    hydrogen_burn = chart_arrays[6]

    equation = sum(first(hydrogen_production, length(x))) - sum(first(hydrogen_burn, length(x)))

    return equation
end


