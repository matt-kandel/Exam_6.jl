mean(x) = sum(x) / length(x)

function surplus_ratio(company::Company)
    A = mean(company.policyholder_surplus)
    B = mean(company.loss_and_LAE_reserves)
    C = mean(company.unearned_premium_reserves)
    D = company.earned_premiums[end]
    return A / (B + C + D)
end    

function allocated_surplus(company::Company, line::Line)
    A = surplus_ratio(company)
    B = mean(line.loss_and_LAE_reserves)
    C = mean(line.unearned_premium_reserves)
    D = line.earned_premiums[end]
    return A * (B + C + D)
end
