import Immutable from 'immutable'
import commands from './commands'

function next_step(state) {
    state = state
        // save some data that should be saved before next step
        ;
    // Data available within next step...
    state = state
        .update('Time', value => value + 1)
        .update('LastAction', _ => state);

    state = state
        .update('Input', _ => new Immutable.List());

    return state;
}

function get_character(state, character) {
  return state.get('Characters').find(
    element => element.get('ID') == character && element.get('Alive')
  );
}

function get_context(state, key) {
  return state.getIn(['Context', key]);
}

function set_context(state, key, value) {
  return state.updateIn(['Context', key], _ => value);
}

function clr_context(state, key) {
  return state.updateIn(['Context', key], _ => undefined);
}

function clr_contexts(state, keys) {
  for(var key of keys) {
    state = clr_context(state, key);
  }
  return state;
}

function mod_context(state, key, modifier) {
  return state.updateIn(['Context', key], modifier);
}

function lives(character) {
  return state => state.get('Characters').count(element => element.get('ID') == character && element.get('Alive')) > 0;
}

function active(character) {
  return state => state.get('Characters').count(element => element.get('ID') == character && element.get('Alive') && (!element.get('Drunk')) && (!element.get('Locked'))) > 0;
}

function lives_faction(faction) {
  return state => state.get('Characters').count(element => element.get('Faction') == faction && element.get('Alive')) > 0;
}

function wake_up(character_name) {
  return state => next_step(state).updateIn(['Characters', get_character(state, character_name).get('UID'), 'Awaken'], _ => true);
}

function is_awaken(character_name) {
  return state => get_character(state, character_name).get('Awaken') == true;
}

function go_asleep(character_name) {
  return state => next_step(state).updateIn(['Characters', get_character(state, character_name).get('UID'), 'Awaken'], _ => false);
}

function nameof(character_id, state) {
  var character = state.getIn(['Characters', character_id]);
  if(character.get('RealName') == undefined) {
    return "<imię: " + character.get('Name') + ">";
  } else {
    return character.get('RealName') + '(' + character.get('Name') + ')';
  }
}

function get_active_bandits(state) {
  return state.get('Characters').filter(
    character => character.get('Faction') == 'bandyta' && character.get('Alive') && (!character.get('Drunk')) && (!character.get('Locked')));
}


function message(title, description, filter, modifier) {
  if(filter == undefined) {
    filter = state => true;
  }
  if(modifier == undefined) {
    modifier = state => next_step(state);
  }
  return {
    title: title,
    description: description,
    inputs: [],
    buttons: [ { text: "OK", modifier: modifier } ],
    filter: filter
  };
}

var PlotZero = Immutable.fromJS(
[
  message('Wszyscy idą spać', undefined, _ => true /*, set everybody to Awaken = false */),
  // Kurtyzana
  message('Budzi się Kurtyzana', undefined, active('kurtyzana'), wake_up('kurtyzana')),
  {
      title: "Wybiera osobę, którą chce poznać",
      description: `Budzi się wybrana osoba, poznaje kurtyzanę.
                    Kurtyzana poznaje kartę wybranej osoby.`,
      inputs: [ {
          name: "character",
          type: "character",
          filter: (state, input) =>
              input.get("ID") != 'kurtyzana' && input.get("Alive")
      } ],
      buttons: [ {
          text: "OK",
          enable: state => state.getIn(['Input', 0]) != undefined,
          modifier: state => next_step(state)
      } ],
      filter: is_awaken('kurtyzana')
  },
  message('Kurtyzana i jej klient idą spać', undefined, is_awaken('kurtyzana'), go_asleep('kurtyzana')),
  // Uwodziciel
  // TODO
  // Szantażysta
  // TODO
  // Szeryf
  message('Budzi się Szeryf', undefined, active('szeryf'), wake_up('szeryf')),
  {
    title: "Wybiera osobę, którą chce zamknąć",
    inputs: [ {
      name: "character",
      type: "character",
      filter: (state, input) => input.get("Alive"),
    } ],
    buttons: [ {
      text: "OK",
      enable: state => state.getIn(['Input', 0]) != undefined,
      modifier: function (state) {
        var search_result = {};
        var serif = get_character(state, 'szeryf').get('UID');
        var lockee = state.getIn(['Input', 0]).get('UID');
        state = next_step(state);
        state = commands.search(state, serif, lockee, search_result);
        state = commands.lock_somebody_up(state, lockee);
        state = state.update('SerifGotStatuette', _ => search_result.found);
        state = state.update('LockedBySerif', _ => lockee);
        return state;
      }
    } ],
    filter: is_awaken('szeryf')
  },
  message(
    state => nameof(state.get('LockedBySerif'), state) + ' został(a) zamknięta przez Szeryfa', undefined,
    state => state.get('LockedBySerif') != undefined && ~state.get('SerifGotStatuette') && is_awaken('szeryf')(state),
    state => next_step(state)
                .update('LockedBySerif', _ => undefined)
                .update('SerifGotStatuette', _ => false)
  ),
  message(
    'Szeryf zamknął właściciela posążka', undefined,
    state => state.get('LockedBySerif') != undefined && state.get('SerifGotStatuette') && is_awaken('szeryf')(state),
    state => next_step(state)
                .update('LockedBySerif', _ => undefined)
                .update('SerifGotStatuette', _ => false)
  ),
  message('Szeryf idzie spać', undefined, is_awaken('szeryf'), go_asleep('szeryf')),

  // Pastor
  message('Budzi się Pastor', undefined, active('pastor'), wake_up('pastor')),
  {
    title: "Wybiera osobę, którą chce wyspowiadać",
    description: "Poznaje frakcję wybranej osoby, spowiadana osoba nie wie, że jest spowiadana.",
    inputs: [ {
      name: "character",
      type: "character",
      filter: (state, input) => input.get("Alive")
    } ],
    buttons: [ {
      text: "OK",
      enable: state => state.getIn(['Input', 0]) != undefined,
      modifier: state => next_step(state).update('SpowiadanaByPastor', _ => state.getIn(['Input', 0]))
    } ],
    filter: is_awaken('pastor')
  },
  message('Pastor idzie spać', undefined, is_awaken('pastor'), go_asleep('pastor')),
  // Bandyci
  message('Budzą się bandyci', undefined, lives_faction('bandyta'), wake_up('bandyta')),
  message('Poznają się... ', state => 'Przedstawiają się: ' + state.get('Characters')
            .filter(character => character.get('Faction') == 'bandyta' && character.get('Alive'))
            .map(character => character.get('Name')).join(', '), is_awaken('bandyta')),
  {
    title: 'Ustalają, kto ma posążek.',
    description: state => 'Liczba głosujących: ' + get_active_bandits(state).size +
      '.  Najwyższy rangą: ' + get_active_bandits(state).sortBy(character => character.get('Rank')).first().get('Name'),
    inputs: [ {
      name: "character",
      type: "character",
      filter: (state, input) => input.get("Alive") && input.get('Faction') == 'bandyta' && (!input.get('Drunk')) && (!input.get('Locked'))
    } ],
    buttons: [ {
      text: "OK",
      enable: state => state.getIn(['Input', 'character']) != undefined,
      modifier: state => next_step(state).update('StatuetteOwner', _ => state.getIn('Input', 0, 'UID'))
    } ],
    filter: is_awaken('bandyta')
  },
  message('Bandyci idą spać', undefined, is_awaken('bandyta'), go_asleep('bandyta'))
  // TODO
  // TODO
]
)

var Plot = Immutable.fromJS([
])

export default {PlotZero, Plot};
