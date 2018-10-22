require 'rails_helper'

describe Task do

  let(:user) { FactoryBot.create(:user) }
  let(:tags) { FactoryBot.build_list(:tag, 1) }
  let(:task){ Task.create(title: title, description: description, deadline: deadline, user_id: user.id, tags: tags) }

  context "When parameters are filled in with valid values"  do
    let(:title){ "Title" }
    let(:description) { "Description" }
    let(:deadline) { Time.new(2018, 4, 24) }

    it 'is valid with valid values' do
      expect(task).to be_valid
    end
  end

  context "When parameters are not filled in with valud values" do
    let(:title) { nil }
    let(:description) { nil }
    let(:deadline) { nil }

    it 'is invalid without valid values' do
      expect(task).not_to be_valid
    end
  end

  context "When two parameters are filled in with valid values but the other isn't" do
    let(:title) { nil }
    let(:description) { "Description" }
    let(:deadline) { Time.new(2018, 4, 24) }

    it 'is invalid without a title' do
      expect(task).not_to be_valid
    end
  end

  context "When two parameter are filled in with valid values but the other isn't" do
    let(:title) { "Title" }
    let(:description) { nil }
    let(:deadline) { Time.new(2018, 4, 24) }

    it 'is invalid without a description' do
      expect(task).not_to be_valid
    end
  end

  context "When two parameter are filled in with valid values but the other isn't" do
    let(:title) { "Title" }
    let(:description) { "Description" }
    let(:deadline) { nil }

    it 'is invalid without a description' do
      expect(task).not_to be_valid
    end
  end

  describe "Form length validation" do

    context "When title value is too short" do
      let(:title) { "A" }
      let(:description) { "abcde" }
      let(:deadline) { Time.new(2018, 4, 24) }

      it 'should be longer than 2 characters' do
        expect(task).not_to be_valid
      end
    end

    context "When description value is too short" do
      let(:title) { "TITLE" }
      let(:description) { "abcd" }
      let(:deadline) { Time.new(2018, 4, 24) }

      it 'should be longer than 5 letters' do
        expect(task).not_to be_valid
      end
    end
  end

  describe "Form length validation" do
    context "When title value is too long" do
      let(:title) { "a" * 31 }
      let(:description) { "Description" }
      let(:deadline) { Time.new(2018, 4, 24) }

      it 'should be shorter than 30 characters' do
        expect(task).not_to be_valid
      end
    end

    context "When description value is too long" do
      let(:title) {'TITLE'}
      let(:description) { "a" * 101 }
      let(:deadline) { Time.new(2018, 4, 24) }

      it 'should be shorter than 100 characters' do
        expect(task).not_to be_valid
      end
    end
  end

  context "When title and description contain 30 and 100 characters respectively" do
    let(:title) { "A" * 30 }
    let(:description) { "a" * 100 }
    let(:deadline) { Time.new(2018, 4, 24) }

    it 'should be valid' do
      expect(task).to be_valid
    end
  end
end
