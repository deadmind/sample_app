require 'spec_helper'

describe "Users" do

  describe "signin" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template("users/new")
          response.should have_selector("div#error-explanation")
        end.should_not change(User,:count)
      end

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "test"
          fill_in "Email", :with => "email@domain.com"
          fill_in "Password", :with => "p@ssw0rd"
          fill_in "Confirmation", :with => "p@ssw0rd"
          click_button
          response.should have_selector("div.flash.success")
          response.should render_template("users/show")
        end.should change(User, :count).by(1)
      end
    end

  end

end
