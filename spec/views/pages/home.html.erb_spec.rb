require 'rails_helper'

RSpec.describe "pages/home.html.erb", type: :view do
  it "works" do
    render
    expect(rendered).to match(/Hello! You are on a secret page/)
  end
end
