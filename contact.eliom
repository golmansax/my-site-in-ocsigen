open Eliom_content.Html5.D (* Provides functions to create HTML nodes *)
(* @author holman
 *
 * Provides a point of contact
 *)

module Contact = struct
  (* TODO @holman seperate this out into it's own util
   *  This also does not need to be html util *)
  let rec add_delimiter html_list delimiter_elt = match html_list with
  | [] -> []
  | last :: [] -> last
  | head :: tail ->
      let with_delimiter = List.append head [delimiter_elt] in
      List.append with_delimiter (add_delimiter tail delimiter_elt)

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
      let text_to_html text = [pcdata text] in
      let html_list = List.map text_to_html text_list in
      let hidden_crap = span ~a:[a_class ["is_hidden"]] [pcdata "crap"] in
      add_delimiter html_list hidden_crap
  end

  let to_html () =
    let contact_html =
      let email_html =
        let email = Email.make "holman" "golmansax" in
        Email.to_html email
      in
      let github_html =
        let github_link = "https://github.com/golmansax" in
        let uri = Xml.uri_of_string github_link in
        let raw_elt = pcdata "Github" in
        [Eliom_content.Html5.F.Raw.a ~a:[a_href uri] [raw_elt]]
      in
      let html_list = [github_html; email_html] in
      add_delimiter html_list (pcdata " | ")
    in
    [div ~a:[a_class ["contact"; "mt1"]] contact_html]
end
