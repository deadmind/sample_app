require 'spec_helper'

describe User do

  before(:each) do
    @attr = {:name => "Example User",
             :email => "user@example.com",
             :password => "p@ssw0rd",
             :password_confirmation => "p@ssw0rd"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "k" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should have valid email" do
    emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.org]
    emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password_validation" do
    it "should require a password" do
      user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      user = User.new(@attr.merge(:password_confirmation => "not confirmed"))
      user.should_not be_valid
    end

    it "should reject short passwords" do
      short_password = 'a' * 5
      hash = @attr.merge(:password => short_password, :password_confirmation => short_password)
      user = User.new(hash)
      user.should_not be_valid
    end

    it "should reject long passwords" do
      long_password = 'a' * 41
      hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
      user = User.new(hash)
      user.should_not be_valid
    end
  end

  describe "password_encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should test an empty encrypted_password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should be false if the passwords do not match" do
      @user.has_password?("invalid").should be_false
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end

  end


end