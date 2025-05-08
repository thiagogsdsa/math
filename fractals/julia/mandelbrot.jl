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

function generate_fractal(xmin, xmax, ymin, ymax, res, max_iter)
    x = range(xmin, xmax; length=res)
    y = range(ymin, ymax; length=res)
    image = zeros(Int, res, res)
    for i in 1:res, j in 1:res
        c = complex(x[j], y[i])
        image[i, j] = mandelbrot(c; max_iter=max_iter)
    end
    return image
end

img = generate_fractal(-2.0, 1.0, -1.5, 1.5, 500, 100)
heatmap(img, color=:viridis, legend=false)