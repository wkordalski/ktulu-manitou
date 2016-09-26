import React from 'react/addons';
import Debug from 'debug';

import Component from './Component';

import State from '../../ktulu/state';
import {PlotZero,Plot} from '../../ktulu/plot';

var debug = Debug('ktulu-manitou');

class CharactersStatus extends Component {

  render () {
    var state = this.props.state;

    return <div>
      {
        this.props.state.Characters.map(function(character, index) {
          return <div style={
            {
              border: "2px solid " + character.get('FactionColor'),
              margin: "4px",
              width: "200px",
              padding: "2px",
              display: "block"
            }} key={character.get('UID')}>
                {character.get('Name') + (character.get('Number') == undefined?'':(' ' + character.get('Number'))) }
                [{character.get('Locked')?'#':''}{character.get('Drunk')?'%':''}]
            </div>;
          }
        )
      }
      </div>;
  }
}

CharactersStatus.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired
};

export default CharactersStatus;


