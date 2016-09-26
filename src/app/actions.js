import {SETUP_PAGE, GAME, UNDO} from './const';

var debug = require('debug')('ktulu-manitou:actions');

/*
 * @class Actions
 */
class Actions {

  /*
   * @constructs Actions
   * @param {Object} dispatcher
   */
  constructor (dispatcher, store) {
    this.dispatcher = dispatcher;
    this.store = store;
  }

  changeDuelsPerDay(options) {
    var value = options.value;
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.DUELS_PER_DAY_CHANGE,
      value: value
    });
  }
  changeSearchesPerDay(options) {
    var value = options.value;
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.SEARCHES_PER_DAY_CHANGE,
      value: value
    });
  }

  changeShipArrivalTime(options) {
    var value = options.value;
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.SHIP_ARRIVAL_TIME_CHANGE,
      value: value
    });
  }

  addCharacter(options) {
    debug("Add character: ", options.character);
    var character = options.character;
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.ADD_CHARACTER,
      character: character
    });
  }

  removeCharacter(options) {
    var character_index = options.character_index;
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.REMOVE_CHARACTER,
      character_index: character_index
    });
  }

  startGame(options) {
    this.dispatcher.dispatch({
      actionType: SETUP_PAGE.START_GAME
    });
  }

  setInput(options) {
    debug(options);
    this.dispatcher.dispatch({
      actionType: GAME.SET_INPUT,
      id: options.id,
      value: options.value
    });
  }

  buttonClicked(options) {
    this.dispatcher.dispatch({
      actionType: GAME.BUTTON_CLICKED,
      button_id: options.button_id
    });
  }

  leaveFiltered() {
    this.dispatcher.dispatch({
      actionType: GAME.LEAVE_FILTERED
    });
  }

  undo(options) {
    this.dispatcher.dispatch({
      actionType: UNDO
    });
  }
}

export default Actions;
