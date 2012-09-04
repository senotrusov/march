class Ability
  include CanCan::Ability

  # [:index, :show, :new, :edit, :create, :update, :destroy]
  def initialize poster
    can [:index, :show, :new, :create], :documents
    can [:edit, :update, :destroy], :documents, :poster_id => poster.id if poster

    can [:show], :sections
    can [:show], :paragraphs
  end
end

