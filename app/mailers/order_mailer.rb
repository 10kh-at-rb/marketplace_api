class OrderMailer < ApplicationMailer
  default from: "hogwarts@wizardry.org"

  def send_confirmation(order)
    @order = order
    @user = @order.user
    mail to: @user.email, subject: "Order Confirmation"
  end
end
