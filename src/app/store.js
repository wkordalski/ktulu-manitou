import {EventEmitter} from 'events';
import Immutable from 'immutable';
import Debug from 'debug';
import _ from 'lodash';
import {PlotZero, Plot} from '../ktulu/plot';

import {CHANGE, SETUP_PAGE, GAME, UNDO} from './const';

import State from '../ktulu/state';

var debug = Debug('ktulu-manitou:store');

/*
 * @class Store
 */
class Store extends EventEmitter {

  /*
   * @constructs Store
   * @extends events.EventEmitter
   * @param {Object} dispatcher
   * @param {Object} [state]
   */
  constructor (dispatcher, state) {
    super();

    var _this = this;

    if (!dispatcher) {
      debug(new Error('Store: dispatcher is required'));
    }

    if (state) {
      debug('app is created with initial state', state);
    } else {
      state = Store.defaultState
    }

    // Register handlers
    dispatcher.register(function (action) {
      if (action.actionType === SETUP_PAGE.DUELS_PER_DAY_CHANGE) {
        _this.state = _this.state.update('DuelsPerDay', _ => action.value);
        _this.emit(CHANGE);
      } else if (action.actionType === SETUP_PAGE.SEARCHES_PER_DAY_CHANGE) {
        _this.state = _this.state.update('SearchesPerDay', _ => action.value);
        _this.emit(CHANGE);
      } else if (action.actionType === SETUP_PAGE.SHIP_ARRIVAL_TIME_CHANGE) {
        _this.state = _this.state.update('ShipArrivalTime', _ => action.value);
        _this.emit(CHANGE);
      } else if (action.actionType === SETUP_PAGE.ADD_CHARACTER) {
        _this.state = _this.state.update('Characters', value => value.push(action.character));
        _this.emit(CHANGE);
      } else if (action.actionType === SETUP_PAGE.REMOVE_CHARACTER) {
        _this.state = _this.state.update('Characters', value => value.remove(action.character_index));
        _this.emit(CHANGE);
      } else if (action.actionType === SETUP_PAGE.START_GAME) {
        _this.state = _this.state
          .update('Started', _ => true)
          .update('LastAction', _ => _this.state);
        // Give characters their unique IDs.
        for(var i = 0; i < _this.state.Characters.size; i++) {
          _this.state = _this.state.updateIn(['Characters', i, 'UID'], _ => i);
          if(_this.state.Characters.get(i).ID == 'kurtyzana')
        }
        // Number multi-instance characters.
        var count_dictionary = new Map();
        for(var i = 0; i < _this.state.get('Characters').size; i++) {
          var character = _this.state.getIn(['Characters', i]);
          if(character.get('Number') != undefined) {
            if(character.get('ID') in count_dictionary) {
              count_dictionary[character.get('ID')] += 1;
            } else {
              count_dictionary[character.get('ID')] = 1;
            }
            debug(count_dictionary);
            _this.state = _this.state.updateIn(['Characters', i, 'Number'], _ => count_dictionary[character.get('ID')]);
          }
        }
        // TODO: set statuette owner to nobody
        _this.emit(CHANGE);
      } else if (action.actionType === GAME.SET_INPUT) {
        debug(_this.state);
        _this.state = _this.state.updateIn(['Input', action.id], _ => action.value);
        debug(_this.state);
        _this.emit(CHANGE);
      } else if (action.actionType === GAME.BUTTON_CLICKED) {
        var current_plot = _this.state.get('Date') == 0? PlotZero : Plot;
        _this.state = _this.state.update('Button', _ => action.button_id);
        _this.state = current_plot.get(_this.state.get('Time')).get('buttons').get(action.button_id).get('modifier')(_this.state);
        _this.emit(CHANGE);
      } else if (action.actionType === GAME.LEAVE_FILTERED) {
        var current_plot = _this.state.get('Date') == 0? PlotZero : Plot;
        while(current_plot.get(_this.state.get('Time')).get('filter')(_this.state) == false) {
          _this.state = _this.state.update('Time', value => value + 1);
        }
        _this.emit(CHANGE);
      } else if (action.actionType === UNDO) {
        if (_this.state.get('LastAction')) {
          _this.state = _this.state.get('LastAction');
          _this.emit(CHANGE);
        }
      }
    });

    _this.state = state;
  }

  /*
   * @method getState
   * @returns {State} - state
   */
  getState () {
    return this.state;
  }
}

// Default state
Store.defaultState = new State();

export default Store;
