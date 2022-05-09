module Oscillators

mutable struct Oscillator
    sample_rate::UInt16
    freq::UInt16
    phase::UInt16
    amp::UInt8
    wave_type::String
    wave_size::(min::Float32, max::Float32)
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

