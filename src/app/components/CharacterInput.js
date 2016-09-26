import React from 'react/addons';
import Debug from 'debug';

import Component from './Component';

import State from '../../ktulu/state';
import Characters from '../../ktulu/characters';

var debug = Debug('ktulu-manitou');

class CharacterInput extends Component {

  chosen(event) {
    var value = undefined;
    if(event.target.value != '') {
      value = this.props.state.getIn(['Characters', event.target.value]);
    }
    var id = this.props.id;
    this.context.actions.setInput({
      id: id,
      value: value
    });
  }

  render () {
    var state = this.props.state;
    var filter = this.props.filter;
    if(filter == undefined) {
      filter = (state, input) => true;
    }

    var _this = this;

    return <select onChange={this.chosen.bind(this)} value={this.props.state.getIn(['Input', this.props.id, 'UID'])}>
    <option value="" key="">--- Wybierz wartość ---</option>
    {
      this.props.state.Characters
        .filter(input => filter(this.props.state, input))
        .map(function(character, index) {
          return <option key={character.get('UID')} value={character.get('UID')}>
              {character.get('Name') + (character.get('Number') == undefined?'':(' ' + character.get('Number')))}
            </option>;
        })
    }
    </select>;
  }
}

CharacterInput.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired,
  name: React.PropTypes.string.isRequired,
  id: React.PropTypes.number.isRequired,
  filter: React.PropTypes.instanceOf(Function)
};

export default CharacterInput;


