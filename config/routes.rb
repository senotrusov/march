
# The priority is based upon order of creation:
# first created -> highest priority.

# See how all your routes lay out with "rake routes"

March::Application.routes.draw do

  # /n
  # /n/new
  # /n/500
  # /n/500/edit

  # /n/500/sections/new
  # /n/sections/600
  # /n/sections/600/edit

  # /n/sections/600/paragraphs/new
  # /n/paragraphs/700
  # /n/paragraphs/700/edit

  scope ':board_slug' do
    resources :paragraphs, except: [:index, :new]

    resources :sections, except: [:index, :new] do
      resources :paragraphs, only: [:new]
    end

    resources :documents, path: '' do
      resources :sections, only: [:new]
    end
  end


  if root_board = Board.where(root: true).first.slug
    root :to => redirect("/#{root_board}")
  end
end
