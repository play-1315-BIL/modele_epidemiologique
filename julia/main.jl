include("markovian_model.jl")
include("deterministic_model.jl")
using Plots

# global parameters
beta = 0.06
gamma = 0.05

# computing theoretical r limit

theoretical_r_limit = r_limit(beta, gamma)


# running deterministic model
time_step = 0.001
initial_i = 0.001
deterministic_model = DeterministicModel(beta, gamma, initial_i, time_step)

number_steps = 500000

for step = 1:number_steps
    increment_time!(deterministic_model)
end

steps = []
s_values = []
i_values = []
r_values = []
r_limit_line = []
for step = 1:size(deterministic_model.history)[1]
    if step%10 == 0
        push!(steps, step*time_step)
        push!(s_values, deterministic_model.history[step].s)
        push!(i_values, deterministic_model.history[step].i)
        push!(r_values, 1 - deterministic_model.history[step].s - deterministic_model.history[step].i)
        push!(r_limit_line, theoretical_r_limit)
    end
end

figure = plot(steps, [s_values, i_values, r_values, r_limit_line], title = "deterministic model", label = ["s" "i" "r" "theoretical r limit"])


# running markovian model
N = 100000
initial_I = 100
markovian_model = MarkovianModel(beta, gamma, initial_I, N)

finished = false

while !finished
    increment_step!(markovian_model)
    global finished = (markovian_model.history[size(markovian_model.history)[1]].I == 0)
end

dates = []
S_values = []
I_values = []
R_values = []
for step = 1:size(markovian_model.history)[1]
    if step%10 == 0
        push!(dates, markovian_model.history[step].t)
        push!(S_values, markovian_model.history[step].S/N)
        push!(I_values, markovian_model.history[step].I/N)
        push!(R_values, (N - markovian_model.history[step].S - markovian_model.history[step].I)/N)
    end
end

plot!(figure, dates, [S_values, I_values, R_values], title = "Deterministic and Markovian models", label = ["S/N" "I/N" "R/N"])

#plot(dates, [S_values, I_values, R_values], title = "Markovian model", label = ["S/N" "I/N" "R/N"])

#savefig(string("figureN_", N, "_initialI_", initial_I, ".png"))
#savefig("markovian.png")


