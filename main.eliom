open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)

module My_app = Eliom_registration.App
  (struct let application_name = "my_site" end)

let main_service = My_app.register_service
  ~path:[""]
  ~get_params:Eliom_parameter.unit
  (fun () () ->
    let body_header = [h1 [pcdata "Holman Gao"]] in
    let body_content = Resume.to_html () in
    let body_footer = Contact.to_html () in
    let body_html = List.append
      (List.append body_header body_content) body_footer
    in
    Lwt.return (html (Header.get ()) (body body_html))
  )

(* Bug in js, this is not working yet
{client{
  let _ = Eliom_lib.alert "Hello!"
}}
*)
