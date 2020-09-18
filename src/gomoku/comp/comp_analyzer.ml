open Board

type direction =
  | Row of int * field list
  | Column of int * field list
  | Sum of int * field list
  | Diff of int * field list

type hole = Hole of {place : grid; dirs : (int * direction) list}

let count cmp lst =
  let rec count' n lst =
    match lst with
    | x1 :: (x2 :: _ as xs) -> if x1 = x2 then count' (n + 1) xs else (x1, n) :: count' 1 xs
    | [x] -> [(x, n)]
    | [] -> []
  in
  count' 1 @@ List.sort cmp lst

let get_row_dim rn gameboard = Row (rn, get_row rn gameboard)

let get_column_dim cn gameboard = Column (cn, get_column cn gameboard)

let get_sum_diag_dim sum gameboard = Sum (sum, get_sum_diag sum gameboard)

let get_diff_diag_dim diff gameboard = Diff (diff, get_diff_diag diff gameboard)

let get_dirs_at_pos (GP (rn, cn)) gameboard =
  [ get_row_dim rn gameboard; get_column_dim cn gameboard; get_sum_diag_dim (rn + cn) gameboard;
    get_diff_diag_dim (rn - cn) gameboard ]

let get_all_lines gameboard =
  let get_rows {fields; _} = fields in
  let get_columns gameboard' = List.mapi (fun i _ -> get_column i gameboard') gameboard'.fields in
  let get_sum_diags gameboard' =
    let rec get_s sum acc =
      if sum <= gameboard'.size * 2
      then get_s (sum + 1) (get_sum_diag sum gameboard' :: acc)
      else acc
    in
    get_s 2 []
  in
  let get_diff_diags gameboard' =
    let rec get_d diff acc =
      if diff <= gameboard'.size - 1
      then get_d (diff + 1) (get_diff_diag diff gameboard' :: acc)
      else acc
    in
    get_d (-gameboard'.size + 1) []
  in
  List.concat
    [get_rows gameboard; get_columns gameboard; get_sum_diags gameboard; get_diff_diags gameboard]

let analyze_winning player pos gameboard =
  let extract_pos dir i =
    match dir with
    | Row (rn, _) -> GP (rn, i)
    | Column (cn, _) -> GP (i, cn)
    | Sum (sum, _) -> GP (sum, sum - i)
    | Diff (diff, _) -> GP (i, i - diff)
  in
  let rec check_next_win dir i lst acc =
    match lst with
    | Free :: Stone p1 :: Stone p2 :: Stone p3 :: Stone p4 :: ps
      when player = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      let pos = extract_pos dir i in
      check_next_win dir (i + 5) ps ((pos, 5, dir) :: acc)
    | Stone p1 :: Free :: Stone p2 :: Stone p3 :: Stone p4 :: ps
      when player = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      let pos = extract_pos dir (i + 1) in
      check_next_win dir (i + 5) ps ((pos, 5, dir) :: acc)
    | Stone p1 :: Stone p2 :: Free :: Stone p3 :: Stone p4 :: ps
      when player = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      let pos = extract_pos dir (i + 2) in
      check_next_win dir (i + 5) ps ((pos, 5, dir) :: acc)
    | Stone p1 :: Stone p2 :: Stone p3 :: Free :: Stone p4 :: ps
      when player = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      let pos = extract_pos dir (i + 3) in
      check_next_win dir (i + 5) ps ((pos, 5, dir) :: acc)
    | Stone p1 :: Stone p2 :: Stone p3 :: Stone p4 :: Free :: ps
      when player = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      let pos = extract_pos dir (i + 4) in
      check_next_win dir (i + 5) ps ((pos, 5, dir) :: acc)
    | Free :: Stone p1 :: Stone p2 :: Stone p3 :: ps when player = p1 && p1 = p2 && p2 = p3 ->
      let pos = extract_pos dir i in
      check_next_win dir (i + 4) ps ((pos, 4, dir) :: acc)
    | Stone p1 :: Free :: Stone p2 :: Stone p3 :: ps when player = p1 && p1 = p2 && p2 = p3 ->
      let pos = extract_pos dir (i + 1) in
      check_next_win dir (i + 4) ps ((pos, 4, dir) :: acc)
    | Stone p1 :: Stone p2 :: Free :: Stone p3 :: ps when player = p1 && p1 = p2 && p2 = p3 ->
      let pos = extract_pos dir (i + 2) in
      check_next_win dir (i + 4) ps ((pos, 4, dir) :: acc)
    | Stone p1 :: Stone p2 :: Stone p3 :: Free :: ps when player = p1 && p1 = p2 && p2 = p3 ->
      let pos = extract_pos dir (i + 3) in
      check_next_win dir (i + 4) ps ((pos, 4, dir) :: acc)
    | Free :: Stone p1 :: Stone p2 :: ps when player = p1 && p1 = p2 ->
      let pos = extract_pos dir i in
      check_next_win dir (i + 3) ps ((pos, 3, dir) :: acc)
    | Stone p1 :: Free :: Stone p2 :: ps when player = p1 && p1 = p2 ->
      let pos = extract_pos dir (i + 1) in
      check_next_win dir (i + 3) ps ((pos, 3, dir) :: acc)
    | Stone p1 :: Stone p2 :: Free :: ps when player = p1 && p1 = p2 ->
      let pos = extract_pos dir (i + 2) in
      check_next_win dir (i + 3) ps ((pos, 3, dir) :: acc)
    | Free :: ps | Border :: ps | Stone _ :: ps -> check_next_win dir (i + 1) ps acc
    | [] -> acc
  in
  let check_direction dir =
    match dir with
    | Row (_, row) -> check_next_win dir 0 row []
    | Column (_, col) -> check_next_win dir 0 col []
    | Sum (sum, diag) ->
      let i = max 0 @@ (sum - gameboard.size - 1) in
      check_next_win dir i diag []
    | Diff (diff, diag) ->
      let i = max 0 diff in
      check_next_win dir i diag []
  in
  let make_holes lst =
    let rec make_holes' dirs lst =
      match lst with
      | (p1, n1, d1) :: ((p2, _, _) :: _ as xs) ->
        if p1 = p2
        then make_holes' ((n1, d1) :: dirs) xs
        else (
          match dirs with
          | [(3, _)] -> make_holes' [] xs
          | _ -> Hole {place = p1; dirs} :: make_holes' [] xs )
      | [(p, _, _)] ->
        ( match dirs with
        | [(3, _)] -> []
        | _ -> [Hole {place = p; dirs}] )
      | [] -> []
    in
    make_holes' [] @@ List.sort compare lst
  in
  make_holes @@ List.concat @@ List.map check_direction @@ get_dirs_at_pos pos gameboard

let check_lines player gameboard =
  let rec check acc line =
    match line with
    | Stone p0 :: Stone p1 :: Stone p2 :: Stone p3 :: Stone p4 :: ps
      when player = p0 && p0 = p1 && p1 = p2 && p2 = p3 && p3 = p4 ->
      check (5 :: acc) ps
    | Stone p0 :: Stone p1 :: Stone p2 :: Stone p3 :: ps
      when player = p0 && p0 = p1 && p1 = p2 && p2 = p3 ->
      check (4 :: acc) ps
    | Stone p0 :: Stone p1 :: Stone p2 :: ps when player = p0 && p0 = p1 && p1 = p2 ->
      check (3 :: acc) ps
    | Stone p0 :: Stone p1 :: ps when player = p0 && p0 = p1 -> check (2 :: acc) ps
    | Free :: ps | Border :: ps | Stone _ :: ps -> check acc ps
    | [] -> acc
  in
  count compare @@ List.concat @@ List.map (check []) @@ get_all_lines gameboard
