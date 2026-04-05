#!/usr/bin/env bash

calc_type=$(printf '%s\n' "% change" "% of" "bayes" "EV" "kelly" "compound" "game" "calc" | wofi --dmenu --prompt "Calc")
[ -z "$calc_type" ] && exit 0

case "$calc_type" in
calc)
  expr=$(echo "" | wofi --dmenu --prompt "Expression")
  [ -z "$expr" ] && exit 0
  
  result=$(echo "scale=10; $expr" | bc 2>&1)
  
  if [[ $result == *error* ]] || [[ $result == *syntax* ]]; then
    echo "Error" | wofi --dmenu --prompt "Invalid expression"
  else
    selected=$(echo "$result" | wofi --dmenu --prompt "$expr =")
    [ -n "$selected" ] && echo "$result" | wl-copy
  fi
  ;;

"% change")
  old=$(echo "" | wofi --dmenu --prompt "Old value")
  [ -z "$old" ] && exit 0
  
  new=$(echo "" | wofi --dmenu --prompt "New value")
  [ -z "$new" ] && exit 0
  
  change=$(echo "scale=2; (($new - $old) / $old) * 100" | bc)
  abs_change=${change#-}
  
  if (( $(echo "$change > 0" | bc -l) )); then
    selected=$(echo "$change%" | wofi --dmenu --prompt "Change: +")
  else
    selected=$(echo "$change%" | wofi --dmenu --prompt "Change:")
  fi
  [ -n "$selected" ] && echo "$change" | wl-copy
  ;;

"% of")
  percent=$(echo "" | wofi --dmenu --prompt "Percent")
  [ -z "$percent" ] && exit 0
  
  value=$(echo "" | wofi --dmenu --prompt "Value")
  [ -z "$value" ] && exit 0
  
  result=$(echo "scale=10; ($percent / 100) * $value" | bc)
  
  selected=$(echo "$result" | wofi --dmenu --prompt "$percent% of $value =")
  [ -n "$selected" ] && echo "$result" | wl-copy
  ;;
  
bayes)
  prior=$(echo "" | wofi --dmenu --prompt "Prior probability %")
  [ -z "$prior" ] && exit 0
  
  tpr=$(echo "" | wofi --dmenu --prompt "True positive rate %")
  [ -z "$tpr" ] && exit 0
  
  fpr=$(echo "" | wofi --dmenu --prompt "False positive rate %")
  [ -z "$fpr" ] && exit 0
  
  prior_dec=$(echo "scale=10; $prior / 100" | bc)
  tpr_dec=$(echo "scale=10; $tpr / 100" | bc)
  fpr_dec=$(echo "scale=10; $fpr / 100" | bc)
  
  numerator=$(echo "scale=10; $prior_dec * $tpr_dec" | bc)
  denominator=$(echo "scale=10; ($prior_dec * $tpr_dec) + ((1 - $prior_dec) * $fpr_dec)" | bc)
  posterior=$(echo "scale=2; ($numerator / $denominator) * 100" | bc)
  
  selected=$(echo "$posterior%" | wofi --dmenu --prompt "Posterior probability")
  [ -n "$selected" ] && echo "$posterior" | wl-copy
  ;;

EV)
  prob=$(echo "" | wofi --dmenu --prompt "Probability %")
  [ -z "$prob" ] && exit 0
  
  payoff=$(echo "" | wofi --dmenu --prompt "Payoff")
  [ -z "$payoff" ] && exit 0
  
  prob_dec=$(echo "scale=10; $prob / 100" | bc)
  ev=$(echo "scale=2; $prob_dec * $payoff" | bc)
  
  selected=$(echo "$ev" | wofi --dmenu --prompt "EV")
  [ -n "$selected" ] && echo "$ev" | wl-copy
  ;;

kelly)
  win_prob=$(echo "" | wofi --dmenu --prompt "Win probability %")
  [ -z "$win_prob" ] && exit 0
  
  win_odds=$(echo "" | wofi --dmenu --prompt "Win odds (e.g. 2 = win \$2 per \$1)")
  [ -z "$win_odds" ] && exit 0
  
  p=$(echo "scale=10; $win_prob / 100" | bc)
  q=$(echo "scale=10; 1 - $p" | bc)
  kelly=$(echo "scale=4; (($win_odds * $p) - $q) / $win_odds" | bc)
  
  if (( $(echo "$kelly < 0" | bc -l) )); then
    echo "Do not bet" | wofi --dmenu --prompt "Kelly: NEGATIVE"
  else
    kelly_pct=$(echo "scale=2; $kelly * 100" | bc)
    selected=$(echo "$kelly_pct%" | wofi --dmenu --prompt "Optimal bet")
    [ -n "$selected" ] && echo "$kelly_pct" | wl-copy
  fi
  ;;

