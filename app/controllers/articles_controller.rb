class ArticlesController < ApplicationController

    before_action :logged_in_user, only: [ :new, :edit, :create, :update, :destroy]
 
    #переписать!
    def index
        @articles = if (params[:token])
            Article.search(params[:token]).paginate(page: params[:page])
        else  
            Article.all.order(created_at: :desc).paginate(page: params[:page])
        end
      end

    def show
        @article = Article.find(params[:id])
        @comments = @article.comments.paginate(page: params[:page])
        if (@comments.empty?)
            @comments = @article.comments.paginate(page: @comments.total_pages)
        end
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