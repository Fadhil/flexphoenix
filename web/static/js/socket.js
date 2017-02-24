// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

  let socket = new Socket("/socket", {})
// let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()
console.log("socket connected")

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("work_request_rooms:subtopic", {})
let system_channel = socket.channel("system:main", {})

// This function gets called on channel.on("new_message") to get the
// payload (the data that was sent by message.on("keypress") ) and use it
// to build a chat message row as described in the comments inside which
// is then appended to the message-list
function build_message_row(payload){
  // Set default direction = right
  let direction = "right";

  // If the payload_user id is the same as the current user's id, change to left
  if( payload.user_id ==  $("#user-hidden-id").html()){
    direction = "left";
  }
  /* Here we build the message row using jquery. The resultant structure
      should look like this:

     <div class="chat-message left">
        <img class="message-avatar" src="img/a1.jpg" alt="" >
         <div class="message">
           <a class="message-author" href="#"> Michael Smith </a>
           <span class="message-date"> Mon Jan 26 2015 - 18:39:23 </span>
           <span class="message-content">
           Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
           </span>
         </div>
       </div>  */
  let message_row = $("<div>").addClass("chat-message " + direction)
                      .append(
                        $("<img>").attr("src", payload.image)
                        .addClass("message-avatar")
                      ).append(
                        $("<div>").addClass("message")
                          .append(
                            $("<a href='#'>").addClass("message-author")
                              .append(
                                payload.name
                              )
                          ).append(
                            $("<span>").addClass("message-date")
                              .append(
                                new Date($.now())
                              )
                          ).append(
                            $("<span>").addClass("message-content")
                              .append(
                                payload.message
                              )
                          )
                      )
  return message_row;
}

let instance = null;

class CurrentState{
    constructor() {
        if(!instance){
              instance = this;
        }

        return instance;
      }

    setOrgId(id) {
      this.org_id = id;
      return true;
    }

    setCurrentUserId(id) {
      this.current_user_id = id;
      return true;
    }
}

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

system_channel.join()
  .receive("ok", resp => { console.log("Logged on to Flexcility", resp) })
  .receive("error", resp => { console.log("Failed to log on to Flexcility")})

var setup_system_listeners = () => {
  let invite_helpdesk_button    = $("#send_helpdesk_invite_button");
  let invite_helpdesk_email_input = $("#invite_helpdesk_email");
  let organisation_subdomain_input = $("#organisation_subdomain");


  //let invite_helpdesk_email =
  console.log("setting up system");

  invite_helpdesk_button.on("click", event => {
    let user_id = window.CurrentState.current_user_id
    let invite_helpdesk_email = invite_helpdesk_email_input.val();
    console.log("sending invite");
    system_channel.push("send_invite", {
      role: "Helpdesk", inviter_id: user_id, organisation_subdomain: organisation_subdomain_input.val(),
      email: invite_helpdesk_email
    }).receive("ok", resp => {
        $("#organisation-wizard-submit-btn").click();
        swal("Invitation Sent!", "Organisation setup successfully", "success");
    })
      .receive("error", resp => {
        swal("You've sent an invitation to that email already", "error");
      });
  });

  system_channel.on("invitation_sent", payload => {
    console.log("got payload", payload);
  });
};


$(document).ready(function(){
  let list    = $("#message-list");
  let message = $("#message");
  let name    = $("#user-display-name").html();
  let image  = $("#user-display-image").attr("src");
  let user_id = $("#user-hidden-id").html();

  window.CurrentState = new CurrentState();

  message.on("keypress", event => {
    if (event.keyCode == 13) {
      channel.push("new_message", { name: name, message: message.val(),
                                    user_id: user_id, image: image
                                  });
      message.val("");
    }
  });

  channel.on("new_message", payload => {
    list.append(build_message_row(payload));
    list.prop({scrollTop: list.prop("scrollHeight")});
  });

  setup_system_listeners();

});



export default socket
