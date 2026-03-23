module Boids
using Plots

export main

mutable struct Boid
    pos::Tuple{Float64, Float64}
    vel::Tuple{Float64, Float64}
    acc::Tuple{Float64, Float64}
    view_radius::Float64
end

mutable struct WorldState
    boids::Vector{Boid}
    height::Float64
    width::Float64

    separation_weight::Float64
    alignment_weight::Float64
    cohesion_weight::Float64
    max_speed::Float64
    max_force::Float64
    
    function WorldState(n_boids, width, height; 
                        view_radius=20.0,
                        separation_weight=1.2,
                        alignment_weight=1.5,
                        cohesion_weight=0.8,
                        max_speed=1.5,
                        max_force=0.1)
        boids = [Boid(
            (rand() * width, rand() * height),
            (randn() * 0.5, randn() * 0.5),
            (0.0, 0.0),
            view_radius
        ) for _ in 1:n_boids]
        
        new(boids, Float64(height), Float64(width),
            separation_weight, alignment_weight, cohesion_weight,
            max_speed, max_force)
    end
end

@inline vec_add(a::Tuple, b::Tuple) = (a[1] + b[1], a[2] + b[2])
@inline vec_sub(a::Tuple, b::Tuple) = (a[1] - b[1], a[2] - b[2])
@inline vec_scale(a::Tuple, s::Real) = (a[1] * s, a[2] * s)
@inline vec_norm(a::Tuple) = sqrt(a[1]^2 + a[2]^2)

@inline function vec_normalize(a::Tuple)
    n = vec_norm(a)
    return n < 1e-6 ? (0.0, 0.0) : (a[1]/n, a[2]/n)
end

@inline function vec_limit(a::Tuple, max_val::Real)
    n = vec_norm(a)
    return n > max_val ? vec_scale(a, max_val / n) : a
end


@inline function toroidal_distance(a::Tuple, b::Tuple, width::Float64, height::Float64)
    dx = min(abs(a[1] - b[1]), width - abs(a[1] - b[1]))
    dy = min(abs(a[2] - b[2]), height - abs(a[2] - b[2]))
    return sqrt(dx^2 + dy^2)
end


function rule_separation(boid::Boid, boids::Vector{Boid}, width::Float64, height::Float64, desired_separation::Float64)
    steer = (0.0, 0.0)
    count = 0
    
    for other in boids
        other === boid && continue
        d = toroidal_distance(boid.pos, other.pos, width, height)
        if 0 < d < desired_separation
            diff = vec_sub(boid.pos, other.pos)
            diff = vec_scale(diff, 1.0 / d)
            steer = vec_add(steer, diff)
            count += 1
        end
    end
    
    count > 0 && (steer = vec_scale(steer, 1.0 / count))
    vec_norm(steer) > 0 && (steer = vec_limit(vec_normalize(steer), 0.1))
    
    return steer
end

function rule_alignment(boid::Boid, boids::Vector{Boid}, width::Float64, height::Float64, neighbor_dist::Float64)
    sum_vel = (0.0, 0.0)
    count = 0
    
    for other in boids
        other === boid && continue
        d = toroidal_distance(boid.pos, other.pos, width, height)
        if d < neighbor_dist
            sum_vel = vec_add(sum_vel, other.vel)
            count += 1
        end
    end
    
    if count > 0
        avg_vel = vec_scale(sum_vel, 1.0 / count)
        avg_vel = vec_normalize(avg_vel)
        avg_vel = vec_scale(avg_vel, 2.0)  # Желаемая скорость
        steer = vec_sub(avg_vel, boid.vel)
        return vec_limit(steer, 0.1)
    end
    
    return (0.0, 0.0)
end

function rule_cohesion(boid::Boid, boids::Vector{Boid}, width::Float64, height::Float64, neighbor_dist::Float64)
    sum_pos = (0.0, 0.0)
    count = 0
    
    for other in boids
        other === boid && continue
        d = toroidal_distance(boid.pos, other.pos, width, height)
        if d < neighbor_dist
            sum_pos = vec_add(sum_pos, other.pos)
            count += 1
        end
    end
    
    if count > 0
        center = vec_scale(sum_pos, 1.0 / count)
        desired = vec_sub(center, boid.pos)
        desired = vec_normalize(desired)
        desired = vec_scale(desired, 2.0)
        steer = vec_sub(desired, boid.vel)
        return vec_limit(steer, 0.1)
    end
    
    return (0.0, 0.0)
end


function update_boid!(boid::Boid, boids::Vector{Boid}, width::Float64, height::Float64, 
                      sep_w::Float64, align_w::Float64, coh_w::Float64,
                      max_speed::Float64, max_force::Float64)
    
    sep = rule_separation(boid, boids, width, height, 2.0)
    align = rule_alignment(boid, boids, width, height, 3.0)
    coh = rule_cohesion(boid, boids, width, height, 3.0)
    
    force = vec_add(vec_add(vec_scale(sep, sep_w), vec_scale(align, align_w)), vec_scale(coh, coh_w))
    force = vec_limit(force, max_force)
    
    boid.acc = vec_add(boid.acc, force)
    boid.vel = vec_add(boid.vel, boid.acc)
    boid.vel = vec_limit(boid.vel, max_speed)
    boid.pos = vec_add(boid.pos, boid.vel)
    
    boid.acc = (0.0, 0.0)
    boid.pos = (mod1(boid.pos[1], width), mod1(boid.pos[2], height))
    
    return nothing
end

function update!(state::WorldState)
    for boid in state.boids
        update_boid!(boid, state.boids, state.width, state.height,
                    state.separation_weight, state.alignment_weight, state.cohesion_weight,
                    state.max_speed, state.max_force)
    end
    return nothing
end

function (@main)(ARGS)
    w = 150.0
    h = 150.0
    n_boids = 100


    state = WorldState(n_boids, w, h)

    anim = @animate for time = 1:300
        update!(state)
        xs = [b.pos[1] for b in state.boids]
        ys = [b.pos[2] for b in state.boids]
        vxs = [b.vel[1] for b in state.boids]
        vys = [b.vel[2] for b in state.boids]
        quiver(xs, ys, 
               quiver=(vxs, vys),
               xlim = (0, w), ylim = (0, h),
               color = :black,
               legend = false, 
               axis = false,
               grid = false,
               linewidth = 1,
               arrow = :closed,
               size = (1000, 800)
        )
    end
    gif(anim, "boids.gif", fps = 30)
    return nothing
end

end

using .Boids
Boids.main("")