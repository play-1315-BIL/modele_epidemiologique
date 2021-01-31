using LambertW

mutable struct DeterministicModelState
    s::Float64
    i::Float64

    function DeterministicModelState(
        s::Float64,
        i::Float64
    )
    new(s, i)
    end
end


mutable struct DeterministicModel
    beta::Float64
    gamma::Float64

    time_step::Float64
    
    state::DeterministicModelState

    history::Array{DeterministicModelState, 1}
    
    function DeterministicModel(
        beta::Float64,
        gamma::Float64,
        initial_i::Float64 = 1e-3,
        time_step::Float64 = 1e-5
    )

        state = DeterministicModelState(1 - initial_i, initial_i)
        history = Array{DeterministicModelState, 1}([])

        new(beta, gamma, time_step, state, history)
    end
end

function increment_time!(model::DeterministicModel)
    push!(model.history, model.state)

    new_s = model.state.s + model.time_step * (-model.beta * model.state.s) * model.state.i
    new_i = model.state.i + model.time_step * (model.beta * model.state.s - model.gamma) * model.state.i

    new_state = DeterministicModelState(new_s, new_i)

    model.state = new_state
end

function r_limit(beta::Float64, gamma::Float64)
    limit = 0
    R_0 = beta/gamma
    if R_0 > 1
        limit = 1 + 1/R_0 * lambertw(-R_0 * exp(-R_0))
    end
    return limit
end





