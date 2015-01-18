class ReadMark < ActiveRecord::Base
  belongs_to :readable, :polymorphic => true
  attr_accessible :readable_id, :user_id, :readable_type, :timestamp

  validates_presence_of :user_id, :readable_type
  sync :all
  sync_scope :by_user, ->(user) { where(user_id: user.id)}
  
  scope :global, lambda { where(:readable_id => nil) }
  scope :single, lambda { where('readable_id IS NOT NULL') }
  scope :older_than, lambda { |timestamp| where([ 'timestamp < ?', timestamp ]) }

  # Returns the class defined by acts_as_reader
  def self.reader_class
    reflect_on_all_associations(:belongs_to).find { |assoc| assoc.name == :user }.try(:klass)
  end

  class_attribute :readable_classes
end
