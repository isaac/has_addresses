require "#{File.dirname(__FILE__)}/../test_helper"

class CountryByDefaultTest < Test::Unit::TestCase
  def setup
    @country = Country.new
  end
  
  def test_should_not_have_an_id
    assert_nil @country.id
  end
  
  def test_should_not_have_a_name
    assert_nil @country.name
  end
  
  def test_should_not_have_an_official_name
    assert_nil @country.official_name
  end
  
  def test_should_not_have_an_alpha_2_code
    assert_nil @country.alpha_2_code
  end
  
  def test_should_not_have_an_alpha_3_code
    assert_nil @country.alpha_3_code
  end
  
  def test_should_use_name_for_official_name
    country = Country.new(:name => 'United States')
    assert_equal 'United States', country.official_name
  end
  
  def test_should_not_use_name_if_official_name_is_included
    country = Country.new(:official_name => nil)
    assert_nil country.official_name
  end
end

class CountryTest < Test::Unit::TestCase
  def test_should_be_valid_with_a_set_of_valid_attributes
    country = new_country
    assert country.valid?
  end
  
  def test_should_require_an_id
    country = new_country(:id => nil)
    assert !country.valid?
    assert country.errors.invalid?(:id)
  end
  
  def test_should_require_a_name
    country = new_country(:name => nil)
    assert !country.valid?
    assert country.errors.invalid?(:name)
  end
  
  def test_should_not_require_an_official_name
    country = new_country(:official_name => nil)
    assert country.valid?
  end
  
  def test_should_require_an_alpha_2_code
    country = new_country(:alpha_2_code => nil)
    assert !country.valid?
    assert country.errors.invalid?(:alpha_2_code)
  end
  
  def test_should_require_a_unique_alpha_2_code
    country = new_country(:alpha_2_code => 'US')
    assert !country.valid?
    assert country.errors.invalid?(:alpha_2_code)
  end
  
  def test_should_not_allow_alpha_2_codes_shorter_or_longer_than_2_characters
    country = new_country(:alpha_2_code => 'a')
    assert !country.valid?
    assert country.errors.invalid?(:alpha_2_code)
    
    country.alpha_2_code += 'a'
    assert country.valid?
    
    country.alpha_2_code += 'a'
    assert !country.valid?
    assert country.errors.invalid?(:alpha_2_code)
  end
  
  def test_should_require_an_alpha_3_code
    country = new_country(:alpha_3_code => nil)
    assert !country.valid?
    assert country.errors.invalid?(:alpha_3_code)
  end
  
  def test_should_not_allow_alpha_3_codes_shorter_or_longer_than_3_characters
    country = new_country(:alpha_3_code => 'aa')
    assert !country.valid?
    assert country.errors.invalid?(:alpha_3_code)
    
    country.alpha_3_code += 'a'
    assert country.valid?
    
    country.alpha_3_code += 'a'
    assert !country.valid?
    assert country.errors.invalid?(:alpha_3_code)
  end
  
  def test_should_use_alpha_2_code_for_abbreviation_2
    country = new_country(:alpha_2_code => 'US')
    assert_equal 'US', country.abbreviation_2
  end
  
  def test_should_use_alpha_3_code_for_abbreviation_3
    country = new_country(:alpha_3_code => 'USA')
    assert_equal 'USA', country.abbreviation_3
  end
  
  def test_should_use_alpha_2_code_for_stringification
    country = new_country(:alpha_2_code => 'US')
    assert_equal 'US', country.to_s
  end
  
  def test_should_protect_attributes_from_mass_assignment
    country = Country.new(
      :id => 999,
      :name => 'Somewhere',
      :official_name => 'Somewhere Republic',
      :alpha_2_code => 'SW',
      :alpha_3_code => 'SMW'
    )
    
    assert_equal 999, country.id
    assert_equal 'Somewhere', country.name
    assert_equal 'Somewhere Republic', country.official_name
    assert_equal 'SW', country.alpha_2_code
    assert_equal 'SMW', country.alpha_3_code
  end
end

class CountryAfterBeingCreatedTest < Test::Unit::TestCase
  def setup
    @country = Country['US']
  end
  
  def test_should_have_an_id
    assert_not_nil @country.id
  end
  
  def test_should_have_an_official_name
    assert_equal 'United States of America', @country.official_name
  end
end

class CountryWithRegionsTest < Test::Unit::TestCase
  def setup
    @country = Country['US']
  end
  
  def test_should_have_regions
    assert_equal 57, @country.regions.size
  end
end
