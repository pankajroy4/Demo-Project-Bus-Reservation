require "rails_helper"

RSpec.describe BusesController, type: :controller do
  let(:bus_owner) { create(:bus_owner) }
  let(:admin) { create(:admin) }
  let(:bus) { create(:bus, bus_owner: bus_owner) }
  let(:date) { Date.today }

  before do
    sign_in(bus_owner, scope: :bus_owner)
  end

  describe "GET #reservations_list" do
    it "returns a success response" do
      get :reservations_list, params: { bus_id: bus.id, date: date }
      expect(response).to be_successful
      expect(assigns(:reservations)).to match_array(nil)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: { bus_owner_id: bus_owner.id }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    before do
      get :show, params: { bus_owner_id: bus_owner.id, id: bus.id }
    end
    it { should render_template("show") }
    it { should route(:get, "/buses/1").to(action: :show, id: 1) }
    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new bus" do
        expect {
          post :create, params: { bus_owner_id: bus_owner.id, bus: attributes_for(:bus) }
        }.to change(Bus, :count).by(1)
      end

      it "redirects to the bus_owner path" do
        post :create, params: { bus_owner_id: bus_owner.id, bus: attributes_for(:bus) }
        expect(response).to redirect_to(bus_owner_path(bus_owner))
      end
    end

    context "with invalid parameters" do
      it "does not create a new bus" do
        expect {
          post :create, params: { bus_owner_id: bus_owner.id, bus: attributes_for(:bus, name: nil) }
        }.not_to change(Bus, :count)
      end

      it "renders the new template with unprocessable_entity status" do
        post :create, params: { bus_owner_id: bus_owner.id, bus: attributes_for(:bus, name: nil) }
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET #index" do
    context "as bus owner" do
      before do
        get :index, params: { bus_owner_id: bus_owner.id }
      end
      it { should render_template("index") }
      it { should route(:get, "/buses").to(action: :index) }
      it { is_expected.to respond_with 200 }
      it { expect(assigns(:buses)).to match_array(bus) }
    end

    context "as admin" do
      before do
        sign_in(admin, scope: :user)
        get :index, params: { bus_owner_id: bus_owner.id }
      end
      it { should render_template("index") }
      it { should route(:get, "/buses").to(action: :index) }
      it { is_expected.to respond_with 200 }
      it { expect(assigns(:buses)).to match_array(bus) }
    end
  end

  describe "GET #edit" do
    before do
      get :edit, params: { bus_owner_id: bus_owner.id, id: bus.id }
    end
    it { should render_template("edit") }
    it { should route(:get, "/buses/1/edit").to(action: :edit, id: 1) }
    it { should respond_with(200) }
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the bus" do
        patch :update, params: { bus_owner_id: bus_owner.id, id: bus.id, bus: {
                         name: "New Bus Name",
                       } }
        bus.reload
        expect(bus.name).to eq("New Bus Name")
      end

      it "redirects to the bus path" do
        patch :update, params: { bus_owner_id: bus_owner.id, id: bus.id, bus: {
                         name: "New Bus Name",
                       } }
        expect(response).to redirect_to(bus_owner_bus_path(bus_owner, bus))
      end
    end

    context "with invalid parameters" do
      it "does not update the bus" do
        original_name = bus.name
        patch :update, params: { bus_owner_id: bus_owner.id, id: bus.id, bus: {
                         name: nil,
                       } }
        bus.reload
        expect(bus.name).to eq(original_name)
      end

      it "renders the edit template with unprocessable_entity status" do
        patch :update, params: { bus_owner_id: bus_owner.id, id: bus.id, bus: {
                         name: nil,
                       } }
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the bus" do
      bus
      expect {
        delete :destroy, params: { bus_owner_id: bus_owner.id, id: bus.id }
      }.to change(Bus, :count).by(-1)
    end

    it "redirects to the bus_owner buses path" do
      bus
      delete :destroy, params: { bus_owner_id: bus_owner.id, id: bus.id }
      expect(response).to redirect_to(bus_owner_buses_path(bus_owner))
    end
  end
end
