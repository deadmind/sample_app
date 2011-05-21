require 'spec_helper'

describe "LayoutLinks" do
  it "Should have a Home page at /" do
    get '/'
    response.should have_selector("title", :content => "Home")
  end

  it "Should have a Contact page at /contact" do
    get '/contact'
    response.should have_selector("title", :content => "Contact")
  end

  it "Should have a About page at /about" do
    get '/about'
    response.should have_selector("title", :content => "About")
  end

  it "Should have a Help page at /help" do
    get '/help'
    response.should have_selector("title", :content => "Help")
  end

  it "Should have a Sign up page at /signup" do
    get '/signup'
    response.should have_selector("title", :content => "Sign up")
  end

end

describe "when not signed in" do
  it "should have a signin link" do
    visit root_path
    response.should have_selector("a", :content => "Sign in",
      :href => signin_path)    
  end
end

describe "whe signed in" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  it "should have a signout link" do
    visit root_path
    response.should have_selector("a", :content => "Sign out",
      :href => signout_path)
  end

  it "should have a profile link" do
    visit root_path
    response.should have_selector("a", :content => "Profile",
      :href => user_path(@user))
  end
end
