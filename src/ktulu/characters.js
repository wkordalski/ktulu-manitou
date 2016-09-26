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

var Kurtyzana = Immutable.Record(_.merge({}, CharacterBase, {
    ID: 'kurtyzana',
    Name: 'Kurtyzana',
    Faction: 'miastowy',
    FactionColor: '#ffff00',
}))
var Szeryf = Immutable.Record(_.merge({}, CharacterBase, {
    ID: 'szeryf',
    Name: 'Szeryf',
    Faction: 'miastowy',
    FactionColor: '#ffff00'
}))
var Pastor = Immutable.Record(_.merge({}, CharacterBase, {
    ID: 'pastor',
    Name: 'Pastor',
    Faction: 'miastowy',
    FactionColor: '#ffff00'
}))

var Miastowy = Immutable.Record(_.merge({}, CharacterBase, {
    ID: 'miastowy',
    Number: -1,
    Name: 'Zwykły miastowy',
    Faction: 'miastowy',
    FactionColor: '#ffff00'
}))

var Herszt = Immutable.Record(_.merge({}, CharacterBase, {
  ID: 'herszt',
  Name: 'Herszt',
  Faction: 'bandyta',
  FactionColor: '#2200aa',
  Rank: 0                   // Najwyższy rangą
}))

var CharacterMeta = Immutable.Record({
  type: undefined,
  unique: false,
  name: undefined
})

var Characters = Immutable.fromJS([
    new CharacterMeta({ type: Kurtyzana, name: 'kurtyzana', unique: true }),
    new CharacterMeta({ type: Szeryf, name: 'szeryf', unique: true }),
    new CharacterMeta({ type: Pastor, name: 'pastor', unique: true }),
    new CharacterMeta({ type: Miastowy, name: 'miastowy', unique: false }),

    new CharacterMeta({ type: Herszt, name: 'herszt', unique: true }),
])

export default Characters;
