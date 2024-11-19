# For R₁ - Fixed Income, R₂ - Equity, and R₃ - Credit
struct Asset
    dollars::Number
    dollars_from_top_10::Number
    RBC_factor::Float64
    number_of_bond_issuers::Union{Int64, Missing}
end

abstract type Line end

# For R₄ - Reserve Risk based on Table 88 in Odomirok
# I don't like that it's inconsistent with how I've done R₅, but there aren't
# any R₄ problems from past exams to use
struct Line₄ <: Line
    industry_average_loss_and_alae_development_ratio::Number
    company_average_loss_and_alae_development_ratio::Number # For prior 9 years 
    industry_loss_and_lae_RBC_percentage::Number
    adjustment_for_investment_income::Number
    net_loss_and_lae_reserves::Number # Gross of non-tabular discount
    other_discounts::Number
    percent_of_written_premium_on_direct_loss_sensitive::Number
    percent_of_written_premium_on_assumed_loss_sensitive::Number
end

# For R₅ - Premium Risk
struct Line₅ <: Line
    direct_premiums::Vector{Number}
    net_premiums::Vector{Number}
    underwriting_expense_ratio::Number
    percent_of_written_premium_on_direct_loss_sensitive::Number
    percent_of_written_premium_on_assumed_loss_sensitive::Number
    industry_average_loss_ratio::Number
    industry_loss_ratio::Number
    adjustment_for_investment_income::Number
    loss_ratios::Vector{Number}
end