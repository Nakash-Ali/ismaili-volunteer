# Regions

canada = Volunteer.Infrastructure.seed_region!(1, "Canada", nil)

ontario = Volunteer.Infrastructure.seed_region!(2, "Ontario", canada)
british_columbia = Volunteer.Infrastructure.seed_region!(3, "British Columbia", "bc", canada)
_edmonton = Volunteer.Infrastructure.seed_region!(4, "Edmonton", canada)
ottawa = Volunteer.Infrastructure.seed_region!(5, "Ottawa", canada)
prairies = Volunteer.Infrastructure.seed_region!(6, "Prairies", canada)
_qm = Volunteer.Infrastructure.seed_region!(7, "Quebec and Maritimes", "qm", canada)

# Groups

Volunteer.Infrastructure.seed_group!(1, "Council for Canada", canada)

Volunteer.Infrastructure.seed_group!(2, "Council for Ontario", ontario)
Volunteer.Infrastructure.seed_group!(3, "Education Board Ontario", ontario)
Volunteer.Infrastructure.seed_group!(4, "Health Board Ontario", ontario)
Volunteer.Infrastructure.seed_group!(5, "ITREB Ontario", ontario)
Volunteer.Infrastructure.seed_group!(6, "Economic Planning Board (EPB) Ontario", ontario)
Volunteer.Infrastructure.seed_group!(7, "Youth & Sports Board (AKYSB) Ontario", ontario)

Volunteer.Infrastructure.seed_group!(8, "Council for British Columbia", british_columbia)
Volunteer.Infrastructure.seed_group!(9, "Community Relations BC", british_columbia)

Volunteer.Infrastructure.seed_group!(10, "Economic Planning Board (EPB) Ottawa", ottawa)
Volunteer.Infrastructure.seed_group!(11, "Social Welfare Board Ottawa", ottawa)

Volunteer.Infrastructure.seed_group!(12, "Ismaili Volunteers BC", british_columbia)
Volunteer.Infrastructure.seed_group!(13, "Quality of Life (QoL) BC", british_columbia)
Volunteer.Infrastructure.seed_group!(14, "Social Welfare Board (SWB) BC", british_columbia)

Volunteer.Infrastructure.seed_group!(15, "World Partnership Walk Ontario", ontario)
Volunteer.Infrastructure.seed_group!(16, "Quality of Life (QoL) Ontario", ontario)

Volunteer.Infrastructure.seed_group!(17, "Ismaili Volunteers Canada", canada)

Volunteer.Infrastructure.seed_group!(18, "Legal Prairies", prairies)
Volunteer.Infrastructure.seed_group!(19, "Settlement Prairies", prairies)
Volunteer.Infrastructure.seed_group!(20, "Community Relations Prairies", prairies)
Volunteer.Infrastructure.seed_group!(21, "Resource Mobilization Prairies", prairies)
Volunteer.Infrastructure.seed_group!(22, "JK Development and Maintenance Prairies", prairies)
Volunteer.Infrastructure.seed_group!(23, "Ismaili Transportation Committee Prairies", prairies)
Volunteer.Infrastructure.seed_group!(24, "Catering Prairies", prairies)
Volunteer.Infrastructure.seed_group!(25, "Ismaili Volunteers Corp (IVC) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(26, "Women's Portfolio Prairies", prairies)
Volunteer.Infrastructure.seed_group!(27, "Ismaili Volunteers (IV) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(28, "Arts & Culture Prairies", prairies)
Volunteer.Infrastructure.seed_group!(29, "Audio Visual (AV) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(30, "Finance Prairies", prairies)
Volunteer.Infrastructure.seed_group!(31, "Planning, Priorities & Evaluation Prairies", prairies)
Volunteer.Infrastructure.seed_group!(32, "Care for the Elderly Prairies", prairies)
Volunteer.Infrastructure.seed_group!(33, "Social Welfare Board (SWB) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(34, "Education Board Prairies", prairies)
Volunteer.Infrastructure.seed_group!(35, "Youth & Sports Board (AKYSB) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(36, "Health Board Prairies", prairies)
Volunteer.Infrastructure.seed_group!(37, "Economic Planning Board (EPB) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(38, "Quality of Life (QoL) Prairies", prairies)
Volunteer.Infrastructure.seed_group!(39, "Communications Prairies", prairies)
