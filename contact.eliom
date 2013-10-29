open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)
(* @author holman
 *
 * Provides a point of contact
 *)

module Contact = struct
  module Email = struct
    type t = {
      name: string;
      domain: string
    }

    let make name domain = {
      name = name;
      domain = domain
    }

    let to_email email = Printf.sprintf "%s@%s.com" email.name email.domain
    let to_html : t -> Html5_types.div_content elt list = fun email ->
      let text_list = [
        "Contact me at "; email.name; "@"; email.domain; ".com"
      ] in
      let rec add_obfuscation text_list = match text_list with
      | [] -> []
      | last :: [] -> [pcdata last]
      | head :: tail ->
          let hidden_crap = span ~a:[a_class ["hidden"]] [pcdata "crap"] in
          List.append [pcdata head; hidden_crap] (add_obfuscation tail)
      in
      add_obfuscation text_list
  end

  let footer_html () =
    let email = Email.make "holman" "golmansax" in
    [div (Email.to_html email)]
end
