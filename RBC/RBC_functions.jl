mean(x) = sum(x) / length(x)

# R₁ - Fixed Income & R₂ - Equity
basic_charge(a::Asset) = a.dollars * a.RBC_factor
bond_size_charge(a::Asset) = (bond_size_factor(a) - 1) * basic_charge(a)
asset_concentration_charge(a::Asset) = a.dollars_from_top_10 * a.RBC_factor

function bond_size_factor(a::Asset)
    n = a.number_of_bond_issuers
    first_50 = clamp(0, n, 50)
    next_50  = clamp(0, n - 50, 50)
    next_300 = clamp(0, n - 100, 300)
    more_than_400 = maximum([n - 400, 0])
    numbers = [first_50, next_50, next_300, more_than_400]   
    @assert sum(numbers) == n
    weights = [2.5, 1.3, 1, .9]
    sum(weights .* numbers) / n
end

# Might also need to distribute reinsurance risk 50/50 between R₃ and R₄
R₁(a::Asset) = basic_charge(a) + bond_size_charge(a) + asset_concentration_charge(a)
R₂(a::Asset) = basic_charge(a) + asset_concentration_charge(a)
R₃(a::Asset) = basic_charge(a)
R₄(line::Line) = base_R₄(line) * (1 - loss_sensitive_factor(line))
R₅(line::Line) = base_R₅(line) * (1 - loss_sensitive_factor(line))

function R₄(lines::Vector{<:Line})
    sum(R₄.(lines)) * concentration_factor(lines) + excess_growth_charge(lines)
end

function R₅(lines::Vector{<:Line})
    sum(R₅.(lines)) * concentration_factor(lines) + excess_growth_charge(lines)
end        

function base_R₅(line::Line)
    A = line.net_premiums[end]
    B = adjusted_company_loss_ratio(line)
    C = line.adjustment_for_investment_income
    D = min(line.underwriting_expense_ratio, 4)
    A * (B * C + D - 1)
end

function adjusted_company_loss_ratio(line::Line)
    A = line.industry_loss_ratio
    # Average company loss ratios (each year capped at 300%)
    B = min.(line.loss_ratios, 3) |> mean
    C = line.industry_average_loss_ratio
    .5 * A * (1 + B / C)
end

# function adjustment_for_company_experience(line::Line₅) end        

function loss_sensitive_factor(line::Line)
    A = line.percent_of_written_premium_on_direct_loss_sensitive
    B = line.percent_of_written_premium_on_assumed_loss_sensitive
    .3 * A + .15 * B
end                

concentration_factor(x) = .7 + .3 * maximum(x) / sum(x)

function concentration_factor(lines::Vector{Line₅})
    concentration_factor(line.net_premiums[end] for line in lines)
end

function concentration_factor(lines::Vector{Line₄})
    concentration_factor(line.net_loss_and_lae_reserves[end] for line in lines)
end

function excess_growth_rate(lines::Vector{<:Line})
    # Growth rate is over last 3 years, capped at 40%
    premiums = sum(line.direct_premiums for line in lines)
    premiums = premiums[end-3:end]
    growth_rates = premiums[2:end] ./ premiums[1:end-1] .- 1
    growth_rates = min.(growth_rates, .4) 
    mean(growth_rates) - .1
end

excess_growth_factor(lines::Vector{Line₄}) = .45
excess_growth_factor(lines::Vector{Line₅}) = .225

function excess_growth_charge(lines::Vector{<:Line})
    premiums = sum(line.net_premiums for line in lines)
    excess_growth_factor(lines) * excess_growth_rate(lines) * premiums[end] 
end

function base_R₄(line::Line)
    A = adjusted_company_RBC_percentage(line)
    B = line.adjustment_for_investment_income
    C = line.net_loss_and_lae_reserves
    D = line.other_discounts
    ((A + 1) * B - 1) * (C + D)
end

function adjusted_company_RBC_percentage(line::Line₄)
    A = line.industry_loss_and_lae_RBC_percentage
    B = line.company_average_loss_and_alae_development_ratio
    C = line.industry_average_loss_and_alae_development_ratio
    .5 * A * (1 + (B / C))
end