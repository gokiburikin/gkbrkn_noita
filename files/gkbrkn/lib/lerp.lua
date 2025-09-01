function lerp( f, t, p ) return f + (t - f) * p end
function inverse_lerp( f, t, p ) return (p - f) / (t - f) end
function remap( p, f1, t1, f2, t2 ) return lerp(f2, t2, inverse_lerp(f1,t1,p)) end