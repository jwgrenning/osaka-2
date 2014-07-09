# encoding: utf-8
require 'osaka'

describe "Osaka::TypicalPrintDialog" do

  include(*Osaka::OsakaExpectations)
  subject { Osaka::TypicalPrintDialog.new("App", at.window("Print")) }
    
  let(:control) { subject.control = double("RemoteControl", :name => "App") }

  it "Should be able to save the PDF in a print dialog" do
    
    control.stub(:base_location).and_return(at.window("Print"))
    
    save_dialog_mock = double("Generic Save Dialog")
    
    expect_click!(at.menu_button("PDF")) 
    expect_wait_until_exists!(at.menu(1).menu_button("PDF"))
    
    expect_click!(at.menu_item(2).menu(1).menu_button("PDF"))
    expect_wait_until_exists!(at.window("Save"), at.sheet(1).window("Print")).and_return(at.window("Save"))

    subject.should_receive(:create_save_dialog).with("App", at.window("Save")).and_return(save_dialog_mock)
    save_dialog_mock.should_receive(:save).with("filename")
    
    expect_until_not_exists!(at.window("Print"))
    expect_exists?(at.checkbox(1)).and_return(true)
    expect_click!(at.checkbox(1))
    
    subject.save_as_pdf("filename")
  end

end
