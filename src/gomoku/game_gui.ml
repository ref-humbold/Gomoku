let button =
  Gui.Btn
    { xc = Gui.ratio 1 2;
      yc = Gui.ratio 1 16;
      width = 160;
      height = 30;
      label = "POWROT";
      colour = Graphics.white }

let texts =
  ( Gui.Txt
      {xc = Gui.ratio 1 2; yc = Gui.ratio 92 100; label = "WYGRANA!!! :)"; colour = Graphics.blue},
    Gui.Txt
      {xc = Gui.ratio 1 2; yc = Gui.ratio 92 100; label = "PRZEGRANA :("; colour = Graphics.red} )

let step = 24

let middle = Gui.ratio 1 2

let get_borders size =
  let cols = (size / 2) + 1 in
  (middle - (step * cols), middle + (step * cols))

let get_lines size =
  let rec get_lines' i acc =
    if i <= size / 2
    then get_lines' (i + 1) ((middle + (step * i)) :: (middle - (step * i)) :: acc)
    else acc
  in
  get_lines' 0 []

let grid_of_point size (x, y) =
  let begline, _ = get_borders size in
  let conv v = (v - begline + (step / 2)) / step in
  (conv y, conv x)

let point_of_grid size (Board.GP (rn, cn)) =
  let begline, _ = get_borders size in
  let conv v = begline + (v * step) in
  (conv cn, conv rn)

let display size =
  let pbeg, pend = get_borders size in
  let draw_line width pos =
    Graphics.set_line_width width ;
    Graphics.set_color Graphics.black ;
    Graphics.moveto pos pbeg ;
    Graphics.lineto pos pend ;
    Graphics.moveto pbeg pos ;
    Graphics.lineto pend pos
  in
  Gui.clear_window Graphics.cyan ;
  draw_line 3 pbeg ;
  draw_line 3 pend ;
  List.iter (draw_line 0) @@ get_lines size

let draw_stone size player grid =
  let stone_colour =
    match player with
    | Board.Human -> Graphics.white
    | Board.Comp -> Graphics.black
  in
  let x, y = point_of_grid size grid in
  Graphics.set_color stone_colour ;
  Graphics.fill_circle x y (7 * step / 16)

let return winner =
  let show_winner () =
    match winner with
    | Board.Human -> Gui.draw_text @@ fst texts
    | Board.Comp -> Gui.draw_text @@ snd texts
  in
  let rec check_click () =
    let mouse_pos = Gui.mouse_click () in
    if not @@ Gui.check_button_clicked mouse_pos button then check_click ()
  in
  show_winner () ; Gui.draw_button button ; check_click ()
