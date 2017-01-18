import Immutable from 'immutable';
import _ from 'lodash';

var CharacterBase = {
    UID: -1,
    Alive: true,        // żyje
    Locked: false,      // zamknięty
    Drunk: false,       // upity
    Awaken: false,      // obudzony
    RealName: undefined
}

var Hooker = Immutable.Record(_.merge({}, CharacterBase, {
  Role: ROLES.HOOKER,
  Faction: FACTIONS.CITIZENS,
}))
var Sheriff = Immutable.Record(_.merge({}, CharacterBase, {
  Role: ROLES.SHERIFF,
  Faction: FACTIONS.CITIZENS,
}))
var Parson = Immutable.Record(_.merge({}, CharacterBase, {
  Role: ROLES.PARSON,
  Faction: FACTIONS.CITIZENS,
}))

var Miastowy = Immutable.Record(_.merge({}, CharacterBase, {
  // TODO
}))

var Chieftain = Immutable.Record(_.merge({}, CharacterBase, {
  Role: ROLES.CHIEFTAIN,
  Faction: FACTIONS.BANDIT,
  Rank: 0                   // Najwyższy rangą
}))

var CharacterMeta = Immutable.Record({
  name: undefined,
  color: '#000000',
  show: state => true,
  adder: state => state
})

var Characters = Immutable.fromJS([
  new CharacterMeta({ name: 'Kurtyzana', color: '#eedd00',
      show: state => state.Characters.Hooker == undefined,
      adder: state => state.updateIn(['Characters', 'Hooker'], _ => new Hooker())
  }),
  new CharacterMeta({ name: 'Szeryf', color: '#eedd00',
      show: state => state.Characters.Sheriff == undefined,
      adder: state => state.updateIn(['Characters', 'Sheriff'], _ => new Sheriff())
  }),
  new CharacterMeta({ name: 'Pastor', color: '#eedd00',
      show: state => state.Characters.Parson == undefined,
      adder: state => state.updateIn(['Characters', 'Parson'], _ => new Parson())
  }),

  //new CharacterMeta({ type: Miastowy, name: 'miastowy', unique: false }),

  new CharacterMeta({ name: 'Herszt', color: '#2211dd',
      show: state => state.Characters.Chieftain == undefined,
      adder: state => state.updateIn(['Characters', 'Chieftain'], _ => new Chieftain())
  }),
])

function get_characters_list(state) {
  // returns list of characters (name, color, remover)
}
export default Characters;
