require 'spec_helper'

module Peoplw
  describe "Parse standard name variations" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "should parse first initial, last name" do
      name = @np.parse( "M ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 1
      name[:first].should == "M"
      name[:last].should == "Ericson"
    end

    it "should parse first initial, middle initial, last name" do
      name = @np.parse( "M E ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 2
      name[:first].should == "M"
      name[:middle].should == 'E'
      name[:last].should == "Ericson"
    end

    it "should parse first initial with period, middle initial with period, last name" do
      name = @np.parse( "M.E. ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 3
      name[:first].should == "M"
      name[:middle].should == 'E'
      name[:last].should == "Ericson"
    end

    it "should parse first initial, two middle initials, last name" do
      name = @np.parse( "M E E  ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 4
      name[:first].should == "M"
      name[:middle].should == 'E E'
      name[:last].should == "Ericson"
    end

    it "should parse first initial, middle name, last name" do
      name = @np.parse( "M EDWARD ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 5
      name[:first].should == "M"
      name[:middle].should == 'Edward'
      name[:last].should == "Ericson"
    end

    it "should parse first name, middle initial, last name" do
      name = @np.parse( "MATTHEW E ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 6
      name[:first].should == "Matthew"
      name[:middle].should == 'E'
      name[:last].should == "Ericson"
    end

    it "should parse first name, two middle initials, last name" do
      name = @np.parse( "MATTHEW E E ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 7
      name[:first].should == "Matthew"
      name[:middle].should == 'E E'
      name[:last].should == "Ericson"
    end

    it "should parse first name, two middle initials with periods, last name" do
      name = @np.parse( "MATTHEW E.E. ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 8
      name[:first].should == "Matthew"
      name[:middle].should == 'E.E.'
      name[:last].should == "Ericson"
    end

    it "should parse first name, last name" do
      name = @np.parse( "MATTHEW ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 9
      name[:first].should == "Matthew"
      name[:last].should == "Ericson"
    end

    it "should parse first name, middle name, last name" do
      name = @np.parse( "MATTHEW EDWARD ERICSON" )
      name[:parsed].should be_true
      name[:parse_type].should == 10
      name[:first].should == "Matthew"
      name[:middle].should == 'Edward'
      name[:last].should == "Ericson"
    end

    it "should parse first name, middle initial, middle name, last name" do
      pending( "Doesn't correctly parse two middle names" ) do
        name = @np.parse( "MATTHEW E. SHEIE ERICSON" )
        name[:parsed].should be_true
        name[:parse_type].should == 11
        name[:first].should == "Matthew"
        name[:middle].should == 'E. Sheie'
        name[:last].should == "Ericson"
      end
    end
  end

  describe "Parse multiple names" do
    before( :each ) do
      @np = People::NameParser.new( :couples => true )
    end

    it "should parse multiple first names and last name" do
      name = @np.parse( "Joe and Jill Hill" )
      name[:parsed].should == true
      name[:multiple].should be_true
      name[:parsed2].should be_true
      name[:parse_type].should == 9
      name[:first2].should == "Jill"
    end

    it "should parse multiple first names, middle initial, last name" do
      name = @np.parse( "Joe and Jill S Hill" )
      name[:parsed].should == true
      name[:multiple].should be_true
      name[:parsed2].should be_true
      name[:parse_type].should == 9
      name[:first2].should == "Jill"
      name[:middle2].should == 'S'
    end

    it "should parse multiple first names, middle initial, last name" do
      name = @np.parse( "Joe S and Jill Hill" )
      name[:parsed].should == true
      name[:multiple].should be_true
      name[:parsed2].should be_true
      name[:parse_type].should == 6
      name[:first2].should == "Jill"
      name[:middle].should == 'S'
    end
  end

  describe "Parse unusual names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "should parse multiple-word last name" do
      name = @np.parse( "Matthew De La Hoya" )
      name[:parsed].should be_true
      name[:parse_type].should == 9
      name[:last].should == "De La Hoya"
    end

    it "should parse last name with cammel case" do
      name = @np.parse( "Matthew McIntosh" )
      name[:parsed].should be_true
      name[:parse_type].should == 9
      name[:last].should == "McIntosh"
    end
  end

  describe "Parse names with decorations" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "should parse name with the suffix 'Jr'" do
      name = @np.parse( "Matthew E Ericson Jr" )
      name[:parsed].should be_true
      name[:suffix].should == "Jr"
    end

    it "should parse name with a roman numeral suffix" do
      name = @np.parse( "Matthew E Ericson III" )
      name[:parsed].should be_true
      name[:suffix].should == "III"
    end

#   it "should parse name with an ordinal suffix" do
#     name = @np.parse( "Matthew E Ericson 2nd" )
#     name[:parsed].should be_true
#     name[:suffix].should == "2nd"
#   end

    it "should parse name with a suffix with periods" do
      name = @np.parse( "Matthew E Ericson M.D." )
      name[:parsed].should be_true
      name[:suffix].should == "M.D."
    end

    it "should parse name with a title" do
      name = @np.parse( "Mr Matthew E Ericson" )
      name[:parsed].should be_true
      name[:title].should == "Mr "
    end

    it "should parse name with a title with a period" do
      name = @np.parse( "Mr. Matthew E Ericson" )
      name[:parsed].should be_true
      name[:title].should == "Mr. "
    end

    it "should parse name with a title, first initial" do
      name = @np.parse( "Rabbi M Edward Ericson" )
      name[:parsed].should be_true
      name[:parse_type].should == 5
      name[:title].should == "Rabbi "
      name[:first].should == 'M'
    end

    it "should parse 1950s married couple name" do
      name = @np.parse( "Mr. and Mrs. Matthew E Ericson" )
      name[:parsed].should be_true
      name[:title].should == "Mr. And Mrs. "
      name[:first].should == "Matthew"
    end
  end

  describe "Name case options" do
    it "should change upper case to proper case" do
      proper_np = People::NameParser.new( :case_mode => 'proper' )
      name = proper_np.parse( "MATTHEW ERICSON" )
      name[:first].should == "Matthew"
      name[:last].should == "Ericson"
    end

    it "should change proper case to upper case" do
      proper_np = People::NameParser.new( :case_mode => 'upper' )
      name = proper_np.parse( "Matthew Ericson" )
      name[:first].should == "MATTHEW"
      name[:last].should == "ERICSON"
    end

    it "should leave case as is" do
      proper_np = People::NameParser.new( :case_mode => 'leave' )
      name = proper_np.parse( "mATTHEW eRicSon" )
      name[:first].should == "mATTHEW"
      name[:last].should == "eRicSon"
    end
  end
end
