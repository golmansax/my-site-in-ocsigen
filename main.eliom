open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)

(* My modules *)
open Contact
open Resume

module My_app = Eliom_registration.App
  (struct let application_name = "me" end)

let main_service = My_app.register_service
  ~path:[""]
  ~get_params:Eliom_parameter.unit
  (fun () () ->
    Lwt.return (html
      (head
        (title (pcdata "Holman Gao"))
        [css_link ~uri:(make_uri
          (Eliom_service.static_dir ()) ["compass"; "stylesheets"; "main.css"]
         ) ()]
      )
      (body [
        h1 [pcdata "Holman Gao"];
        Resume.get_html ();
        Contact.footer_html ()
      ])
    )
  )

(* Bug in js, this is not working yet
{client{
  let _ = Eliom_lib.alert "Hello!"
}}
*)
