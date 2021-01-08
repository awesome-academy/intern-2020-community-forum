require "rails_helper"

RSpec.describe Admin::TopicsController, type: :controller do
  let(:user_1) {FactoryBot.create :user, role: "admin"}
  let!(:topic_two) do
    FactoryBot.create :topic,
                      name: "Ngoc Long",
                      created_at: "15-04-2020",
                      updated_at: "15-04-2020",
                      status: "on"
  end
  let!(:topic_three) do
    FactoryBot.create :topic,
                      name: "Minh Thong",
                      created_at: "16-04-2020",
                      updated_at: "16-04-2020"
  end

  describe "Login" do
    before {get :index, params: {page: 1}}

    context "as a guest"  do
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    context "as an  authenticated user" do
      before {login user_1}

      describe "GET #index" do
        before {get :index, params: {page: 1}}

        it {expect(response).to render_template :index}

        it {expect(assigns(:topics).pluck(:id)).to eq [topic_three.id, topic_two.id]}
      end

      describe "GET #edit" do
        context "when valid param" do
          before {get :edit, params: {id: topic_two.id}}

          it "should have a valid course" do
            expect(assigns(:topic).id).to eq topic_two.id
          end

          it "should render edit template" do
            expect(response).to render_template :edit
          end
        end

        context "when invalid param" do
          before {get :edit, params: {id: "abc"}}

          it "should have a invalid post" do
            expect(assigns(:topic)).to eq nil
          end

          it "should redirect to admin_posts_path" do
            expect(response).to redirect_to admin_topics_path
          end
        end
      end

      describe "PATCH #update" do
        context "when valid params" do
          before {patch :update, params: {id: topic_two.id, topic: {name: "Test update"}}}

          it "should correct title" do
            expect(assigns(:topic).name).to eq "Test update"
          end

          it "should redirect admin_posts_path" do
            expect(response).to redirect_to admin_topics_path
          end
        end

        context "when invalid params" do
          before { patch :update, params: {id: topic_two.id, topic: {name: nil}}}

          it "should a invalid post" do
            expect(assigns(:topic).invalid?).to eq true
          end

          it "should render edit template" do
            expect(response).to render_template :edit
          end
        end
      end

      describe "GET #new" do
        before {get :new}
        it "should render new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        let(:topic_params) do
          {
            topic: {
              name: "topic",
              status: "on"
            }
          }
        end
        let(:invalid_topic_params) do
          {
            topic: {
              name: nil,
              status: "on"
            }
          }
        end

        context "when valid params" do
          it "should correct post name" do
            expect{
              post :create, params: topic_params
            }.to change(Topic, :count).by 1
          end

          it "should redirect to admin_posts_path" do
            post :create, params: topic_params
            expect(response).to redirect_to admin_topics_path
          end
        end

        context "when invalid params" do
          before{post :create, params: invalid_topic_params}
          it "should a invalid post" do
            expect{}.to change(Topic, :count).by 0
          end

          it "should render new template" do
            expect(response).to render_template :new
          end
        end
      end

      describe "DELETE #destroy" do
        context "when valid params" do
          before { delete :destroy, params: {id: topic_two.id} }

          it "should correct post" do
            expect(assigns(:topic).destroyed?).to eq true
          end

          it "should redirect to admin_posts_path" do
            expect(response).to redirect_to admin_topics_path
          end
        end

        context "when invalid params" do
          before {delete :destroy, params: {id: "abc"}}

          it "should a invalid post" do
            expect{subject}.to change(Topic, :count).by 0
          end

          it "should redirect to admin_posts_path" do
            expect(response).to redirect_to admin_topics_path
          end
        end

        context "when a failure post destroy" do
          before do
            allow_any_instance_of(Topic).to receive(:destroy).and_return false
            delete :destroy, params: {id: topic_two.id}
          end

          it "flash error message" do
            expect(flash[:alert]).to eq I18n.t("topic.controller.deleted_error")
          end

          it "should redirect to admin_posts_path" do
            expect(response).to redirect_to admin_topics_path
          end
        end
      end

      describe "PATCH #activate" do
        before {patch :activate, params: {id: topic_two.id}}

        it "should change post status" do
          expect(assigns(:topic).status).to eq "off"
        end

        it "should redirect to admin_posts_path" do
          expect(response).to redirect_to admin_topics_path
        end
      end
    end
  end
end
