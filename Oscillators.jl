module Oscillators

mutable struct Oscillator
    sample_rate::UInt16
    freq::Float64
	#Phase is in degrees
    phase::UInt16
    amp::Float64
    wave_limits::Tuple{Float64, Float64}
    modulators::Vector
end

mutable struct Envelope
    mod_target
    attack
    decay
    #sustain - defined by the actual note that is modified by the envelope
    release
end

mutable struct Stepper
    mod_target
    step_values::Vector
    step_length
end

"""
Generate a sine wave at the given frequency for the appropriate duration (given in seconds) at the oscillator's sample rate
"""
function generate_sine(osc::Oscillator, len::Float64)
    t = 0.0:len/osc.sample_rate:prevfloat(len)
    phase = (osc.phase / 360) * 2pi
    amp_vals = sin.((2pi * osc.freq * t) .+ phase) * osc.amp
    clamp!(amp_vals, osc.wave_limits[1], osc.wave_limits[2])
    return amp_vals
end

"""
Generate a square wave at the given frequency for the appropriate duration (given in seconds) at the oscillator's sample rate
"""
function generate_square(osc::Oscillator, len::Float64)
    t = 0.0:len/osc.sample_rate:prevfloat(len)
	phase = (osc.phase / 360) * 2pi
    sin_amp = sin.((2pi * osc.freq * t) .+ phase) * osc.amp
    get_square(amp) = amp < 0 ? -1 * osc.amp : osc.amp
    amp_vals = get_square.(sin_amp)
    return amp_vals
end

"""
Generate a pulse wave at the given frequency for the appropriate duration (given in seconds) at the oscillator's sample rate

### Keywords
`length` is the length of the generated samples in seconds

`width` is the proportion of the wave that is at the higher amplitude in the pulse. A `width` of 1 corresponds with a square wave - make it higher for a longer pulse and lower for a shorter pulse.
"""
function generate_pulse(osc::Oscillator, len::Float64, width::Float64)
	t = 0.0:len/osc.sample_rate:prevfloat(len)
    sin_amp = sin.((2pi * osc.freq * t) .+ phase) * osc.amp
	threshold = (1 - width) * osc.amp
    get_pulse(amp) = amp < threshold ? -1 * osc.amp : osc.amp
    amp_vals = get_pulse.(sin_amp)
    return amp_vals
end

function generate_triangle(osc::Oscillator, len::Float64)
end

function generate_saw(osc::Oscillator, len::Float64)
end

