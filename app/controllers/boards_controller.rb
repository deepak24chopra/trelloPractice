class BoardsController < ApplicationController

    before_action :set_board, only: [:edit,:update,:show]

    def index
    end

    def show
    end

    def new
        @board = Board.new
    end

    def create
        @board = Board.new(board_params)
        @board.user_id = session[:user_id]
        #create board
        board_created = false
        if(@board.save)
            board_created = true
            flash[:success] = "#{@board.title} was successfully created."
            #redirect_to(board_path(@board)) and return
        else
            flash.now[:warning] = "Cannot create board right now."
            render 'new'
        end
        #create permission
        bm_created = false
        if board_created == true
            bm = BoardPermission.new
            bm.user_id = session[:user_id]
            bm.board_id = @board.id
            bm.permission = 2
            bm.save
            bm_created = true
        end
        #create lists
        if bm_created == true
            lists = []
            if params[:feature] == "on"
                lists.push("feature")
            end
            if params[:development] == "on"
                lists.push("development")
            end
            if params[:testing] == "on"
                lists.push("testing")
            end
            if params[:production] == "on"
                lists.push("production")
            end

            if lists.length > 0
                position = 1
                lists.each do  |list|
                    new_list = List.new
                    new_list.board_id = @board.id
                    new_list.title = list
                    new_list.position = position
                    new_list.save
                    position += 1
                end
            end
            flash[:success] = "Board and its lists successfully created."
            redirect_to board_path(@board) and return
        end
        flash.now[:danger] = "Cannot create board right now."
        render 'new'
    end

    def edit
    end

    def update
        if @board.update(board_params)
            flash[:success] = "Board updated successfully."
            redirect_to board_path(@board) and return
        else
            flash.now[:warning] = "Cannot update your board right now."
            render 'edit'
        end
    end

    def destroy
        @board = Board.find(params[:id])
        @board.destroy
        flash[:success] = "Board and its lists have been deleted."
        redirect_to :back and return
    end

    def delete_list
        #redirect_to root_path
    end

    private #--------------------------------------------------------------------

    def board_params
        params.require(:board).permit(:title,:user_id)
    end

    def set_board
        @board = Board.includes(:lists).find(params[:id])
    end

    def board_owner
        if @board.user_id != session[:user_id]
            flash[:info] = "You cannot perform any action on this board."
            redirect_to boards_path and return
        end
    end

end