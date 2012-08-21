
# Copyright (c) 2004-2011 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


class ActiveRecord::Associations::Association
  private

  def find_target?
    # TODO: Think and submit patch to rails
    #
    # In case of paragraph and section models primary key (checked in foreign_key_present?) may be NULL
    #
    # Original code was:
    # !loaded? && (!owner.new_record? || foreign_key_present?) && klass
    !loaded? && foreign_key_present? && klass
  end
end



# Find, then associacion call:

  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1139:in `async_exec'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1139:in `exec_no_cache'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:663:in `block in exec_query'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract_adapter.rb:280:in `block in log'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activesupport-3.2.2/lib/active_support/notifications/instrumenter.rb:20:in `instrument'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract_adapter.rb:275:in `log'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:662:in `exec_query'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1234:in `select'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract/database_statements.rb:18:in `select_all'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract/query_cache.rb:63:in `select_all'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/querying.rb:38:in `block in find_by_sql'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/explain.rb:40:in `logging_query_plan'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/querying.rb:37:in `find_by_sql'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:171:in `exec_queries'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:160:in `block in to_a'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/explain.rb:33:in `logging_query_plan'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:159:in `to_a'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:159:in `all'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/collection_association.rb:380:in `find_target'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/collection_association.rb:333:in `load_target'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/collection_proxy.rb:44:in `load_target'
  # from /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/collection_proxy.rb:87:in `method_missing'


# paragraphs with NULL in line_id are not eager loaded because of .compact of owner_keys in
# activerecord-3.2.2/lib/active_record/associations/preloader/association.rb:80:in `associated_records_by_owner'

# Find with include:

#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1139:in `async_exec'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1139:in `exec_no_cache'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:663:in `block in exec_query'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract_adapter.rb:280:in `block in log'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activesupport-3.2.2/lib/active_support/notifications/instrumenter.rb:20:in `instrument'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract_adapter.rb:275:in `log'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:662:in `exec_query'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/postgresql_adapter.rb:1234:in `select'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract/database_statements.rb:18:in `select_all'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/connection_adapters/abstract/query_cache.rb:63:in `select_all'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/querying.rb:38:in `block in find_by_sql'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/explain.rb:40:in `logging_query_plan'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/querying.rb:37:in `find_by_sql'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:171:in `exec_queries'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:160:in `block in to_a'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/explain.rb:40:in `logging_query_plan'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:159:in `to_a'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/delegation.rb:6:in `to_ary'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader/association.rb:80:in `flatten'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader/association.rb:80:in `associated_records_by_owner'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader/collection_association.rb:13:in `preload'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader/association.rb:19:in `run'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:128:in `block (2 levels) in preload_one'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:127:in `each'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:127:in `block in preload_one'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:126:in `each'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:126:in `preload_one'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:105:in `preload'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:94:in `block in run'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:94:in `each'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/associations/preloader.rb:94:in `run'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:181:in `block in exec_queries'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:180:in `each'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:180:in `exec_queries'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:160:in `block in to_a'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/explain.rb:33:in `logging_query_plan'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation.rb:159:in `to_a'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:377:in `find_first'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:122:in `first'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:335:in `find_one'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:311:in `find_with_ids'
#   /home/foo/.gem/ruby-1.9.3-p194/gems/activerecord-3.2.2/lib/active_record/relation/finder_methods.rb:107:in `find'
