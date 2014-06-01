#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'my_translation_helper'

class TranslationTests < ActionView::TestCase

  include MyTranslationHelper

  test "frog" do
    assert_equal "frog", translate_avatar('frog')
  end

end
