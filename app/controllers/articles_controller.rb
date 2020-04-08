class ArticlesController < ApplicationController

    before_action :logged_in_user, only: [ :new, :edit, :create, :update, :destroy]

    def index
        @articles = if (params[:token])
            Article.all.search(params[:token])
        else  
            Article.all
        end
      end

    def show
        @article = Article.find(params[:id])
    end

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def create
        @article = current_user.articles.new(article_params)
        
        if @article.save
            redirect_to @article
        else
            render 'new'
        end
    end

    def update
        @article = Article.find(params[:id])
      
        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
      
        redirect_to articles_path
    end
    
    private
    def article_params
        params.require(:article).permit(:title, :text)
    end
end
