import React from 'react/addons';
import Debug from 'debug';

import Component from './Component';
import CharactersChooser from './CharactersChooser';

import State from '../../ktulu/state';

var debug = Debug('ktulu-manitou');

class SetupPage extends Component {

  onDuelsPerDayChange(event) {
    this.context.actions.changeDuelsPerDay({value: event.target.value});
  }

  onSearchesPerDayChange(event) {
    this.context.actions.changeSearchesPerDay({value: event.target.value});
  }

  onShipArrivalTimeChange(event) {
    this.context.actions.changeShipArrivalTime({value: event.target.value});
  }

  onStartGame() {
    this.context.actions.startGame();
  }


  render () {
    var state = this.props.state;
    return <div>
      Ilość pojedynków: <input type="number" min="0" max="9" value={this.props.state.DuelsPerDay} onChange={this.onDuelsPerDayChange.bind(this)} /><br/>
      Ilość przeszukiwanych osób: <input type="number" min="0" max="9" value={this.props.state.SearchesPerDay} onChange={this.onSearchesPerDayChange.bind(this)} /><br />
      Czas przybycia statku (numer poranka): <input type="number" min="0" max="9" value={this.props.state.ShipArrivalTime} onChange={this.onShipArrivalTimeChange.bind(this)} /><br />
      <CharactersChooser state={this.props.state}></CharactersChooser><br />
      <input type="button" onClick={this.onStartGame.bind(this)} value="Rozpocznij grę" />
    </div>;
  }
}

SetupPage.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired
};

export default SetupPage;

