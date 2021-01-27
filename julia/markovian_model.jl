mutable struct MarkovianModelState
    S::Int64
    I::Int64

    function MarkovianModelState(
        S::Int64,
        I::Int64
    )
    new(S, I)
    end
end


mutable struct MarkovianModel
    beta::Float64
    gamma::Float64

    N::Int64
    
    state::MarkovianModelState

    history::Array{MarkovianModelState, 1}
    
    function MarkovianModel(
        beta::Float64,
        gamma::Float64,
        initial_I::Int64,
        N::Int64
    )

        state = MarkovianModelState(N-initial_I, initial_I)
        history = Array{MarkovianModelState, 1}([])

        new(beta, gamma, N, state, history)
    end
end

function increment_step!(model::MarkovianModel)
    push!(model.history, model.state)

    if model.state.I != 0
        roll = rand()
        if roll < model.gamma/(model.gamma + model.beta * model.state.S / model.N)
            new_S = model.state.S
            new_I = model.state.I - 1

            model.state = MarkovianModelState(new_S, new_I)
        else
            new_S = model.state.S - 1
            new_I = model.state.I + 1

            model.state = MarkovianModelState(new_S, new_I)
        end
    end
end





