
require 'rails_helper'

RSpec.describe Bus, type: :model do
  let(:bus_owner) { BusOwner.new(name: "Angad", email: "owner@gmail.com", password: "password", password_confirmation: "password", user_type: "bus_owner") }

  before do
    @bus = Bus.new(
      name: "Volvo Bus",
      route: "Patna - Delhi",
      total_seat: 50,
      registration_no: "AB1243242345",
      bus_owner: bus_owner
    )
  end

  it "is valid with valid attributes" do
    expect(@bus).to be_valid
  end

  it "is not valid without a name" do
    @bus.name = ""
    expect(@bus).not_to be_valid
  end

  it "is not valid without a route" do
    @bus.route = ""
    expect(@bus).not_to be_valid
  end

  it "is not valid without a total_seat" do
    @bus.total_seat = nil
    expect(@bus).not_to be_valid
  end

  it "is not valid without a registration_no" do
    @bus.registration_no = ""
    expect(@bus).not_to be_valid
  end

  it "is not valid with a duplicate registration_no" do
    duplicate_bus = @bus.dup
    @bus.save
    expect(duplicate_bus).not_to be_valid
  end

  it "disapproves a bus" do
    @bus.approved = true
    @bus.disapprove!
    expect(@bus.approved).to be_falsey
  end

  it "approves a bus" do
    @bus.approved = false
    @bus.approve!
    expect(@bus.approved).to be_truthy
  end

  it "creates seats after creating a bus" do
    expect { @bus.save }.to change(Seat, :count).by(50)
  end

  it "adjusts seats when total_seat is updated" do
    @bus.save
    @bus.update(total_seat: 40)
    expect(@bus.seats.count).to eq(40)
  end

  it "deletes seats when a bus is destroyed" do
    @bus.save
    expect { @bus.destroy }.to change(Seat, :count).by(-50)
  end

  it "sends approval email after updating approval status" do
    expect { @bus.approve! }.to have_enqueued_job(ApprovalEmailsJob).with(@bus)
  end

end
