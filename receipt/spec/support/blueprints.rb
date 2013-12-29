require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end
Item.blueprint do
  description { Faker::Name.name }
  price { 10 }
  quantity { 1 }
end

Order.blueprint do
end