let button = Gui.Btn {xc=Gui.ratio 1 2; yc=Gui.ratio 1 16;
                      width=160; height=30;
                      label="POWROT"; colour=Graphics.white}

let texts = (Gui.Txt {xc=Gui.ratio 1 2; yc=Gui.ratio 92 100;
                      label="WYGRANA!!! :)"; colour=Graphics.blue},
             Gui.Txt {xc=Gui.ratio 1 2; yc=Gui.ratio 92 100;
                      label="PRZEGRANA :("; colour=Graphics.red})

let step = 24

let get_borders size =
  let cols = size / 2 + 1 in
  let half = Gui.ratio 1 2 in
  (half + step * cols, half - step * cols)

let get_lines size =
  let cols = size / 2 in
  let half = Gui.ratio 1 2 in
  let rec get_lines' i acc =
    if i + cols >= 0
    then get_lines' (i - 1) @@ (half + step * i) :: acc
    else acc in
  get_lines' cols []

let norm size (x, y) =
  let _, endline = get_borders size in
  let norm' w = (w - endline + step / 2) / step in
  (norm' x, norm' y)

let display size =
  let pos = get_lines size in
  let pbeg, pend = get_borders size in
  let draw_line width pos =
    begin
      Graphics.set_line_width width;
      Graphics.set_color Graphics.black;
      Graphics.moveto pos pbeg;
      Graphics.lineto pos pend;
      Graphics.moveto pbeg pos;
      Graphics.lineto pend pos
    end in
  begin
    Gui.clear_window Graphics.cyan;
    draw_line 3 pbeg;
    draw_line 3 pend;
    List.iter (draw_line 0) pos
  end

let draw_stone size player (row, col) =
  let _, endline = get_borders size in
  let stone_colour =
    match player with
    | Board.Human -> Graphics.white
    | Board.Comp -> Graphics.black in
  let px = endline + col * step in
  let py = endline + row * step in
  begin
    Graphics.set_color stone_colour;
    Graphics.fill_circle px py (7 * step / 16)
  end

let rec choose_stone size =
  let px, py = norm size @@ Gui.mouse_click () in
  if px >= 1 && px <= size && py >= 1 && py <= size
  then (py, px)
  else choose_stone size

let return winner =
  let print_winner () =
    match winner with
    | Board.Human -> Gui.draw_text @@ fst texts
    | Board.Comp -> Gui.draw_text @@ snd texts in
  let rec check_click () =
    let mouse_pos = Gui.mouse_click () in
    if Gui.check_button_clicked mouse_pos button
    then ()
    else check_click () in
  begin
    print_winner ();
    Gui.draw_button button;
    check_click ()
  end