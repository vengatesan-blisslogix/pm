require 'rubygems'
require 'net/ldap'
require 'ldap'



$LDAP_HOST = "10.91.19.110"
$LDAP_PORT = LDAP::LDAP_PORT
$LDAP_USER = "administrator@tvsi.local"
$LDAP_PW   = "@dm1n@969"


conn = LDAP::Conn.new($LDAP_HOST, 389)
conn.bind($LDAP_USER, $LDAP_PW)

  my_filter = "(&(objectCategory=person)(objectclass=user)"
  res = conn.search2("dc=TVSi,dc=local", LDAP::LDAP_SCOPE_SUBTREE,
my_filter)
  res[0].keys.each { |k| puts k }

conn.unbind

def user_eldap
  resp = []
  if params[:email]
    
  
    ldap = Net::LDAP.new :host => "10.91.19.110",
       :port => 389,
       :auth => {
             :method => :simple,
             :base  =>       "DC=TVSi,DC=local",
             :username => "administrator@tvsi.local",
             :password => "@dm1n@969"
       }

    is_authorized = ldap.bind # returns true if auth works, false otherwise (or throws error if it can't connect to the server)

    attrs = []
    puts is_authorized
    #puts ldap.search(:filter => "sAMAccountName=yogesh.s1").first

    search_param = params[:email]
    result_attrs = ["sAMAccountName", "displayName", "mail", "employeeID", "department"]

    # Build filter
    search_filter = Net::LDAP::Filter.eq("mail", search_param)

    puts search_filter
    # Execute search
    puts ldap.search(:base => "DC=TVSi,DC=local", :filter => search_filter, :attributes => result_attrs) { |item| 
      begin
      resp << {
        'Account_Name' => item.sAMAccountName.first,
        'Display_Name' => item.displayName.first,
        'Mail' => item.mail.first,
        'Employee_ID' => item.employeeID.first,
        'Department' => item.department.first
      }  
      rescue Exception => e
       resp << e 
      end
      #{}"#{item.sAMAccountName.first}: #{item.displayName.first} (#{item.mail.first})" 
      
    }
    render :json => resp
  else
    render :json => resp
  end
end
