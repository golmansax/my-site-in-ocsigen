open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)
(* @author holman
 *
 * Provides a point of contact
 *)

module Contact = struct
  (* Use this to create an email *)
  class email name domain = object
    method get_email = Printf.sprintf "%s@%s.com" name domain
    method get_html : Html5_types.div_content elt list =
      let text_list = ["Contact me at "; name; "@"; domain; ".com"] in
      let rec add_obfuscation = fun text_list -> match text_list with
      | [] -> []
      | last :: [] -> [pcdata last]
      | head :: tail ->
          let hidden_crap = span ~a:[a_class ["hidden"]] [pcdata "crap"] in
          List.append [pcdata head; hidden_crap] (add_obfuscation tail)
      in
      add_obfuscation text_list
  end

  let footer_html () =
    let my_email = new email "holman" "golmansax" in
    [div my_email#get_html]
end
