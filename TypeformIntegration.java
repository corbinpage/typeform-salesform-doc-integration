public class TypeformIntegration {
    // Defines the different parts of the Typeform API URL
  private static final String TYPEFORM_API_BASE_URL = 'https://api.typeform.com/v0/form/';
  private static final String AUDIOGRAM_FORM_ID = '<INSERT_HERE>';
    private static final String TYPEFORM_KEY = '<INSERT_HERE>';
    
    // Constructs the query to be run on a scheduled basis
    public static void findNewAudiogramsOnSchedule(boolean useSince) {
        String parameters = '&completed=true';
        if(useSince) {
            String since = String.valueOf(findLastRun().getTime());
            since = since.removeEnd('000')+'100'; //Searches from the tenth of a second past the last update
            parameters = parameters+'&since='+since;
        } 
        getNewAudiograms(TYPEFORM_API_BASE_URL+AUDIOGRAM_FORM_ID+'?key='+TYPEFORM_KEY+parameters);
    }    
   
    // Find the last Audiogram uploaded
    private static Datetime findLastRun() {
        System.debug('-----------------------');
        Contact[] contacts = [SELECT id,userEnteredDate__c FROM Contact WHERE userEnteredDate__c != NULL ORDER BY userEnteredDate__c DESC];
    Datetime since = contacts.isEmpty() ? Datetime.now().addDays(-30) : contacts[0].userEnteredDate__c;
        return since;
    } 

  // Runs query and processes the resulting audiogram uploads
    public static void getNewAudiograms(String url) {
      HttpResponse res = getHttpCalloutResponse(url);
        
        try {
        parseTypeformResponse(res.getBody());
        } catch(System.SObjectException e) {
          System.debug('------Parsing Typeform Response Failed------');
            System.debug('Error: '+e.getMessage());
          System.debug('Status: '+res.getStatusCode()+': '+res.getStatus());
          System.debug('Headers: '+res.getHeaderKeys());
          System.debug('Body: '+res.getBody());
        } 
    }
  
    // Pass in the endpoint to be used using the string url
    private static HttpResponse getHttpCalloutResponse(String url) {
      // Instantiate a new http object
      Http h = new Http();

      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setEndpoint(url);
      req.setMethod('GET');
      HttpResponse res = new HttpResponse();
    
      try {
          // Send the request, and return a response
          res = h.send(req); 

          //Helpful debug messages
          System.debug('Querying: '+url);
          //System.debug(res.getHeader('Content-Type')); // 'text/html; charset=UTF-8'
          //System.debug(res.getBody());
      
          return res;
        } catch(System.CalloutException e) {
          System.debug('------Typeform Request Failed------');
            System.debug('Error: '+e.getMessage());
          System.debug('Endpoint: '+req.getEndpoint());
          System.debug('Status: '+res.getStatusCode()+': '+res.getStatus());
          System.debug('Headers: '+res.getHeaderKeys());
          System.debug('Body: '+res.getBody());

          return res;
        }  
  }

  // Adds the filepath to the Contact as a Note    
    private static void addFilepathAsNoteToContact(String filepath, Contact con) {
        Note note = new Note();
        note.ParentId = con.Id;
        note.Title = 'Audiogram File';
        note.Body = filepath;
     
      insert note;
    }

    // Find and return or create a new Contact
    public static Contact createOrUpdateContact(String name, String email, String phone, String dateLand, String filepath) {        
      Contact con;
        Integer i = [SELECT count() FROM Contact WHERE Email = :email LIMIT 1];
        if(i == 1) {
            con = [SELECT Id,LastName,Email,Phone,userEnteredDate__c FROM Contact WHERE Email = :email LIMIT 1];
          System.debug('Found Contact');
            if(con.userEnteredDate__c < Datetime.valueOfGmt(dateLand)) {
                addFilepathAsNoteToContact(filepath, con);
              con.userEnteredDate__c = Datetime.valueOfGmt(dateLand);
                System.debug('Updated Contact');
            }
        } else {
          con = createContact(name,email,phone,dateLand);
            addFilepathAsNoteToContact(filepath, con);
            System.debug('New Contact');
        }
        System.debug('('+con.LastName+', '+con.Email+', '+con.Phone+', '+con.userEnteredDate__c+')');       
        return con;
    }
    
    // Create and insert new Contact
    public static Contact createContact(String name, String email, String phone, String dateLand) {        
        Contact con = new Contact();
        con.LastName = (String.isEmpty(name)) ? 'TBD' : name;
        con.Email = (String.isEmpty(email)) ? 'tbd@test.com' : email;
        con.userEnteredDate__c = Datetime.valueOfGmt(dateLand);
        if(!String.isEmpty(phone)) {
          con.Phone = phone;
        }
        insert con;
      
        return con;
    }

    // Field IDs from the Typeform Form that are returned by the API response
  private static final String NAME_ID = 'textfield_4186535';
  private static final String EMAIL_ID = 'textfield_4186537';    
  private static final String PHONE_ID = 'textfield_4186541';
  private static final String FILE_ID = 'fileupload_4185829';
    private static final String DATE_LAND_ID = 'date_land';

    // Parse out the Typeform API response and get the new Contact fields
    private static void parseTypeformResponse(String responseBody) {
        JSONParser parser = JSON.createParser(responseBody);
        String name;
        String email;
        String filepath;
        String phone;
        String dateLand;
      
        while (parser.nextToken() != null) {
          // Get responses array
          if (parser.getCurrentName() == 'responses' && parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while(parser.nextToken() != null) {
                        // Get a set of metadata
                        //System.debug('Responses: '+parser.getCurrentName());
                        //System.debug('Text: '+parser.getText());
                        if((parser.getCurrentName() == 'metadata') && (parser.getCurrentToken() == JSONToken.START_OBJECT)){
                            while(parser.nextToken() != null) {
                                if((parser.getCurrentName() == DATE_LAND_ID) && (parser.getCurrentToken() == JSONToken.VALUE_STRING)){
                                    dateLand = parser.getText();
                                } else if(parser.getCurrentToken() == JSONToken.END_OBJECT){
                        break; 
                    }
                            }
                        }
                    // Get a set of answers
                    if((parser.getCurrentName() == 'answers') && (parser.getCurrentToken() == JSONToken.START_OBJECT)){
                      while(parser.nextToken() != null) {
                                //System.debug('Answer: '+parser.getCurrentName());
                        if((parser.getCurrentName() == NAME_ID) && (parser.getCurrentToken() == JSONToken.VALUE_STRING)){
                            name = parser.getText();
                        } else if ((parser.getCurrentName() == EMAIL_ID) && (parser.getCurrentToken() == JSONToken.VALUE_STRING)) {
                            email = parser.getText();
                        } else if ((parser.getCurrentName() == FILE_ID) && (parser.getCurrentToken() == JSONToken.VALUE_STRING)) {
                            filePath = parser.getText();
                        } else if ((parser.getCurrentName() == PHONE_ID) && (parser.getCurrentToken() == JSONToken.VALUE_STRING)) {
                              phone = parser.getText();
                                } else if (parser.getCurrentToken() == JSONToken.END_OBJECT) {
                                //System.debug('Ready('+name+', '+email+', '+phone+', '+dateLand+', '+filePath+')');
                                    if(!String.isEmpty(filePath) && !String.isEmpty(name) && !String.isEmpty(email)) {
                                      Contact con = createOrUpdateContact(name,email,phone,dateLand,filepath);
                                    }
                              break; 
                            }
                        } 
                      }
                  }
          }                      
      }      
    }
}