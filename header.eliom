(* @author holman
 *
 * Outputs header html
 *)

open Eliom_content.Html5.D

let get () =
  let css_uri = make_uri
    (Eliom_service.static_dir ()) ["compass"; "stylesheets"; "main.css"]
  in
  let md5 = Digest.to_hex (Digest.string "golmansax@gmail.com") in
  let icon_link = Printf.sprintf "http://www.gravatar.com/avatar/%s?s=16" md5
  in
  let icon_uri = Xml.uri_of_string icon_link in
  let description = "Personal site for Holman Gao, software engineer at \
    Room 77, University of Maryland and Blair Magnet alum"
  in
  head (title (pcdata "Holman Gao")) [
    css_link ~uri:css_uri ();
    link [`Icon] icon_uri ();
    meta ~a:[a_content description; a_name "description"] ()
  ]
