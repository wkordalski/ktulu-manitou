// Simple functions to query or modify state.



function search(state, searcher_id, searchee_id, info = {}) {
  // searcher checks if searchee has statuette
  // if so, searcher gets it

  if(searchee_id == state.get('StatuetteHolder')) {
    info.found = true;
    // statuette was found
    if(state.get('IsDay')) {
      // wygrywa miasto
      return state
        .update('Won', _ => 'miastowy')
        .update('StatuetteOwner', _ => -1)
        .update('StatuetteHolder', _ => -1)
        ;
    } else {
      // searcher gets statuette
      return state
        .update('StatuetteOwner', _ => searcher_id)
        .update('StatuetteHolder', _ => searcher_id)
        ;
    }
  } else {
    // nothing found - nothing is done
    info.found = false;
    return state;
  }
}

function search_and_kill(state, killer_id, killee_id, info = {}) {
  // killer searches killee and then kills him

  state = search(state, killer_id, killee_id, info);

  // Killee do not have statuette.
  state = state
    .updateIn(['Characters', killee_id, 'Alive'], _ => false)
    ;

  if(state.get('Characters').every(
    character => character.get('Faction') == 'indianin' || character.get('Alive') == false)) {
    // wygrywają indiańcy
    return state
      .update('Won', _ => 'indianin')
      ;
  } else {
    return state;
  }
}

function give_statuette(state, new_owner) {
  // transfers statuette to new_owner
  // TODO
}

function make_somebody_drunk(state, drunkee) {
  // makes somebody drunk but do not check if has statuette
  // TODO
}

function lock_somebody_up(state, lockee) {
  // makes somebody locked but do not check if has statuette
  return state
    .updateIn(['Characters', lockee, 'Locked'], _ => true)
    ;
}

var commands = {
  search: search,
  search_and_kill: search_and_kill,
  lock_somebody_up: lock_somebody_up
}

export default commands;
