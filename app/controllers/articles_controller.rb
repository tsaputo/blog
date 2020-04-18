class ArticlesController < ApplicationController

    before_action :logged_in_user, only: [ :new, :edit, :create, :update, :destroy]
    before_action :load_article, only: [ :show, :edit, :update, :destroy]
    before_action :check_article_owner, only: [ :edit, :update, :destroy]

 
    def index
        @articles = Article.all
        @articles = Article.search(params[:token]) if (params[:token])
        @articles = Article.includes(:user).paginate(page: params[:page])
    end

    def show
 #       @article = Article.find(params[:id])
        @comments = @article.comments.paginate(page: params[:page])
        if (@comments.empty?)
            @comments = @article.comments.paginate(page: @comments.total_pages)
        end
    end

    def new
        @article = Article.new
    end

    def edit
 #       @article = Article.find(params[:id])
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
#        @article = Article.find(params[:id])
      
        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
    end

    def destroy       
        #@article = Article.find(params[:id])
        #binding.pry
        if (@article.user_id == current_user.id)
  
            @article.destroy
        end    
        redirect_to articles_path
    end
    
    private
    def article_params
        params.require(:article).permit(:title, :text)
    end

    def check_article_owner
        # @article = Article.find(params[:id])
        if (@article.user != current_user)
            flash[:danger] = "You dont have permission to modify this article"   
            redirect_to @article
        end
    end

    def load_article
        @article = Article.find(params[:id])
    end

end
