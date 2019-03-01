User.update_attributes(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobarr",
             password_confirmation: "foobarr",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.update_attributes(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end