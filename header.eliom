(* @author holman
 *
 * Outputs header html
 *)

open Eliom_content.Html5.D

let get () =
  let font_uri = Xml.uri_of_string
    "http://fonts.googleapis.com/css?family=PT+Sans"
  in
  let css_uri = make_uri
    (Eliom_service.static_dir ()) ["assets"; "main.css"]
  in
  let md5 = Digest.to_hex (Digest.string "golmansax@gmail.com") in
  let icon_link = Printf.sprintf "http://www.gravatar.com/avatar/%s?s=16" md5
  in
  let icon_uri = Xml.uri_of_string icon_link in
  let description = "Personal site of Holman Gao, software engineer at \
    Chalk Schools, University of Maryland and Blair Magnet alum"
  in
  let viewport = "width=device-width, user-scalable=no" in
  head (title (pcdata "Holman Gao")) [
    css_link ~uri:css_uri ();
    css_link ~uri:font_uri ();
    link [`Icon] icon_uri ();
    meta ~a:[a_content description; a_name "description"] ();
    meta ~a:[a_content viewport; a_name "viewport"] ()
  ]
