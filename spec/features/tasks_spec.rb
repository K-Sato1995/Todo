require 'rails_helper'

feature 'Tasks', type: :feature do

  describe 'The order of tasks by deadline' do

  let(:user) { FactoryBot.create(:user) }
  let(:tags) { FactoryBot.build_list(:tag, 1) }

  before(:each) do
    FactoryBot.create(:task, title:'task_2018_04_22_P1', deadline: Time.new(2018, 4, 22), priority: 0 , user_id: user.id, tags: tags)
    FactoryBot.create(:task, title:'task_2018_04_25_P2', deadline: Time.new(2018, 4, 25), priority: 1 , user_id: user.id, tags: tags)
    FactoryBot.create(:task, title:'task_2018_04_24_P3', deadline: Time.new(2018, 4, 24), priority: 2 , user_id: user.id, tags: tags)
  end

  context "When a user is loged in" do

    before(:each) do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit root_path
    end

    it 'should be sorted descendingly by default' do
      visit root_path
      expect(all('.title_box')[0]).to have_content('task_2018_04_25_P2')
      expect(all('.title_box')[1]).to have_content('task_2018_04_24_P3')
      expect(all('.title_box')[2]).to have_content('task_2018_04_22_P1')
    end

    context "When '終了期限' is clicked" do
      before do
        visit root_path
        click_link('終了期限')
      end

      context "When '終了期限' is clicked at even number of times" do
        it 'should be sorted ascendingly by deadline' do
          expect(all('.title_box')[0]).to have_content('task_2018_04_22_P1')
          expect(all('.title_box')[1]).to have_content('task_2018_04_24_P3')
          expect(all('.title_box')[2]).to have_content('task_2018_04_25_P2')
        end
      end

      context "When '終了期限' is clicked at odd number of times" do
        it 'should be sorted descendingly by deadline' do
          click_link('終了期限')
          expect(all('.title_box')[0]).to have_content('task_2018_04_25_P2')
          expect(all('.title_box')[1]).to have_content('task_2018_04_24_P3')
          expect(all('.title_box')[2]).to have_content('task_2018_04_22_P1')
        end
      end
    end

    describe 'The order of tasks by priority' do

      context "When '優先度' is clicked" do
        before do
          visit root_path
          click_link('優先度')
        end
        context "When '優先度' is clicked at odd number of times" do
          it 'should be sorted ascendingly by priority' do
            expect(all('.title_box')[0]).to have_content('task_2018_04_22_P1')
            expect(all('.title_box')[1]).to have_content('task_2018_04_25_P2')
            expect(all('.title_box')[2]).to have_content('task_2018_04_24_P3')
          end
        end

        context "When '優先度' is clicked at even number of times" do
          it 'should be sorted descendingly by priority' do
            click_link('優先度')
            expect(all('.title_box')[0]).to have_content('task_2018_04_24_P3')
            expect(all('.title_box')[1]).to have_content('task_2018_04_25_P2')
            expect(all('.title_box')[2]).to have_content('task_2018_04_22_P1')
          end
        end
      end
    end

    describe 'Createing a new task' do
      let(:new_path){ 'tasks/new' }
      context 'When a user visits the new page from the index page to create a task' do
        before(:each) do
          visit new_path
          fill_in 'タイトル', with: 'Task'
          fill_in '詳細', with: 'Description'
          fill_in '終了期限', with: "2013,December,7"
          fill_in 'カテゴリー(, で区切って入力してください。)', with: 'サッカー,野球,テニス'
        end
        it "creates a task as '登録する' is clicked" do
          expect { click_on '登録する' }.to change { Task.count }.by(1)
          expect(page).to have_content 'タスクの作成が成功しました。'
          expect(page).to have_content 'Task'
          expect(page).to have_content '2013年12月07日'
        end
      end
    end

    describe 'Deleting a task' do
      before(:each) do
        visit root_path
      end
      it "deletes a task as the '削除' is clicked" do
        expect { click_link('削除', match: :first) }.to change { Task.count }.by(-1)
        expect(page).to have_content 'タスクの削除が完了しました。'
      end
    end

    describe 'Updating a task' do
      let(:edit_path){ "tasks/#{@original_task.id}/edit/" }
      before(:each) do
        @original_task = FactoryBot.create(:task, user_id: user.id, tags: tags)
        visit edit_path
        fill_in 'タイトル', with: 'New_title'
        fill_in '詳細', with: 'New_description'
        click_on '更新する'
      end
      it 'updaes a task' do
        expect(page).to have_content 'タスクの編集が成功しました。'
        expect(page).to have_content 'New_title'
      end
    end
    describe 'Task Search' do
      let!(:task1){ (FactoryBot.create(:task, title:'aaa', state: 0, priority: 0, user_id: user.id, tags: tags)) }
      let!(:task2){ (FactoryBot.create(:task, title:'sss', state: 1, priority: 1, user_id: user.id, tags: tags)) }
      let!(:task3){ (FactoryBot.create(:task, title:'iii', state: 2, priority: 2, user_id: user.id, tags: tags)) }
      let!(:task4){ (FactoryBot.create(:task, title:'abc2', state: 2, priority: 2, user_id: user.id, tags: tags)) }

        context 'When a user searches tasks only by title' do
          before do
            visit root_path
            fill_in 'タイトル名', with: 'a'
            click_on '検索'
          end
          it "should only display tasks which includes 'a' " do
            expect(page).to have_content 'aaa'
          end
        end

        context 'When a user searches tasks only by state' do
          before do
            visit root_path
            find("option[value='2']", text: '完了').select_option
            click_on '検索'
          end
          it "should only display tasks which state is '完了' " do
            expect(page).to have_content 'iii'
          end
        end

        context 'When a user searches tasks by title and state' do
          before do
            visit root_path
            fill_in 'タイトル名', with: 'a'
            find("option[value='2']", text: '完了').select_option
            click_on '検索'
          end
          it "should only display tasks which includes 'a' and whitch state is '完了' " do
            expect(page).to have_content 'abc2'
          end
        end

        context 'When a user searches tasks by priority' do
          before do
            visit root_path
            find("option[value='1']", text: '高い').select_option
            click_on '検索'
          end
          it "should only display wich includes '高い' " do
            expect(page).to have_content 'sss'
          end
        end

        context 'When a user searches tasks by title and priority ' do
          before do
            visit root_path
            fill_in 'タイトル名', with: 'a'
            find("option[value='0']", text: '普通').select_option
            click_on '検索'
          end
          it "should only display wich includes '普通' " do
            expect(page).to have_content 'aaa'
          end
        end

        context 'When a user searches tasks by state and priority ' do
          before do
            visit root_path
            find("option[value='2']", text: '完了').select_option
            find("option[value='2']", text: '至急').select_option
            click_on '検索'
          end
          it "should only display wich includes '至急' and which state is '完了' " do
            expect(page).to have_content 'abc2'
          end
        end
      end
    end
  end
end
