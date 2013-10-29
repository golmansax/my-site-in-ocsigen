(* @author holman
 *
 * Outputs resume html
 *)

open Eliom_content.Html5.D

module Resume = struct
  (* For basic date manipulation *)
  module Date = struct
    type t =
    | Current
    | MMYY of string * int

    let current = Current
    let mmyy ?(month = "") year = MMYY (month, year)

    let to_string date = match date with
    | Current -> "Current"
    | MMYY (month, year) ->
      let year_string = Printf.sprintf "%04i" year in
      match month with
      | "" -> year_string
      | _ -> Printf.sprintf "%s %s" month year_string
  end

  (* Introduces 'class of' vs date range *)
  module Resume_date = struct
    type t =
    | Class_of of Date.t
    | Range of Date.t * Date.t

    let class_of date = Class_of date
    let range start_date end_date = Range (start_date, end_date)

    let to_string resume_date = match resume_date with
    | Class_of date -> Printf.sprintf "Class of %s" (Date.to_string date)
    | Range (start_date, end_date) ->
        let start_string = Date.to_string start_date in
        let end_string = Date.to_string end_date in
        Printf.sprintf "%s - %s" start_string end_string
  end

  module Place = struct
    type t = {
      name: string;
      link: string;
      position: string;
      resume_date: Resume_date.t
    }

    let make name ?(position = "") ?(link = "") resume_date = {
      name = name;
      position = position;
      link = link;
      resume_date = resume_date
    }

    let to_html place =
      let name_elt =
        let name_raw_elt = pcdata place.name in
        match place.link with
        | "" -> name_raw_elt
        | _ ->
          let uri = Xml.uri_of_string place.link in
          Eliom_content.Html5.F.Raw.a ~a:[a_href uri] [name_raw_elt]
      in
      let date_suffix_elt =
        pcdata (Printf.sprintf ": %s" (Resume_date.to_string place.resume_date))
      in
      match place.position with
      | "" -> [name_elt; date_suffix_elt]
      | _ ->
        let position_elt = pcdata (Printf.sprintf ", %s" place.position) in
        [name_elt; position_elt; date_suffix_elt]
  end

  type t = Place.t list

  let make =
    let r77 =
      let start_date = Date.mmyy ~month:"Jul" 2013 in
      let end_date = Date.current in
      let resume_date = Resume_date.range start_date end_date in
      Place.make "Room 77" ~position:"Software Engineer"
        ~link:"http://www.room77.com" resume_date
    in
    let umd =
      let position = "BS, Computer Engineering and Mathematics" in
      let resume_date = Resume_date.class_of (Date.mmyy 2012) in
      Place.make "University of Maryland" ~position:position resume_date
    in
    let blair =
      let resume_date = Resume_date.class_of (Date.mmyy 2008) in
      Place.make "Montgomery Blair Magnet Program" resume_date
    in
    [r77; umd; blair]

  let to_html () =
    let helper = fun place -> div (Place.to_html place) in
    List.map helper make
end
