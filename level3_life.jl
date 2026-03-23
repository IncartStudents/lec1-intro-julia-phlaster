module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function count_neighbors(curr::Matrix{Int}, i::Int, j::Int)::Int
    count = 0
    rows, cols = size(curr)
    
    for di in -1:1, dj in -1:1
        di == 0 && dj == 0 && continue
        
        ni = mod1(i + di, rows)
        nj = mod1(j + dj, cols)
        
        count += curr[ni, nj]
    end
    
    return count
end

function step!(state::Life)
    curr = state.current_frame
    next = state.next_frame
    rows, cols = size(curr)

    for i in 1:rows, j in 1:cols
        neighbors = count_neighbors(curr, i, j)
        cell = curr[i, j]
        
        if cell == 1
            if neighbors < 2 || neighbors > 3
                next[i, j] = 0
            else
                next[i, j] = 1
            end
        else
            if neighbors == 3
                next[i, j] = 1
            else
                next[i, j] = 0
            end
        end
    end

    copy!(curr, next)
    
    return nothing
end

function (@main)(ARGS)
    n = 30
    m = 30
    init = rand(0:1, n, m)

    game = Life(init, zeros(n, m))

    anim = @animate for time = 1:100
        step!(game)
        cr = game.current_frame
        heatmap(cr)
    end
    gif(anim, "life.gif", fps = 10)

    return nothing
end

export main

end

using .GameOfLife
GameOfLife.main("")
