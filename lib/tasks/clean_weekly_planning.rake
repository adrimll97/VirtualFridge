# frozen_string_literal: true

namespace :weekly_planning do
  task clear: :environment do
    User.all.each { |user| WeeklyPlanning.clear_weekly_planning_of_user(user) }
  end
end
