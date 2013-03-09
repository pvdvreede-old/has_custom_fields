require 'spec_helper'

describe 'Custom field options' do

  describe 'Allow dynamic creation of fields' do

    context 'enable dynamic field creation' do

      before :each do
        @item = FactoryGirl.create :item_with_dynamic_creation
        @record = ItemWithDynamicCreation.find @item.id
        @record.new_field = "new field value"
        @record.save!
        @new_field = HasCustomFields::CustomField.where(
          :belongs_to => @record.class.name,
          :field_name => 'New field'
        ).first
      end

      it 'should have created a new custom field' do
        @new_field.should_not be_nil
      end

      it 'should have created a new custom field value' do
        value_field = HasCustomFields::CustomFieldValue.where(
          :belongs_to_id => @record.id,
          :custom_field_id => @new_field.id
        ).first

        value_field.should_not be_nil
      end

      it 'should allow retrieval of dynamically created field' do
        @record.new_field.should eq "new field value"
      end

      it 'should throw no method error when requesting a non existant field' do
        expect { @record.i_dont_exist }.to raise_error NoMethodError
      end

    end

    context 'disable dynamic field creation' do
      before :each do
        @item = FactoryGirl.create :test_item
        @record = ::TestItem.find @item.id
      end

      it 'should raise NoMethodError when a non existant custom field is called' do
        expect { @record.new_custom_field = "test" }.to raise_error NoMethodError
      end
    end
  end

end