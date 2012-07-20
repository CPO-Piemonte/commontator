require 'spec_helper'
require 'acts_as_votable'

module Commontator
  describe Comment do
    before do
      setup_model_spec
      @comment = Comment.new
      @comment.thread = @thread
      @comment.creator = @user
      @comment.body = 'Something'
    end
    
    it 'must be votable if acts_as_votable is installed' do
      Comment.must_respond_to(:acts_as_votable)
      @comment.is_votable?.must_equal true
      @comment.acts_as_votable_initialized.must_equal true
    end
    
    it 'must know if it has been modified' do
      @comment.save!
      
      @comment.is_modified?.must_equal false
      
      sleep 1
      @comment.body = 'Something else'
      @comment.save!
      
      @comment.is_modified?.must_equal true
    end
    
    it 'must know if it has been deleted' do
      user = DummyUser.new
      
      @comment.is_deleted?.must_equal false
      @comment.deleter.must_be_nil
      
      @comment.delete(user)
      
      @comment.is_deleted?.must_equal true
      @comment.deleter.must_equal user
      
      @comment.undelete
      
      @comment.is_deleted?.must_equal false
    end
    
    it 'must make proper timestamps' do
      @comment.save!
      
      @comment.timestamp.must_equal "#{@thread.config.comment_create_verb_past.capitalize} on #{@comment.created_at.strftime(@thread.config.timestamp_format)}"
      
      sleep 1
      @comment.body = 'Something else'
      @comment.save!
      
      @comment.timestamp.must_equal "Last modified on #{@comment.updated_at.strftime(@thread.config.timestamp_format)}"
    end
  end
end
