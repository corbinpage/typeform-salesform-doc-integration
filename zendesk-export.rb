require 'typeform'
require 'restforce'
require 'zendesk_api'

require "pry"


def define_client

  client = ZendeskAPI::Client.new do |config|
  # Mandatory:

  config.url = "https://audicus.zendesk.com/api/v2" # e.g. https://mydesk.zendesk.com/api/v2

  # Basic / Token Authentication
  config.username = "drew@audicus.com"

  # Choose one of the following depending on your authentication choice
  config.token = '4G7Axxb1QuKGKgVs3R8WVNApSfHXq5PAPqL9BWuj'
  config.password = "Yahoo987!"

  # OAuth Authentication
  # config.access_token = "your OAuth access token"

  # Optional:

  # Retry uses middleware to notify the user
  # when hitting the rate limit, sleep automatically,
  # then retry the request.
  config.retry = true

  # Logger prints to STDERR by default, to e.g. print to stdout:
  require 'logger'
  config.logger = Logger.new(STDOUT)

  # Changes Faraday adapter
  # config.adapter = :patron

  # Merged with the default client options hash
  # config.client_options = { :ssl => false }

  # When getting the error 'hostname does not match the server certificate'
  # use the API at https://yoursubdomain.zendesk.com/api/v2
end
client
end

def first_row
  ["Summation column",
    "Id",
    "Requester",
    "Requester id",
    "Requester external id",
    "Requester email",
    "Requester domain",
    "Submitter",
    "Assignee",
    "Group",
    "Subject",
    "Tags",
    "Status",
    "Priority",
    "Via",
    "Ticket type",
    "Created at",
    "Updated at",
    "Assigned at",
    "Organization",
    "Due date",
    "Initially assigned at",
    "Solved at",
    "Resolution time",
    "Satisfaction Score",
    "Group stations",
    "Assignee stations",
    "Reopens",
    "Replies",
    "First reply time in minutes",
    "First reply time in minutes within business hours",
    "First resolution time in minutes",
    "First resolution time in minutes within business hours",
    "Full resolution time in minutes",
    "Full resolution time in minutes within business hours",
    "Agent wait time in minutes",
    "Agent wait time in minutes within business hours",
    "Requester wait time in minutes",
    "Requester wait time in minutes within business hours",
    "On hold time in minutes",
    "On hold time in minutes within business hours",
    "Ticket Category [list]",
    "Status [list]"]
  end


  def format_row(ticket, i)
    row = []
    metrics = ticket.metrics
    requester = ticket.requester

    row << i+1                                                                # Summation column
    row << ticket["id"]                                                       # Id
    row << requester["name"]                                                  # Requester
    row << requester["id"]                                                    # Requester id
    row << requester["external_id"]                                           # Requester external id
    row << requester["email"]                                                 # Requester email
    row << requester["email"].to_s.gsub(/.+@/,"")                             # Requester domain
    row << ticket.submitter["name"]                                          # Submitter
    row << ticket.assignee["name"]                                             # Assignee
    row << ticket.group["name"]                                               # Group
    row << ticket["subject"]                                                  # Subject
    row << ticket["tags"].join(',')                                           # Tags
    row << ticket["status"]                                                   # Status
    row << ticket["priority"]                                                 # Priority
    row << ticket["via"]["channel"]                                           # Via
    row << ticket["type"]                                                     # Ticket type
    row << ticket["created_at"]                                               # Created at
    row << ticket["updated_at"]                                               # Updated at
    row << ticket.metrics["assigned_at"]                                      # Assigned at
    row << ticket["organization_id"]                                          # Organization
    row << ticket["due_at"]                                                   # Due date
    row << ticket.metrics["initially_assigned_at"]                            # Initially assigned at
    row << metrics["solved_at"]                                               # Solved at
    row << ""                                 # Resolution time
    row << ticket["satisfaction_rating"]["score"]                             # Satisfaction Score
    row << metrics["group_stations"]                                          # Group stations
    row << metrics["assignee_stations"]                                       # Assignee stations
    row << metrics["reopens"]                                                 # Reopens
    row << metrics["replies"]                                                 # Replies
    row << metrics["reply_time_in_minutes"]["calendar"]                       # First reply time in minutes
    row << metrics["reply_time_in_minutes"]["business"]                       # First reply time in minutes within business hours
    row << metrics["first_resolution_time_in_minutes"]["calendar"]            # First resolution time in minutes
    row << metrics["first_resolution_time_in_minutes"]["business"]            # First resolution time in minutes within business hours
    row << metrics["full_resolution_time_in_minutes"]["calendar"]             # Full resolution time in minutes
    row << metrics["full_resolution_time_in_minutes"]["business"]             # Full resolution time in minutes within business hours
    row << metrics["agent_wait_time_in_minutes"]["calendar"]                  # Agent wait time in minutes
    row << metrics["agent_wait_time_in_minutes"]["business"]                  # Agent wait time in minutes within business hours
    row << metrics["requester_wait_time_in_minutes"]["calendar"]              # Requester wait time in minutes
    row << metrics["requester_wait_time_in_minutes"]["business"]              # Requester wait time in minutes within business hours
    row << metrics["on_hold_time_in_minutes"]["calendar"]                     # On hold time in minutes
    row << metrics["on_hold_time_in_minutes"]["business"]                     # On hold time in minutes within business hours
    row << ""                                 # Ticket Category [list]
    row << ""                                 # Status [list]

    row
  end

  def start

    CSV.open("temp.csv", "wb") do |csv|
      csv << first_row

      client = define_client
      client.tickets.each_with_index do |t,i|
        csv << format_row(t,i)
      end
    end

  end

  start

  # client = define_client
  # binding.pry

# https://developer.zendesk.com/rest_api/docs/core/tickets




