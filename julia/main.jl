include("markovian_model.jl")
include("deterministic_model.jl")
using Plots
using LambertW

# global parameters
beta = 0.06
gamma = 0.05


# running deterministic model
time_step = 0.001
initial_i = 0.001
deterministic_model = DeterministicModel(beta, gamma, initial_i, time_step)

number_steps = 1000000

for step = 1:number_steps
    increment_time!(deterministic_model)
end

theoretical_r_limit = 0
R_0 = beta/gamma
if R_0 > 1
    theoretical_r_limit = 1 + 1/R_0 * lambertw(-R_0 * exp(-R_0))
end

steps = []
s_values = []
i_values = []
r_values = []
r_limit = []
for step = 1:size(deterministic_model.history)[1]
    push!(steps, step)
    push!(s_values, deterministic_model.history[step].s)
    push!(i_values, deterministic_model.history[step].i)
    push!(r_values, 1 - deterministic_model.history[step].s - deterministic_model.history[step].i)
    push!(r_limit, theoretical_r_limit)
end

plot(steps, [s_values, i_values, r_values, r_limit], title = "deterministic model", label = ["s" "i" "r" "theoretical r limit"])


# running markovian model
# N = 10000
# initial_I = 1
# markovian_model = MarkovianModel(beta, gamma, initial_I, N)

# number_steps = 100000

# for step = 1:number_steps
#     increment_step!(markovian_model)
# end

# steps = []
# S_values = []
# I_values = []
# R_values = []
# for step = 1:size(markovian_model.history)[1]
#     push!(steps, step)
#     push!(S_values, markovian_model.history[step].S)
#     push!(I_values, markovian_model.history[step].I)
#     push!(R_values, N - markovian_model.history[step].S - markovian_model.history[step].I)
# end

# plot(steps, [S_values, I_values, R_values], title = "Markovian model", label = ["S" "I" "R"])



