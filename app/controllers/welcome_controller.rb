class WelcomeController < ApplicationController
  def index
  end

  def unregistered
        @articles = Article.all
  end

    def payment_succed
      if @shopping_cart.payed?

      cookies[:shopping_cart_id] = nil
      else
      redirect_to carrito_path
    end
  end

end
