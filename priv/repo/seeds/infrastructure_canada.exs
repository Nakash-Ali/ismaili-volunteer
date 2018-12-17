# Regions

canada = Volunteer.Infrastructure.seed_region!(1, "Canada", nil)

ontario = Volunteer.Infrastructure.seed_region!(2, "Ontario", canada)
ontario = Volunteer.Infrastructure.seed_region!(3, "British Columbia", "bc", canada)

# Groups

Volunteer.Infrastructure.seed_group!(1, "Council for Canada", canada)

Volunteer.Infrastructure.seed_group!(2, "Council for Ontario", ontario)
Volunteer.Infrastructure.seed_group!(3, "Aga Khan Education Board Ontario", ontario)
Volunteer.Infrastructure.seed_group!(4, "Aga Khan Health Board (AKHBO) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(5, "ITREB Ontario", ontario)
Volunteer.Infrastructure.seed_group!(6, "Economic Planning Board (EPB) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(7, "Aga Khan Youth & Sports Board (AKYSB) Ontario", ontario)
