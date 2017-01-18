import Immutable from 'immutable';

var GameParameters = Immutable.Record({
  // Day settings...
  SearchesPerDay: 2,
  DuelsPerDay: 2,

  // Bandits settings...
  ShipArrivalTime: 3,
})

var Factions = Immutable.Record({
  Citizens: undefined,
  Bandits: undefined,
  Indians: undefined,
})

var Characters = Immutable.Record({
  Hooker: undefined,
  Sheriff: undefined,
  Parson: undefined,

  Chieftain: undefined,
})

var State = Immutable.Record({
    Started: false, // means setup is running
    Won: undefined, // will contain winning Faction

    //
    // GAME SETTINGS
    //
    Parameters: new GameParameters(),

    // Time in game...
    Date: 0,
    IsDay: false,
    Time: 0,

    //
    // CHARACTERS
    //
    Factions: new Factions(),
    Characters: new Characters(),

    // Time statistics
    LastAction: undefined,
    ListActionTime: 0,

    // User interface...
    Input: new Immutable.List(),
    Button: -1,
});

export default State;
