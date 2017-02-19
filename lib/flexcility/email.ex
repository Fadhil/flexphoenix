defmodule Flexcility.Email do
  use Bamboo.Phoenix, view: Flexcility.EmailView

  def welcome_text_email(email_address) do
    new_email
    |> to(email_address)
    |> from("fadhil@flexcility.com")
    |> subject("Welcome to Flexcility!")
    |> text_body("Hallo! This email sent successfully!")
  end

  def team_member_invitation(email_address, invitation_link) do
    new_email
    |> to(email_address)
    |> from("fadhil@flexcility.com")
    |> subject("You've been added as a member of an Organisation on Flexcility!")
    |> text_body("Visit " <> invitation_link <> " to start managing your facilities on Flexcility")
  end
end
