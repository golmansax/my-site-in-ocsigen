(* @author holman
 *
 * Outputs resume html
 *)

open Eliom_content.Html5
open D

module Resume = struct
  type date =
    Current |
    MMYY of string * int |
    YY of int

  let print_date date = match date with
    Current -> "Current" |
    MMYY (m, y) -> Printf.sprintf "%s %04i" m y |
    YY y -> Printf.sprintf "%04i" y

  type place =
    School of string * date |
    Company of string * string * string * date * date

  let html_of_place place = match place with
    School (school, end_date) ->
      [pcdata (Printf.sprintf "%s: Class of %s" school (print_date end_date))]
      |
    Company (company, link, position, start_date, end_date) -> [
      F.Raw.a ~a:[a_href (Xml.uri_of_string link)] [pcdata company];
      pcdata (Printf.sprintf
        ", %s: %s - %s" position (print_date start_date)
        (print_date end_date)
      )
    ]

  let resume = ref [
    Company (
      "Room 77", "http://www.room77.com", "Software Engineer",
      MMYY ("Jul", 2013), Current
    );
    School (
      "University of Maryland, BS, Computer Engineering and Mathematics",
      YY 2012
    );
    School ("Montgomery Blair Magnet Program", YY 2008)
  ]

  let get_html () =
    let make_html = fun place -> li (html_of_place place) in
    ul (List.map make_html !resume)
end
