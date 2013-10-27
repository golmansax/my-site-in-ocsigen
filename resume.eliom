(* @author holman
 *
 * Outputs resume html
 *)

open Eliom_content.Html5
open D

module Resume = struct
  type company =
    Place of string |
    Link of string * string

  let company_html company = match company with
    Place place -> pcdata place |
    Link (place, link) -> F.Raw.a ~a:[a_href (Xml.uri_of_string link)] [pcdata place]

  type date =
    Current |
    MMYY of string * int |
    YY of int

  let print_date date = match date with
    Current -> "Current" |
    MMYY (m, y) -> Printf.sprintf "%s %04i" m y |
    YY y -> Printf.sprintf "%04i" y

  let resume = ref [
    (Link ("Room 77", "http://www.room77.com"), "Software Engineer",
      MMYY ("Jul", 2013), Current);
    (Place "University of Maryland", "Student", YY 2008, YY 2012);
    (Place "Montgomery Blair High School", "Student", YY 2004, YY 2008)
  ]

  let get_html () =
    let make_html = fun (company, position, start_d, end_d) ->
      li [
        company_html company;
        pcdata (Printf.sprintf
          "%s %s %s" position (print_date start_d) (print_date end_d)
        )
      ]
      in
    ul (List.map make_html !resume)
end
