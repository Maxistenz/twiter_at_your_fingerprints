require 'test_helper'

class UsersControllerTest <  ActionController::TestCase

  context 'admin only can create manage users' do
    setup do
      @user = FactoryGirl.create(:administrator)
      sign_in @user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      get :index
    end

    should 'if an admin login then redirect to users' do
      assert_response :success
      assert_template %r{\Ausers\Z}
    end

    should 'show user' do
      get :edit, id: FactoryGirl.create(:common)
      assert_response :success
      assert_template %r{\Ausers\Z}
    end

    should 'should destroy user' do
      assert_difference('User.count', -1) do
        delete :destroy, id: @user
      end
      assert_redirected_to users_path
    end

    should 'create user' do
      user = FactoryGirl.build(:third_user)
      assert_difference('User.count') do
        post :create, user: {email: user.email, password: user.password, admin: user.admin}
      end
      assert_response :redirect
      assert_template %r{\Ausers\Z}
    end

    should 'not create a user with same mail' do
      assert_difference('User.count', 0) do
        post :create, user: {email: @user.email , password: @user.password, admin: false}
      end
      assert_response :success
      assert_template %r{\Anew\Z}
    end

    should 'should update user' do
      put :update, id: @user, user: {email: @user.email, password: 'f4k3p455w0rd',
                                     admin: @user.admin}
      assert_redirected_to user_path(assigns(:user))
    end
  end

  context 'users without admin rol cant manage users' do
    setup do
      @user = FactoryGirl.create(:common)
      sign_in @user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      get :index
    end

    should 'if not an admin login then redirect to home' do
      assert_redirected_to home_path
    end

    should 'redirect to home if user not have an admin role when edit a user' do
      get :edit, id: FactoryGirl.build(:third_user)
      assert_redirected_to home_path
    end

    should 'redirect to home if user not have an admin role when create a user' do
      user = FactoryGirl.build(:third_user)
      assert_difference('User.count', 0) do
        post :create, user: {email: user.email, password: user.password, admin: user.admin}
      end
      assert_redirected_to home_path
    end

    should 'redirect to home when a user wants to destroy a user' do
      assert_difference('User.count', 0) do
        delete :destroy, id: @user
      end
      assert_redirected_to home_path
    end
  end

end