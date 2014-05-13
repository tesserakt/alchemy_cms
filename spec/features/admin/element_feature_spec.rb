require 'spec_helper'

def create_article_element!
  within '.new_alchemy_element' do
    select('Article', from: 'element[name]')
    click_button 'Add'
  end
end

describe 'element', js: true do
  let(:a_page) { FactoryGirl.create(:page) }
  before { authorize_as_admin }

  describe 'creation' do
    before { visit edit_admin_page_path(a_page) }

    context 'when no element exists yet' do
      before do
        within ".alchemy-elements-window" do
          expect(page).to have_no_selector('.element_editor')
          click_link Alchemy::I18n.t("New Element")
        end
        create_article_element!
        expect(page).to have_no_selector(".spinner") # wait until spinner disappears
      end

      it "adds a new element to the list" do
        expect(page).to have_selector(".element_editor", count: 1)
      end
    end

    context 'when creating more than one' do
      before do
        within ".alchemy-elements-window" do
          expect(page).to have_no_selector('.element_editor')
        end

        2.times do
          within ".alchemy-elements-window" do
            click_link Alchemy::I18n.t("New Element")
          end
          create_article_element!
          expect(page).to have_no_selector(".spinner") # wait until spinner disappears
        end
      end

      it "adds a new element to the list" do
        expect(page).to have_content Alchemy::I18n.t(:successfully_added_element)
        expect(page).to have_selector(".element_editor", count: 2)
      end

      context 'after deleting one of the existing' do
        before do
          within ".alchemy-elements-window .element_editor:first" do
            click_link Alchemy::I18n.t("trash element")
          end
        end

        it "removes the element from the list" do
          expect(page).to have_selector(".element_editor", count: 1)
        end
      end

    end
  end
end
