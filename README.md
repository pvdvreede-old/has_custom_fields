# has_custom_fields

Rails plugin that allows any model to use custom fields. These fields can be dynamically created or manually created by you inserting records into the custom field tables.

This means that you can build a web interface to create the custom fields, or programmatically insert them.

## Installation

This is a rails plugin so it can be mounted like any other engine.

## Usage

Add custom fields to a model:

```ruby
class MyModel < ActiveRecord::Base

  has_custom_fields

end
```

Reference any custom field if you know the name via the normal ruby method API:

```ruby
model = MyModel.new
model.a_custom_field = "a custom value"
```

You can check if a certain model has a custom field:

```ruby
model.has_custom_field?("A custom field") # OR
model.has_custom_field?(:a_custom_field)
```

You can loop over all the custom fields and values for that model:

```ruby
model.for_custom_fields do |name, value, type|
  puts "The custom field #{name} has a value of #{value} and is of type #{type}."
end
```

### Options

The following options are available to be set and passed in with the `has_custom_fields` call:

* :allow_dynamic_creation - Either true or false (default false). When set to true, it will allow dyanmic creation of fields by simply using the ruby method API to set one, eg. model.this_will_be_created = "hello" will create a custom field with the name "This will be created" and a value of "hello". The type of the field will be infered from the data type being set.
* :further_filter_by - Symbol that refers to an id field on the current model. This can be used where a custom field belongs to another model but needs to be shown and edited on this model. When this is used, the `belongs_to_id` on the CustomField model must be set to the owning model's instance id.

## License

has_custom_fields is available under the MIT license.

```
Copyright 2013 Paul Van de Vreede

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```