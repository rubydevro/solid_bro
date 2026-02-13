SolidBro::Engine.routes.draw do
  root to: "jobs#index"

  resources :jobs, only: [:index, :show], path: "jobs" do
    member do
      put :retry
      delete :discard
    end
  end

  resources :queues, only: [:index] do
    member do
      put :pause
      put :resume
      delete :destroy_jobs
    end
  end

  resources :processes, only: [:index], path: "workers"
  resources :recurring_tasks, only: [:index], path: "recurring-tasks"
end
