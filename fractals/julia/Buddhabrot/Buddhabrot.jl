using Plots
using ColorSchemes   # for colormaps
using Printf         # for @sprintf
using ProgressMeter  # for progress bar
using Images, ImageView

# ---------- Mandelbrot orbit escape ----------
function mandelbrot_orbit(c::ComplexF64, max_iter::Int)
    z = 0.0 + 0.0im
    orbit = ComplexF64[]
    for i in 1:max_iter
        z = z*z + c
        push!(orbit, z)
        if abs(z) > 2
            return orbit, i
        end
    end
    return nothing, nothing
end

# ---------- Buddhabrot main loop ----------
function buddhabrot(; width=800, height=800,
                    samples=1_000_000, max_iter=1000,
                    save_every=250_000,
                    cmap="inferno",
                    output_dir="img")
    # Complex plane bounds
    re_min, re_max = -2.0, 1.0
    im_min, im_max = -1.5, 1.5

    # Initialize accumulation arrays
    img = zeros(Float64, height, width)
    counts = zeros(Float64, height, width)

    # Ensure output directory exists
    mkpath(output_dir)
    saved = 0

    # Progress bar
    @showprogress for i in 1:samples
        # Sample random complex point
        c = complex(rand()*(re_max - re_min) + re_min,
                    rand()*(im_max - im_min) + im_min)
        orbit, esc_iter = mandelbrot_orbit(c, max_iter)
        if orbit === nothing
            continue
        end
        weight = 1.0/(esc_iter + 1)

        # Accumulate orbit visits
        for z in orbit
            x = Int(floor((real(z)-re_min)/(re_max-re_min)*(width-1))) + 1
            y = Int(floor((imag(z)-im_min)/(im_max-im_min)*(height-1))) + 1
            if 1 ≤ x ≤ width && 1 ≤ y ≤ height
                img[y, x] += weight
                counts[y, x] += 1
            end
        end

        # Save frame periodically
        if i % save_every == 0
            # Normalize and gamma correction
            norm_img = img ./ (counts .+ 1e-9)
            norm_img .^= 0.4

            # Rotate 90° clockwise
            rotated_img = reverse(permutedims(norm_img), dims=1)

            # Plot with dark background
            theme(:dark)
            heatmap(rotated_img;
                    color=cgrad(ColorSchemes.magma),
                    axis=nothing,
                    frame=:none,
                    legend=false,
                    background_color=:black,
                    foreground_color_subplot=:white,
                    size=(800,800))

            # Save to output directory
            filename = joinpath(output_dir, @sprintf("%03d.png", saved+1))
            savefig(filename)
            saved += 1
        end
    end

    return img
end

# Example usage:
#buddhabrot(samples=8_000_000, save_every=20_000, cmap="plasma")
