# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

USER_COUNT = 20

admin_email = 'admin@example.com'

User.create!(email: admin_email, password: 'pass')
profile = Profile.create!(email: admin_email, is_coordinator: true, full_name: "Admin", nick_name: 'admin')

p = Project.create!(name: 'Voluntari app', owner: profile)

ProjectMember.create!(project: p, profile: profile, role: 'Coordonator')

user_email = 'user@example.com'

User.create!(email: user_email, password: 'pass')
user_profile = Profile.create!(email: user_email, is_volunteer: true, full_name: "User", nick_name: 'user')
ProjectMember.create!(project: p, profile: user_profile, role: 'Developer')

USER_COUNT.times do
  email = Faker::Internet.email
  User.create!(email: email, password: 'pass')
  idx = rand(3)

  profile = Profile.create!(email: email,
                            is_coordinator: idx == 2,
                            is_volunteer: idx == 1,
                            is_applicant: idx == 0,
                            full_name: Faker::Name.name,
                            nick_name: Faker::Internet.user_name)

  if profile.is_coordinator?
    p = Project.create!(name: Faker::Book.title, owner: profile, status: 0)
    ProjectMember.create!(project: p, profile: profile, role: 'Coordonator')
  end
end
