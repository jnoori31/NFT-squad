class MessagesController < ApplicationController
    def create
        @message = Message.new(message_params)
        @chatroom = Chatroom.find(params[:chatroom_id])
        @message.user = current_user
        @message.chatroom = @chatroom
        if @message.save
            ChatroomChannel.broadcast_to(
                @chatroom,
                render_to_string(partial: "message", locals: { message: @message } )
            )
            redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
        else
            redirect_to user_path(@chatroom.owner_id)
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end
end
