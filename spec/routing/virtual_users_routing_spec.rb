require "rails_helper"

RSpec.describe VirtualUsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/virtual_users").to route_to("virtual_users#index")
    end

    it "routes to #new" do
      expect(get: "/virtual_users/new").to route_to("virtual_users#new")
    end

    it "routes to #show" do
      expect(get: "/virtual_users/1").to route_to("virtual_users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/virtual_users/1/edit").to route_to("virtual_users#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/virtual_users").to route_to("virtual_users#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/virtual_users/1").to route_to("virtual_users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/virtual_users/1").to route_to("virtual_users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/virtual_users/1").to route_to("virtual_users#destroy", id: "1")
    end
  end
end
