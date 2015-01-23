require 'typeform'
require 'restforce'

require "pry"


# Connect to Typeform
# Typeform: Check if any new documents have been submitted
# Typeform: Get the file url and identifier

# Connect to Salesforce
# Salesforce

# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------


def get_typeform_form
  Typeform.api_key = ENV['TYPEFORM_API_KEY']
  typeform_id = "Su6ppS"

  Typeform::Form.new(typeform_id)
end

def do_things(form)

  complete_entries = form.complete_entries

  # Fetches all complete entries since today
  # newest_entries = form.complete_entries(since: Time.now.to_i)

  # Query Arguements
  # completed: boolean (true or false). Whether you want to get completed, uncompleted entries (useful when using hidden fields to see which of your users did not finish the typeform), or both (if no completed argument is provided).
  # since: number (Unix time/Timestamp). Date and time of the first response you want to list (responses are returned in oldest-to-newer order).
  # until: number (Unix time/Timestamp). Date and time of the last response you want to list (responses are returned in oldest-to-newer order).
  # offset: number. The order number of the first row you want to retrieve, specially useful for pagination.
  # limit: number. The number of responses you want to retrieve, specially useful for pagination.

  binding.pry
end

# form = get_typeform_form
# do_things(form)

# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------
# # --------------------------------------------------------

def create_salesforce_client


  binding.pry
end


create_salesforce_client







# Apps Credentials

# secrets = JSON[File.read("./keys.json")]

# service_account_email = secrets['service_account_email']
# key_file = secrets['key_file']
# key_secret = secrets['key_secret']
# user_email = 'corbin.page@gmail.com'

# # Authorize and get key
# key = Google::APIClient::PKCS12.load_key(key_file, key_secret)

# # Get the Google API client
# client = Google::APIClient.new(:application_name => 'lis-pendens', 
#                                :application_version => '0.01')

# client.authorization = Signet::OAuth2::Client.new(
#                                                   :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
#                                                   :audience => 'https://accounts.google.com/o/oauth2/token',
#                                                   :scope => "https://www.googleapis.com/auth/drive " +
#                                                   "https://docs.google.com/feeds/ " +
#                                                   "https://docs.googleusercontent.com/ " +
#                                                   "https://spreadsheets.google.com/feeds/",
#                                                   :issuer => service_account_email,
#                                                   :signing_key => key)
# client.authorization.fetch_access_token!
# access_token = client.authorization.access_token



# ##
# # Insert a new permission
# #
# # @param [Google::APIClient] client
# #   Authorized client instance
# # @param [String] file_id
# #   ID of the file to insert permission for.
# # @param [String] value
# #   User or group e-mail address, domain name or nil for 'default' type
# # @param [String] perm_type
# #   The value 'user', 'group', 'domain' or 'default'
# # @param [String] role
# #   The value 'owner', 'writer' or 'reader'
# # @return [Google::APIClient::Schema::Drive::V2::Permission]
# #   The inserted permission if successful, nil otherwise
# def insert_permission(client, file_id, value, perm_type, role)

#   drive = client.discovered_api('drive', 'v2')
#   new_permission = drive.permissions.insert.request_schema.new({
#     'value' => value,
#     'type' => perm_type,
#     'role' => role
#     })
#   result = client.execute(
#                           :api_method => drive.permissions.insert,
#                           :body_object => new_permission,
#                           :parameters => { 'fileId' => file_id })
#   if result.status == 200
#     return result.data
#   else
#     puts "An error occurred: #{result.data['error']['message']}"
#   end
# end

# ##
# # Update a permission's role
# #
# # @param [Google::APIClient] client
# #   Authorized client instance
# # @param [String] file_id
# #   ID of the file to update permission for
# # @param [String] permission_id
# #   ID of the permission to update
# # @param [String] new_role
# #   The value 'owner', 'writer' or 'reader'
# # @return [Google::APIClient::Schema::Drive::V2::Permission]
# #   The updated permission if successful, nil otherwise
# def update_permission(client, file_id, permission_id, new_role)

#   drive = client.discovered_api('drive', 'v2')# First retrieve the permission from the API.
#   result = client.execute(
#                           :api_method => drive.permissions.get,
#                           :parameters => {
#                             'fileId' => file_id,
#                             'permissionId' => permission_id
#                             })
#   if result.status == 200
#     permission = result.data
#     permission.role = new_role
#     result = client.execute(
#                             :api_method => drive.permissions.update,
#                             :body_object => updated_permission,
#                             :parameters => {
#                               'fileId' => file_id,
#                               'permissionId' => permission_id
#                               })
#     if result.status == 200
#       return result.data
#     end
#   end
#   puts "An error occurred: #{result.data['error']['message']}"
# end

