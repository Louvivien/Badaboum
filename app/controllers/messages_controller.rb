class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :new_email_message, only: [:create]
  before_action do
     @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true
      end
    end

    @message = @conversation.messages.new

    respond_to do |format|
      format.html { redirect_to conversations_path }
      format.js
    end
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)

    if @message.save
      respond_to do |format|
        flash[:notice] = "Message envoyé !"
        format.html { redirect_to conversations_path(@conversation) }
        format.js
      end
    end

  end

  private

    def message_params
      params.require(:message).permit(:body, :user_id)
    end

    def new_email_message
      UserMailer.new_private_message(recipient).deliver_now
    end

end
