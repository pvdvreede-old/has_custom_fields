require 'spec_helper'

describe HasCustomFields::CustomFields do

  before :each do
    @custom_fields = []
    @custom_values = []
    @item = FactoryGirl.create :test_item
    @custom_field_1 = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
    @custom_fields << @custom_field_1
    @record = ::TestItem.find @item.id
  end

  describe '#find_custom_values' do
    context 'when there is no value entered' do
      it 'should select the custom field when queried' do
        @record.public_send(@custom_field_1.field_name.from_sentance_to_snake_case.to_sym).should eq nil
      end
    end

    context 'when there is a value entered' do
      before :each do
        @custom_field_1_value = FactoryGirl.create :has_custom_fields_custom_field_value, :custom_field => @custom_field_1
      end

      it 'should select the custom field and return the value' do
        @record.public_send(@custom_field_1.field_name.from_sentance_to_snake_case.to_sym).should eq @custom_field_1_value.field_value
      end
    end
  end

  describe '#save_custom_values' do

    context 'when no custom field has been changed' do
      before :each do
        @record.number_field = 9999
      end

      it 'should save without issue' do
        expect { @record.save! }.to_not raise_error
        ::TestItem.find(@record.id).number_field.should eq 9999
      end

      it 'should not create a value field' do
        HasCustomFields::CustomField.where(:belongs_to_id => @record.id).first.should be_nil
      end

    end

    context 'when a custom field has been changed' do
      before :each do
        @record.a_field = "hello"
        @record.public_send((@custom_field_1.field_name.from_sentance_to_snake_case + "=").to_sym, "value 1")
      end

      it 'should save without issue' do
        expect { @record.save! }.to_not raise_error
        ::TestItem.find(@record.id).a_field.should eq "hello"
      end

      it 'should save a value for the custom field' do
        expect { @record.save! }.to_not raise_error
        value_field = HasCustomFields::CustomFieldValue.where(
          :belongs_to_id => @record.id,
          :custom_field_id => @custom_field_1.id
        ).first
        value_field.should_not be_nil
        value_field.field_value.should eq "value 1"
      end
    end

    context 'when several custom fields have been changed' do
      before :each do
        @custom_field_2 = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
        @custom_field_3 = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
        @record = ::TestItem.find @item.id
        @record.a_field = "hello123"
        @record.public_send((@custom_field_1.field_name.from_sentance_to_snake_case + "=").to_sym, "value 1")
        @record.public_send((@custom_field_2.field_name.from_sentance_to_snake_case + "=").to_sym, "value 2")
        @record.public_send((@custom_field_3.field_name.from_sentance_to_snake_case + "=").to_sym, "value 3")
      end

      it 'should save without issue' do
        expect { @record.save! }.to_not raise_error
        ::TestItem.find(@record.id).a_field.should eq "hello123"
      end

      it 'should save a value for the custom field' do
        expect { @record.save! }.to_not raise_error
        value_field = HasCustomFields::CustomFieldValue.where(
          :belongs_to_id => @record.id,
          :custom_field_id => @custom_field_1.id
        ).first
        value_field.should_not be_nil
        value_field.field_value.should eq "value 1"

        value_field = HasCustomFields::CustomFieldValue.where(
          :belongs_to_id => @record.id,
          :custom_field_id => @custom_field_2.id
        ).first
        value_field.should_not be_nil
        value_field.field_value.should eq "value 2"

        value_field = HasCustomFields::CustomFieldValue.where(
          :belongs_to_id => @record.id,
          :custom_field_id => @custom_field_3.id
        ).first
        value_field.should_not be_nil
        value_field.field_value.should eq "value 3"
      end
    end
  end

  describe '#has_custom_field?' do

    context 'when it is not present' do
      it 'should return false' do
        @record.has_custom_field?("I dont exist").should eq false
      end
    end

    context 'when it is present' do
      it 'should return true' do
        @record.has_custom_field?(@custom_field_1.field_name).should eq true
      end
    end
  end

  describe '#for_custom_fields' do
    before :each do
      @second_item = FactoryGirl.create :test_item
      @second_record = ::TestItem.find @second_item.id
    end

    context 'when a block is not provided' do
      it 'should raise an error' do
        expect { @second_record.for_custom_fields }.to raise_error
      end
    end

    context 'when there is one custom field' do

      it 'should yield 1 times' do
        yield_count = 0
        @second_record.for_custom_fields do |name, value, type|
          yield_count += 1
        end
        yield_count.should eq 1
      end

    end

    context 'when there are 4 fields with no values' do
      before :each do
        @custom_field_2 = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
        @custom_field_3 = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
        @record = ::TestItem.find @item.id
      end

      it 'should yield 3 times' do
        yield_count = 0
        @record.for_custom_fields do |name, value, type|
          yield_count += 1
          value.should eq ""
          type.should eq "string"
        end
        yield_count.should eq 3
      end

      it 'should have the correct values yielded' do
        @record.for_custom_fields do |name, value, type|
          value.should eq ""
          type.should eq "string"
        end
      end

    end

    context 'when there are 4 fields with values' do
      before :each do
        3.times do |i|
          custom_field = FactoryGirl.create :has_custom_fields_custom_field, :belongs_to => @item.class.name
          @custom_values << FactoryGirl.create(:has_custom_fields_custom_field_value, { :custom_field => custom_field, :belongs_to_id => @item.id, :field_value => "value #{i.to_s}" })
          @custom_fields << custom_field
        end
        @record = ::TestItem.find @item.id
      end

      it 'should yield 4 times' do
        yield_count = 0
        @record.for_custom_fields do |name, value, type|
          yield_count += 1
        end
        yield_count.should eq 4
      end

      it 'should yield the correct values' do
        yield_count = 0
        @record.for_custom_fields do |name, value, type|
          @custom_fields[yield_count].field_name.should eq name
          yield_count += 1
        end
        yield_count.should eq 4
      end

    end
  end


end