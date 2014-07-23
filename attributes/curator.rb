
# === CURATOR
#
default.elasticsearch[:curator][:version] = "1.1.3"

# "basic" is just a name so you can create more than one entry
# default.elasticsearch[:curator][:cron][:basic][:action] = :create
# default.elasticsearch[:curator][:cron][:basic][:minute] = '0'
# default.elasticsearch[:curator][:cron][:basic][:hour] = '0'
# default.elasticsearch[:curator][:cron][:basic][:day] = '*'
# default.elasticsearch[:curator][:cron][:basic][:weekday] = '*'
# default.elasticsearch[:curator][:cron][:basic][:month] = '*'
# default.elasticsearch[:curator][:cron][:basic][:command] = 'curator bloom --older-than 1 ; curator close --older-than 15 ; curator optimize --older-than 1 --max_num_segments 1'
