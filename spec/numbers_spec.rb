
require 'osaka'

describe "Osaka::Numbers" do

  include(*Osaka::OsakaExpectations)

  subject { Osaka::Numbers.new }  
  let(:control) { subject.control = double("RemoteControl").as_null_object}
  
  it "Should be able to get the column count" do
    expect_tell('tell document 1; tell sheet 1; tell table 1; get column count; end tell; end tell; end tell').and_return("10")
    subject.column_count.should == 10
  end
  
  it "Should be able to set the column count to a certain value" do
    expect_tell('tell document 1; tell sheet 1; tell table 1; set column count to 10; end tell; end tell; end tell')
    subject.set_column_count(10)
  end
  
  it "Should be able to fill in data in cells" do 
    subject.should_receive(:column_count).and_return(10)
    expect_tell('tell document 1; tell sheet 1; tell table 1; set value of cell 1 of row 2 to "30"; end tell; end tell; end tell')
    subject.fill_cell(1, 2, "30")
  end
  
  it "Will change the column count when the cell is outside of the range of the current column count" do
    subject.should_receive(:column_count).and_return(5)
    subject.should_receive(:set_column_count).with(6)
    expect_tell('tell document 1; tell sheet 1; tell table 1; set value of cell 6 of row 2 to "30"; end tell; end tell; end tell')
    subject.fill_cell(6, 2, "30")
    
  end
  
  it "Should be able to select blank from the template choser" do
    expect_set_current_window("Template Choser")
    subject.should_receive(:do_and_wait_for_new_window).and_return("Template Choser")
    expect_set_current_window("Untitled")
    subject.should_receive(:do_and_wait_for_new_window).and_yield.and_return("Untitled")
    expect_keystroke(:return)
    subject.new_document 
  end
  
  it "Should be able to change the header columns" do
    expect_click_menu_bar(at.menu_item("0").menu(1).menu_item("Header Columns"), "Table")
    subject.set_header_columns(0)
  end
  
  it "Should be able to use a class method for creating documents quickly" do
      Osaka::Numbers.should_receive(:new).any_number_of_times.and_return(double("App"))
      subject.should_receive(:create_document)

      Osaka::Numbers.create_document("filename") { |doc|
      }    
  end
    
end