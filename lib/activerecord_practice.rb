require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  
    Customer.where(first:'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE ?", "%@%")
  end

  def self.with_dot_org_email
    Customer.where("email LIKE ?", "%.org")
  end

  def self.with_invalid_email
    Customer.where("email not LIKE ?", "%@%")
  end

  def self.with_blank_email
    Customer.where(email:['', nil])
  end

  def self.born_before_1980
    Customer.where("birthdate < ?", "1980-01-01".to_date)
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("birthdate < ?", "1980-01-01".to_date).where("email like ?", "%@%")
  end

  def self.last_names_starting_with_b
    Customer.where("last like ?", "B%").order(:birthdate)
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    user = Customer.where(first: "Gussie").where(last: "Murray")
                   .update(birthdate: Time.parse("2004-02-08"))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email not LIKE ?", "%@%").update(email: "")
  end

  def self.delete_meggie_herman
    Customer.where(first: "Meggie").where(last: "Herman").destroy_all
  end
  
  def self.delete_everyone_born_before_1978
    Customer.where("birthdate <= ?", "1977-12-31".to_date).destroy_all
  end
  # etc. - see README.md for more details
end
