class Stores::Paypal

include PayPal::SDK::REST
attr_accessor :payment, :total, :return_url, :cancel_url, :items

  def  initialize(total,items,options={})
    self.total = total
    self.items = items
    options.each {|clave, valor|   instance_variable_set("@#{clave}", valor)}
  end



  def process_payment

    self.payment = Payment.new({
          intent: "sale",
          payer:{
            payment_method: "paypal"

          },
          transactions: [
            {
              item_list:{
                items: self.items
              },
              amount:{
                total:(self.total / 100),
                currency: "EUR"

              },
              description: "Compra de tus productos en nuestra plataforma"
            }
          ],
          redirect_urls:{
            return_url: @return_url,
            cancel_url: @cancel_url,
          }
      })
      self.payment
  end

  def self.checkout(payer_id, payment_id,&block)
      payment = Payment.find(payment_id)
      if payment.execute(payer_id: payer_id)
  yield if block_given?
else

  end
end
end
