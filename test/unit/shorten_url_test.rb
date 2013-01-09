require "test_helper"

class ShortenUrlTest < ActiveSupport::TestCase

  include ShortenUrl

  test "should convert decimal number to 62 number system" do
    assert_equal "1", to_number_62(1)
    assert_equal "A", to_number_62(10)
    assert_equal "z", to_number_62(61)
    assert_equal "10", to_number_62(62)
    assert_equal "1z", to_number_62(123)
    assert_equal "20", to_number_62(124)
    assert_equal "2bI", to_number_62(10000)
    assert_equal "Q1P", to_number_62(100031)
    assert_equal "6laZE", to_number_62(100000000)
  end

  test "should convert shorten url to decimal" do
    assert_equal 1, to_id("1")
    assert_equal 10, to_id("A")
    assert_equal 123, to_id("1z")
    assert_equal 10000, to_id("2bI")
    assert_equal 100031, to_id("Q1P")
    assert_equal 100000000, to_id("6laZE")
  end

  test "should get api code" do
    assert_equal 1000, get_api_code("api_board")
    assert_equal nil, get_api_code("whatever")
  end

  test "should get shorten url" do
    assert_equal "2bJ", get_shorten_url("api_board", 1)
    assert_equal nil, get_shorten_url("whatever", 1)
  end

  test "should get origin url" do
    assert_equal "/api/boards/1", get_origin_url("/2bJ")
  end

  test "should return nil when shorten url is illegal" do
    assert_equal nil, get_origin_url("/home/index")
    assert_equal nil, get_origin_url("/")
  end

  test "should get origin url with query string" do
    assert_equal "/api/boards/1?embed=tags%2Cconcepts", get_origin_url("/2bJ", "embed=tags%2Cconcepts")
    assert_equal nil, get_origin_url("/", "embed=tags%2Cconcepts")
  end

end