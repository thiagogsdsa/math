using Plots

function mandelbrot(c; max_iter=100)
    z = 0 + 0im
    for n = 1:max_iter
        z = z^2 + c
        if abs(z) > 2
            return n
        end
    end
    return max_iter
end

function create_gif_from_folder(folder::String; pattern::String="frame_*.png", delay::Int=10, output::String="output.gif")
    using Glob
    files = sort(glob(pattern, folder))
    imgs = []

    for file in files
        img = load(file)
        push!(imgs, convert(Array{RGB{N0f8}}, img))  # garante 3 canais
    end

    save(output, imgs; fps=1000 ÷ delay)  # `fps` = frames por segundo
end

create_gif_from_folder()