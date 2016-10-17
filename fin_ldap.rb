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

