# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is not valid without a password' do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    create(:user, email: 'test@example.com')
    user = build(:user, email: 'test@example.com')
    expect(user).not_to be_valid
  end

  it 'can have many attached files' do
    user = create(:user)

    user.files.attach(fixture_file_upload('test_file.txt', 'text/plain'))
    user.files.attach(fixture_file_upload('test_file_2.txt', 'text/plain'))

    expect(user.files.count).to eq(2)
  end
end
