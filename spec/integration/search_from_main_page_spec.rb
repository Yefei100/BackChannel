require 'spec_helper'

#class SearchFromMainPageSpec < ActionDispatch::IntegrationTest
describe "search from main page" do
  it "user hehehe" do
    visit '/posts'
    fill_in 'Post title contains', :with => 'hehehe'
    click_button 'search'
    expect(page).to have_content ''
  end
end

  describe "login with" do
    it "credentials" do
      visit '/admin/login'
      fill_in 'Name', :with => '233'
      fill_in 'Password', :with => '233'
      click_button 'Login'
      expect(page).to have_content 'Show all posts'
    end
  end

describe "delete users should get permission" do
    it "should be a admin before deleting users" do
      visit '/admin/login'
      fill_in 'Name', :with => '233'
      fill_in 'Password', :with => '233'
      click_button 'Login'
      visit '/users'
      click_button 'destroy'
      expect(page).to have_content 'action not allowed'
    end
  end
#end