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

  # GET /messages/1/edit -> routes에서 Post로 임의로 수정함
  def edit
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: [
          turbo_stream.update(@message, partial: "messages/form", locals: {message: @message})
        ]
      end
    end
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
            # new_message -> 터보스트림으로 바꿀 html요소(div id="new_message") , partial -> 바꾼 html 요소안에 넣을 템플릿 , locals-> 템플릿(_form)에 전달할 로컬변수(비어있는 폼)
            # index 페이지에서 새로은 폼을 전부 작성하고 submit할경우 해당 폼을 비어있는 폼으로 다시 대체한다.
            turbo_stream.prepend('messages', partial: "messages/message" ,locals: {message: @message}),
            # prepend : 특정 요소의 맨위에 추가
            # messages-> index 페이지의 html요소(div id="messages"), partial-> 추가할 위치에 넣을 템플릿, locals-> 템플릿(_message)에 전달할 변수(submit한객체)

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
          format.turbo_stream do 
            render turbo_stream: [
              turbo_stream.update(@message, partial: "messages/message", locals: {message: @message})
            ] 
          end
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@message, partial: "messages/form", locals: {message: @message})
          ]
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
      # format.turbo_stream { render turbo_stream: turbo_stream.remove("message_#{@message.id}") } 와 같은의미.
      # Turbo Streams를 사용하여 해당 @message 객체에 대한 클라이언트측 HTML 엘리먼트을 동적으로 제거하라는 의미입니다.
      '''
      Turbo Streams는 HTML 엘리먼트를 동적으로 업데이트하고 
      조작하기 위한 기술로, turbo_stream.remove는 지정된 DOM ID를 가진 엘리먼트를 제거하는 Turbo Streams 액션입니다.
      @message를 통해서 dom id를 전달받습니다.
      '''
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
