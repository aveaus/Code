Dispatcher
==========
### Introduction
The coding challenge had a lot of of requirements and not enough example data. So as I was trying to just create a front-end, I've decided to go the extra steps to:
* use Rails 3 framework & gems
* create data models for Properties and Geofence
* add additional property types and randomized data
* integrate Bootstrap to front-end
* reverse geocoding the search address

### How to Start
This should generate 10 randomized examples of 'maxDispatchDistance', 'maxFuelSurcharge', 'maxWaitTime'. Also, Google geocoding is setup for `localhost` right now (ie. no API key is provided)

`$ bundle install`

`$ rake db:migrate`

`$ rails server`

`http://localhost:3000`


### Potential Improvements
* could've used a JS framework like Backbone, but I felt it was a little too heavy-handed for this purpose
* I would have loved to add some front-end JS templating technology like Handlebars, so I don't have to return the rendered HTML, but I also don't want to have a HAML template and a separate JS template for render the page. (maybe use server-side templating or compiling Haml to JS template)
* use Machinist to further simplify Rspec test
* could've used more thorough testing and validation for bad data input
* I wanted to use a calendar UI for the front-end, but couldn't find a suitable opensource one
* integrate with Google map, so each property and its boundary are overlayed on top of the map and create a better visual of the size and impact of each property


### Tech Stack & Explanation
* Ruby 1.9.3
* Rails 3.2.13: routes, ORM, asset pipeline that compiles SASS and Coffescript to css/js
* Forgery: extended to create
  1. randomized polygon (only implemented square in my code)
  2. random decimal number
  3. random time range
  4. additional Properties ("maxFuelSurcharge", "maxWaitTime")
* SQLite3: not production ready, could've used Postgres
* Seed data: used migration script to create a list of properties
  1. create random Properties centered around San Francisco
  2. created random Geofence for each property that has random size and center
* Rspec: for TDD of model and controller
* Ray casting (Even-odd rule) algorithm: for determine whether a point is contained in a polygon
* Bootstrap: for responsive design and nice UI elements
* Haml: write cleaner markup
* Reverse Geocoding using Google: allow user to search for an address and find properties associated with that lat-lng coordinate
