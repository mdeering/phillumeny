# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Post, type: :model do

  [[:include_in_sitemap, :published_at], :published_at].each do |columns|
    it { should cover_query_with_indexes(columns) }
  end

  {
    include_in_sitemap:       true,
    sitemap_change_frequency: 'monthly',
    sitemap_priorty:          5,
    title:                    nil
  }.each do |attribute, value|
    it { should have_default_value_of(value).for(attribute).in_the_database }
  end

end
