import React from 'react/addons';
import Debug from 'debug';

import Component from './Component';

import State from '../../ktulu/state';

var debug = Debug('ktulu-manitou');

class UndoComponent extends Component {

  onUndoClicked () {
    this.context.actions.undo();
  }


  render () {
    var state = this.props.state;
    return <div>
      <input type="button" disabled={this.props.state.LastAction == undefined} onClick={this.onUndoClicked.bind(this)} value="Cofnij" />
    </div>;
  }
}

UndoComponent.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired
};

export default UndoComponent;

