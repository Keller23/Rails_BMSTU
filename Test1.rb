# frozen_string_literal: true

require 'json'
require 'selenium-webdriver'
require 'rspec'
include RSpec::Expectations

describe 'Test1' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = 'https://www.google.com/'
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it 'test_1' do
    @driver.get 'http://localhost:3000/'
    @driver.find_element(:link, 'Вычислить НОД').click
    @driver.find_element(:id, 'result_n').clear
    @driver.find_element(:id, 'result_n').send_keys '64'
    @driver.find_element(:id, 'result_m').clear
    @driver.find_element(:id, 'result_m').send_keys '2'
    @driver.find_element(:name, 'commit').click
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end

  def verify
    yield
  rescue ExpectationNotMetError => e
    @verification_errors << e
  end

  def close_alert_and_get_its_text(_how, _what)
    alert = @driver.switch_to.alert()
    alert_text = alert.text
    if @accept_next_alert
      alert.accept
    else
      alert.dismiss
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
