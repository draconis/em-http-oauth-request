require File.dirname(__FILE__) + '/test_helper.rb'

class TestEmHttpOauthRequest < Test::Unit::TestCase
  def test_that_proxy_simple_get_request_works
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').get :query => {'key' => 'value'}

      request_proxy = OAuth::RequestProxy.proxy(request)

      expected_parameters = {'key' => ['value']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'GET', request_proxy.method
      
      EventMachine.stop
    }
  end

  def test_that_proxy_simple_post_request_works_with_arguments
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').post
      params = {'key' => 'value'}
      request_proxy = OAuth::RequestProxy.proxy(request, {:parameters => params})

      expected_parameters = {'key' => ['value']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'POST', request_proxy.method
      
      EventMachine.stop
    }
  end
  
  def test_that_proxy_simple_post_request_works_with_form_data
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').post :body => {'key' => 'value'},
        :head => {'Content-Type' => 'application/x-www-form-urlencoded'}
      request_proxy = OAuth::RequestProxy.proxy(request)

      expected_parameters = {'key' => ['value']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'POST', request_proxy.method
      
      EventMachine.stop
    }
  end
  
  def test_that_proxy_simple_put_request_works_with_arguments
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').put
      params = {'key' => 'value'}
      request_proxy = OAuth::RequestProxy.proxy(request, {:parameters => params})

      expected_parameters = {'key' => ['value']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'PUT', request_proxy.method
      
      EventMachine.stop
    }
  end
  
  def test_that_proxy_simple_put_request_works_with_form_data
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').put :body => {'key' => 'value'},
        :head => {'Content-Type' => 'application/x-www-form-urlencoded'}
      request_proxy = OAuth::RequestProxy.proxy(request)

      expected_parameters = {'key' => ['value']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'PUT', request_proxy.method
      
      EventMachine.stop
    }
  end
  
  def test_that_proxy_post_request_works_with_mixed_parameter_sources
    EventMachine.run {
      request = ::EventMachine::HttpRequest.new('http://example.com/test').post :query => {'key' => 'value'}, :body => {'key2' => 'value2'},
        :head => {'Content-Type' => 'application/x-www-form-urlencoded'}
      request_proxy = OAuth::RequestProxy.proxy(request, :parameters => {'key3' => 'value3'})

      expected_parameters = {'key' => ['value'], 'key2' => ['value2'], 'key3' => ['value3']}
      assert_equal expected_parameters, request_proxy.parameters_for_signature
      assert_equal 'http://example.com/test', request_proxy.normalized_uri
      assert_equal 'POST', request_proxy.method
      
      EventMachine.stop
    }
  end
end
