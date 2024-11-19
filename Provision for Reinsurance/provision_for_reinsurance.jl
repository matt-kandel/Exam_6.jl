struct Reinsurer
    late_undisputed_recoverables::Number
    unpaid_recoverables::Number
    collateral::Number
    late_payments::Number
    unpaid_undisputed_recoverables::Number
    recently_paid::Number
    disputed_unpaid_recoverables::Number
end

function slow_pay_ratio(r::Reinsurer)
    A = r.late_undisputed_recoverables
    B = r.unpaid_undisputed_recoverables
    C = r.recently_paid
    return A / (B + C)
end

function authorized_provision_for_reinsurance(r::Reinsurer)
    A = r.late_payments
    B = r.unpaid_recoverables
    C = r.collateral
    D = minimum([B, C]) # unsecured_recoverables

    if slow_pay_ratio(r) < 0.2 # fast payers
        return 0.2 * A
    else  # slow payers
        return 0.2 * maximum([(B - D), A])
    end
end

function unauthorized_provision_for_reinsurance(r::Reinsurer)
    A = r.late_undisputed_recoverables
    B = r.unpaid_recoverables
    C = r.collateral
    D = r.disputed_unpaid_recoverables
    return B - C + .2 * (A + D)
end