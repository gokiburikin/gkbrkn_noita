local sum = (c.fire_rate_wait + current_reload_time) * 0.5;
c.fire_rate_wait = sum;
current_reload_time = sum;