# ##
# # Create a new file
# #
# # @param [Google::APIClient] client
# #   Authorized client instance
# # @param [String] title
# #   Title of file to insert, including the extension.
# # @param [String] description
# #   Description of file to insert
# # @param [String] parent_id
# #   Parent folder's ID.
# # @param [String] mime_type
# #   MIME type of file to insert
# # @param [String] file_name
# #   Name of file to upload
# # @return [Google::APIClient::Schema::Drive::V2::File]
# #   File if created, nil otherwise
# def insert_file(client, title, description, parent_id, mime_type, file_name)
#   drive = client.discovered_api('drive', 'v2')
#   file = drive.files.insert.request_schema.new({
#     'title' => title,
#     'description' => description,
#     'mimeType' => mime_type
#     })
#   # Set the parent folder.
#   if parent_id
#     file.parents = [{'id' => parent_id}]
#   end
#   media = Google::APIClient::UploadIO.new(file_name, mime_type)
#   result = client.execute(
#                           :api_method => drive.files.insert,
#                           :body_object => file,
#                           :media => media,
#                           :parameters => {
#                             'uploadType' => 'multipart',
#                             'alt' => 'json',
#                             'convert' => true})
#   if result.status == 200
#     return result.data
#   else
#     puts "An error occurred: #{result.data['error']['message']}"
#     return nil
#   end
# end

# # ---------------------------------------------------------------
# # ---------------------------------------------------------------
# # ---------------------------------------------------------------

# # Creates a new Google Spreadsheet and permissions corbin.page@gmail.com to see it
# # file_result = insert_file(client, 'lis-pendens-output', 'Contains information about Lis Pendens Projects', false, 'text/csv', 'lis-pendens-output.csv')
# # permission_result = insert_permission(client, file_result["id"], 'corbin.page@gmail.com', 'user', 'writer')
# # puts file_result["id"]

# # ---------------------------------------------------------------
# # ---------------------------------------------------------------
# # ---------------------------------------------------------------

# def create_new_entry(tr, county, state)
#   new_entry = {}

#   new_entry["Clerk File Number"] = tr.search("td:nth-child(2) a").text
#   # new_entry["Link"] = tr.search("td:nth-child(2) a").attr('href').value
#   new_entry["Date Posted"] = tr.search("td:nth-child(4)").text
#   new_entry["First Party"] = tr.search("td:nth-child(10) span:first").text
#   new_entry["Date Added"] = Time.now 
#   new_entry["County"] = county
#   new_entry["State"] = state

#   new_entry
# end

# def write_list_entry_to_spreadsheet(session, new_entry)
#   doc_id = '1t6-1WtYW9AeFf1P3LbgO9-mqO5UpH8tDSNNwoBtyCL0'
#   worksheet = session.spreadsheet_by_key(doc_id).worksheets[0]

#   worksheet.list.push(new_entry)
#   worksheet.save
# end

# # ---------------------------------------------------------------
# # ---------------------------------------------------------------
# # ---------------------------------------------------------------



# agent = Mechanize.new { |a|
#   a.user_agent_alias = 'Mac Safari'
# }
# agent.read_timeout = 300


# agent.get('https://www2.miami-dadeclerk.com/officialrecords/Search.aspx') do |page|
#   puts "Initial Connection made.."
#   search_result_page = page.form_with(:name => 'aspnetForm') do |search|
#     search["ctl00$ContentPlaceHolder1$tcStandar$tpNameSearch$pfirst_partySTD"] = 'Bank'
#     search["ctl00$ContentPlaceHolder1$tcStandar$tpNameSearch$prec_date_fromSTD"] = '12/1/2014'
#     search["ctl00$ContentPlaceHolder1$tcStandar$tpNameSearch$pdoc_typeSTD"] = 'LIS'    
#     puts "Form filled out.."
#   end.click_button(page.form_with(:name => 'aspnetForm').submits[0])

#   puts "Results present.."
#   tr_array = search_result_page.search("table.gvResults tr")

#   # until tr_array.empty? 
#   tr_array.each_with_index do |tr, i|
#     unless i == 0 || i == tr_array.count-1
#       new_entry = create_new_entry(tr, "Dade", "FL")
#       session = GoogleDrive.login_with_oauth(access_token)
#       write_list_entry_to_spreadsheet(session, new_entry)
#     end
#   end

#     # binding.pry
#     # search_result_page = agent.search_result_page.link_with(:text => 'NEXT PAGE').click
#     # tr_array = search_result_page.search("table.gvResults tr")
#   # end

# end

# # ---------------------------------------------------------------
# # ---------------------------------------------------------------
# # ---------------------------------------------------------------


