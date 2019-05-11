require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  it "works" do
    assign(:session, Session.new)
    render
    expect(rendered).to match(/Please, login/)
  end
end
