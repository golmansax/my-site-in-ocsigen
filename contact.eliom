open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)
(* @author holman
 *
 * Provides a point of contact
 *)

module Contact = struct
  let email_html name domain =
    let text_list = ["Contact me at "; name; "@"; domain; ".com"] in
    let rec add_obfuscation =
    fun text_list -> match text_list with
      [] -> [] |
      last :: [] -> [pcdata last] |
      head :: tail -> List.append
        [pcdata head; span ~a:[a_class ["hidden"]] [pcdata "crap"]]
        (add_obfuscation tail)
      in
    add_obfuscation text_list

  let footer_html () =
    div (email_html "holman" "golmansax")

(* Ugh I can't get the class to work
  class email name domain = object
    method get_email = Printf.sprintf "%s@%s.com" name domain
    method get_html =
      let text_list = ["Contact me at"; name; "@"; domain; ".com"] in
      let rec add_obfuscation : string list -> Eliom_content.Html5.D.elt list =
      fun text_list -> match text_list with
        [] -> [] |
        last :: [] -> [pcdata last] |
        head :: tail -> List.append
          [pcdata head; span ~a:[a_class ["hidden"]] [pcdata "crap"]]
          (add_obfuscation tail)
        in
      add_obfuscation text_list
  end

  let footer_html () =
    let my_email = new email "holman" "golmansax" in
    div my_email#get_html
  *)
end
