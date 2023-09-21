
require 'rails_helper'


describe Bus do

  before do
    @bus = FactoryBot.create(:bus)
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
    duplicate_bus.save
    expect(duplicate_bus).not_to be_valid
  end
  
  it "approves and send email" do
    @bus.approved = false
    expect {@bus.approve!}.to have_enqueued_job(ApprovalEmailsJob).on_queue("default")
    expect(@bus.approved).to be_truthy
  end

  it "disapproves and delete all reservations and send email" do
    @bus.approved = true
    expect{@bus.disapprove! }.to have_enqueued_job(ApprovalEmailsJob).on_queue("default")
    expect(@bus.approved).to be_falsey
    expect(@bus.reservations.count).to eq(0)
  end

  it "creates seats after creating a bus" do
    @bus.save
    expect(@bus.seats.count).to eq(@bus.total_seat)
  end

  it "adjusts seats when total_seat is updated" do
    @bus.save
    @bus.update(total_seat: 40)
    expect(@bus.seats.count).to eq(40)
  end

  it "deletes seats when a bus is destroyed" do
    @bus.save
    @bus.destroy
    expect(@bus.seats.count).to eq(0)
  end

end
