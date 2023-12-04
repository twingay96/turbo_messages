class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.order(created_at: :desc) # asc: 오름차순 
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_message', partial: "messages/form" ,locals: {message: Message.new}),
            # update : 특정 요소를 바꿈
            # new_message -> 터보스트림으로 바꿀 html요소(div id="new_message") , partial -> 바꾼 html 요소안에 넣을 템플릿 , locals-> 템플릿에 전달할 로컬변수(비어있는 폼)
            turbo_stream.prepend('messages', partial: "messages/message" ,locals: {message: @message}),
            # prepend : 특정 요소의 맨위에 추가
            # messages-> index 페이지의 html요소(div id="messages"), partial-> 추가할 위치에 넣을 템플릿, locals-> 템플릿에 전달할 변수(submit한객체)
          ]
        end
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_message', 
                                  partial: "messages/form" ,
                                  locals: {message: @message})
            # element_id -> 터보스트림으로 바꿀 html요소 , partial -> 바꾼 html 요소안에 넣을 템플릿 , locals-> 템플릿에 전달할 로컬변수
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body)
    end
end
