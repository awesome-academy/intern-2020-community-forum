module SpecTestHelper
  def login user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  def logout user
    sign_out user
  end
end
