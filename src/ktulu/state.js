import Immutable from 'immutable';

var State = Immutable.Record({
    Started: false, // means setup is running
    Won: undefined, // will contain winning Faction
    // Day settings...
    SearchesPerDay: 2,
    DuelsPerDay: 2,

    // Bandits settings...
    ShipArrivalTime: 3,

    // Time in game...
    Date: 0,
    IsDay: false,
    Time: 0,

    // Characters...
    Characters: new Immutable.List(),

    StatuetteOwner: -1,       // czyli kto oficjalnie ma posążek
    StatuetteHolder: -1,      // jeśli się go zabije, to przejmuje się posążek
    LockedBySerif: undefined,
    SerifGotStatuette: false,
    SpowiadanaByPastor: undefined,

    // Time statistics
    LastAction: undefined,
    ListActionTime: 0,

    // User interface...
    Input: new Immutable.List(),
    Button: -1,
});

export default State;
