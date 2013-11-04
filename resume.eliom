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

  (* Supports just text or text + link (creates an <a> in this case) *)
  module Possible_link = struct
    type t = {
      text: string;
      link: string
    }

    let make ?(link = "") text = {
      text = text;
      link = link
    }

    let to_html_elt possible_link =
      let raw_elt = pcdata possible_link.text in
      match possible_link.link with
      | "" -> pcdata possible_link.text
      | _ ->
          let uri = Xml.uri_of_string possible_link.link in
          Eliom_content.Html5.F.Raw.a ~a:[a_href uri] [raw_elt]
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
        let possible_link = Possible_link.make ~link:place.link place.name in
        Possible_link.to_html_elt possible_link
      in
      let date_suffix_elt =
        let resume_date_string = Resume_date.to_string place.resume_date in
        pcdata (Printf.sprintf ": %s" resume_date_string)
      in
      match place.position with
      | "" -> [name_elt; date_suffix_elt]
      | _ ->
        let position_elt = pcdata (Printf.sprintf ", %s" place.position) in
        [name_elt; position_elt; date_suffix_elt]
  end

  module Note = struct
    type t = Possible_link.t list
    let to_html_elt note =
      let note_html = List.map Possible_link.to_html_elt note in
      div ~a:[a_class ["resume-entry-note"]] note_html
  end

  module Entry = struct
    type t = {
      place: Place.t;
      notes: Note.t list
    }

    let make ?(notes = []) place = {
      place = place;
      notes = notes
    }

    let to_html entry =
      let place_html = Place.to_html entry.place in
      let notes_html = List.map Note.to_html_elt entry.notes in
      List.append place_html notes_html
  end

  type t = Entry.t list

  let make =
    let r77 =
      let start_date = Date.mmyy ~month:"Jul" 2013 in
      let end_date = Date.current in
      let resume_date = Resume_date.range start_date end_date in
      let place = Place.make "Room 77" ~position:"Software Engineer"
        ~link:"http://www.room77.com" resume_date
      in
      let notes = [
        [ Possible_link.make "Lead ";
          Possible_link.make ~link:"http://m.room77.com" "mobile app";
          Possible_link.make " developer, coded mainly in Javascript (with \
            AngularJS)"
        ]
      ] in
      Entry.make ~notes:notes place
    in
    let umd =
      let name = "University of Maryland" in
      let position = "BS, Computer Engineering and Mathematics" in
      let resume_date = Resume_date.class_of (Date.mmyy 2012) in
      let place = Place.make name ~position:position resume_date in
      let notes = [
        [ Possible_link.make ~link:"http://www.newsdesk.umd.edu/engaged/\
            release.cfm?ArticleID=2429" "Participant";
          Possible_link.make " in the 2011 ACM-ICPC World Finals"
        ]
      ] in
      Entry.make ~notes:notes place
    in
    let blair =
      let resume_date = Resume_date.class_of (Date.mmyy 2008) in
      let place = Place.make "Montgomery Blair Magnet Program" resume_date in
      Entry.make place
    in
    [r77; umd; blair]

  let to_html () =
    let helper place = div ~a:[a_class ["resume-entry"]] (Entry.to_html place)
    in
    [div ~a:[a_class ["resume"]] (List.map helper make)]
end
