# Regions

canada = Volunteer.Infrastructure.seed_region!(1, "Canada", nil)

ontario = Volunteer.Infrastructure.seed_region!(2, "Ontario", canada)
british_columbia = Volunteer.Infrastructure.seed_region!(3, "British Columbia", "bc", canada)
_edmonton = Volunteer.Infrastructure.seed_region!(4, "Edmonton", canada)
ottawa = Volunteer.Infrastructure.seed_region!(5, "Ottawa", canada)
_prairies = Volunteer.Infrastructure.seed_region!(6, "Prairies", canada)
_qm = Volunteer.Infrastructure.seed_region!(7, "Quebec and Maritimes", "qm", canada)

# Groups

Volunteer.Infrastructure.seed_group!(1, "Council for Canada", canada)

Volunteer.Infrastructure.seed_group!(2, "Council for Ontario", ontario)
Volunteer.Infrastructure.seed_group!(3, "Education Board Ontario", ontario)
Volunteer.Infrastructure.seed_group!(4, "Health Board (AKHBO) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(5, "ITREB Ontario", ontario)
Volunteer.Infrastructure.seed_group!(6, "Economic Planning Board (EPB) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(7, "Youth & Sports Board (AKYSB) Ontario", ontario)

Volunteer.Infrastructure.seed_group!(8, "Council for British Columbia", british_columbia)
Volunteer.Infrastructure.seed_group!(9, "Community Relations BC", british_columbia)

Volunteer.Infrastructure.seed_group!(10, "Economic Planning Board (EPB) Ottawa", ottawa)
Volunteer.Infrastructure.seed_group!(11, "Social Welfare Board Ottawa", ottawa)

Volunteer.Infrastructure.seed_group!(12, "Ismaili Volunteers BC", british_columbia)
Volunteer.Infrastructure.seed_group!(13, "Quality of Life (QOL) BC", british_columbia)
Volunteer.Infrastructure.seed_group!(14, "Social Welfare Board (SWB) BC", british_columbia)

# Volunteer.Infrastructure.seed_group!(15, "Aga Khan Foundations Canada - World Partnership Walk", ontario)
Volunteer.Infrastructure.seed_group!(16, "Quality of Life (QOL) Ontario", ontario)

Volunteer.Infrastructure.seed_group!(17, "Ismaili Volunteers Canada", canada)
