defmodule Flexcility.Email do
  use Bamboo.Phoenix, view: Flexcility.EmailView

  def welcome_text_email(email_address) do
    new_email
    |> to(email_address)
    |> from("fadhil@flexcility.com")
    |> subject("Welcome to Flexcility!")
    |> text_body("Hallo! This email sent successfully!")
  end
end
