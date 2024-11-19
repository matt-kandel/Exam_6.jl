# assuming all vectors are ordered as [prior_year, current_year]
struct Line
    loss_and_LAE_reserves::Vector{Number}
    unearned_premium_reserves::Vector{Number}
    earned_premiums::Vector{Number}
end

struct Company
    policyholder_surplus::Vector{Number}
    loss_and_LAE_reserves::Vector{Number}
    unearned_premium_reserves::Vector{Number}
    earned_premiums::Vector{Number}
    lines::Vector{Line}
end