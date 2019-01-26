# Regions

canada = Volunteer.Infrastructure.seed_region!(1, "Canada", nil)

ontario = Volunteer.Infrastructure.seed_region!(2, "Ontario", canada)
_bcolumbia = Volunteer.Infrastructure.seed_region!(3, "British Columbia", "bc", canada)
_edmonton = Volunteer.Infrastructure.seed_region!(4, "Edmonton", canada)
_ottawa = Volunteer.Infrastructure.seed_region!(5, "Ottawa", canada)
_prairies = Volunteer.Infrastructure.seed_region!(6, "Prairies", canada)
_qm = Volunteer.Infrastructure.seed_region!(7, "Quebec and Maritimes", "qm", canada)

# Groups

Volunteer.Infrastructure.seed_group!(1, "Council for Canada", canada)

Volunteer.Infrastructure.seed_group!(2, "Council for Ontario", ontario)
Volunteer.Infrastructure.seed_group!(3, "Aga Khan Education Board Ontario", ontario)
Volunteer.Infrastructure.seed_group!(4, "Aga Khan Health Board (AKHBO) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(5, "ITREB Ontario", ontario)
Volunteer.Infrastructure.seed_group!(6, "Economic Planning Board (EPB) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(7, "Aga Khan Youth & Sports Board (AKYSB) Ontario", ontario)