compound)
  type=$(printf '%s\n' "AND" "OR" | wofi --dmenu --prompt "Compound type")
  [ -z "$type" ] && exit 0
  
  prob_a=$(echo "" | wofi --dmenu --prompt "Probability A %")
  [ -z "$prob_a" ] && exit 0
  
  prob_b=$(echo "" | wofi --dmenu --prompt "Probability B %")
  [ -z "$prob_b" ] && exit 0
  
  a_dec=$(echo "scale=10; $prob_a / 100" | bc)
  b_dec=$(echo "scale=10; $prob_b / 100" | bc)
  
  if [[ "$type" == "AND" ]]; then
    result=$(echo "scale=4; $a_dec * $b_dec" | bc)
    result_pct=$(echo "scale=2; $result * 100" | bc)
  else
    result=$(echo "scale=4; $a_dec + $b_dec - ($a_dec * $b_dec)" | bc)
    result_pct=$(echo "scale=2; $result * 100" | bc)
  fi
  
  selected=$(echo "$result_pct%" | wofi --dmenu --prompt "P($type)")
  [ -n "$selected" ] && echo "$result_pct" | wl-copy
  ;;

game)
  s1=$(echo "" | wofi --dmenu --prompt "P1 strategy 1 (Enter=Up)")
  [ -z "$s1" ] && s1="Up"
  
  s2=$(echo "" | wofi --dmenu --prompt "P1 strategy 2 (Enter=Down)")
  [ -z "$s2" ] && s2="Down"
  
  o1=$(echo "" | wofi --dmenu --prompt "Opponent strategy 1 (Enter=Left)")
  [ -z "$o1" ] && o1="Left"
  
  o2=$(echo "" | wofi --dmenu --prompt "Opponent strategy 2 (Enter=Right)")
  [ -z "$o2" ] && o2="Right"
  
  a=$(echo "" | wofi --dmenu --prompt "P1: $s1 vs $o1")
  [ -z "$a" ] && exit 0
  b=$(echo "" | wofi --dmenu --prompt "P1: $s1 vs $o2")
  [ -z "$b" ] && exit 0
  c=$(echo "" | wofi --dmenu --prompt "P1: $s2 vs $o1")
  [ -z "$c" ] && exit 0
  d=$(echo "" | wofi --dmenu --prompt "P1: $s2 vs $o2")
  [ -z "$d" ] && exit 0
  
  e=$(echo "" | wofi --dmenu --prompt "Opp: $s1 vs $o1")
  [ -z "$e" ] && exit 0
  f=$(echo "" | wofi --dmenu --prompt "Opp: $s1 vs $o2")
  [ -z "$f" ] && exit 0
  g=$(echo "" | wofi --dmenu --prompt "Opp: $s2 vs $o1")
  [ -z "$g" ] && exit 0
  h=$(echo "" | wofi --dmenu --prompt "Opp: $s2 vs $o2")
  [ -z "$h" ] && exit 0
  
  denom1=$(echo "scale=10; $a - $b - $c + $d" | bc)
  denom2=$(echo "scale=10; $e - $f - $g + $h" | bc)
  
  if (( $(echo "$denom1 == 0" | bc -l) )) || (( $(echo "$denom2 == 0" | bc -l) )); then
    echo "Pure strategy equilibrium" | wofi --dmenu --prompt "Result"
    exit 0
  fi
  
  p=$(echo "scale=4; ($h - $g) / $denom2" | bc)
  q=$(echo "scale=4; ($d - $b) / $denom1" | bc)
  
  eu1=$(echo "scale=2; $q * $a + (1 - $q) * $b" | bc)
  p_pct=$(echo "scale=1; $p * 100" | bc)
  q_pct=$(echo "scale=1; $q * 100" | bc)
  p_other=$(echo "100 - $p_pct" | bc)
  q_other=$(echo "100 - $q_pct" | bc)
  
  result="YOU: $s1 ${p_pct}%, $s2 ${p_other}%
EV: $eu1"
  
  selected=$(echo "$result" | wofi --dmenu --prompt "Optimal")
  [ -n "$selected" ] && echo "$result" | wl-copy
  ;;
  
esac