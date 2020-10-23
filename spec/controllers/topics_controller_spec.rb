require "rails_helper"

RSpec.describe TopicsController, type: :controller do
  let!(:user_1) {FactoryBot.create :user, role: "admin"}

  describe "Login" do
    before {logout user_1}
    before {get :index, params: {user_id: user_1.id}}

    context "as a guest"  do
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    context "as an  authenticated user" do
      before {login user_1}

      describe "GET #index" do
        let!(:topic_1) {FactoryBot.create :topic}

        before {get :index, params: {user_id: user_1.id}}

        it {expect(response).to render_template :index}

        it {expect(assigns(:topics).pluck(:id)).to eq [topic_1.id]}
      end

      describe "GET #show" do
        let!(:topic_1) {FactoryBot.create :topic}

        before {get :show, params: {id: topic_1.id}}

        it {expect(response).to render_template :show}

        it {expect(assigns(:topic).id).to eq topic_1.id}
      end
    end
  end
end
