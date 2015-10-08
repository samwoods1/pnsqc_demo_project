require_relative '../framework/demo_web_request_helper'
require 'erb'

class WebRequestHelpers
  include DemoWebRequestHelper

  #TODO: This is broken, need to fix.
  def service_log_in(user)
    # Get the jsession_id from the initial navigation to the site.
    jsession_id  = BaseTest.driver.manage.cookie_named('JSESSIONID')[:value]

    # This is a pretty insecure site, and simple to do, you might have more complexity in your own implementation.
    auth_headers = { 'Accept'                    => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                     'Accept-Encoding'           => 'gzip, deflate',
                     'Accept-Language'           => 'en-US,en;q=0.8',
                     'Cache-Control'             => 'max-age=0',
                     'Content-Length'            => '179',
                     'Content-Type'              => 'application/x-www-form-urlencoded',
                     'Cookie'                    => "JSESSIONID=#{jsession_id}",
                     'Origin'                    => 'http://demo.borland.com',
                     'Referer'                   => 'http://demo.borland.com/InsuranceWebExtJS/index.jsf',
                     'Host'                      => 'demo.borland.com',
                     'Upgrade-Insecure-Requests' => '1',
                     'User-Agent'                => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' }

    auth_body = "login-form=login-form&login-form%3Aemail=#{ERB::Util.url_encode(user.email)}{&login-form%3Apassword=#{user.password}&login-form%3Alogin.x=34&login-form%3Alogin.y=7&javax.faces.ViewState=j_id1%3Aj_id2"

    auth_response = make_request(AllPages.login_page.base_url + AllPages.login_page.url + ";jsessionid=#{jsession_id}", 'post', auth_headers, auth_body, [200])

    DemoBaseTest.driver.manage.add_cookie({ :name => 'UserSessionFilter.sessionId', :value => jsession_id, :exipres => 'Thu, 06-Oct-2016 20:25:20 GMT' })
    BaseTest.driver.navigate.refresh
  end

  def service_register_user(user)
    # Get the jsession_id from the initial navigation to the site.
    jsession_id  = BaseTest.driver.manage.cookie_named('JSESSIONID')[:value]

    register_headers = { 'Accept'                    => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                         'Accept-Encoding'           => 'gzip, deflate',
                         'Accept-Language'           => 'en-US,en;q=0.8',
                         'Cache-Control'             => 'max-age=0',
                         'Content-Length'            => '340',
                         'Content-Type'              => 'application/x-www-form-urlencoded',
                         'Cookie'                    => "JSESSIONID=#{jsession_id}",
                         'Origin'                    => 'http://demo.borland.com',
                         'Referer'                   => 'http://demo.borland.com/InsuranceWebExtJS/index.jsf',
                         'Host'                      => 'demo.borland.com',
                         'Upgrade-Insecure-Requests' => '1',
                         'User-Agent'                => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' }

    register_body = "signup=signup&signup%3A#{ERB::Util.url_encode(user.first_name)}=TK4HW&signup%3A#{ERB::Util.url_encode(user.last_name)}=DWHZP&BirthDate=#{ERB::Util.url_encode(user.birthday)}&signup%3Acalendar=&signup%3Aemail=#{ERB::Util.url_encode(user.email)}&signup%3Astreet=#{ERB::Util.url_encode(user.address)}&signup%3Acity=TK4HW&signup%3Astate=NV&signup%3Azip=#{user.postal_code}&signup%3Apassword=#{ERB::Util.url_encode(user.password)}%21&signup%3Asignup.x=40&signup%3Asignup.y=10&javax.faces.ViewState=j_id1%3Aj_id2"

    make_request(AllPages.registration_page.base_url + AllPages.registration_page.url + ";jsessionid=#{jsession_id}", 'post', register_headers, register_body, [200])
  end

end
