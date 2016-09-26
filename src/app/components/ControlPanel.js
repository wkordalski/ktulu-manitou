import React from 'react/addons';
import Debug from 'debug';

import Component from './Component';
import CharacterInput from './CharacterInput';

import State from '../../ktulu/state';
import {PlotZero,Plot} from '../../ktulu/plot';

var debug = Debug('ktulu-manitou');

class ControlPanel extends Component {

  buttonClicked(button_id, event) {
    this.context.actions.buttonClicked({
      button_id: button_id
    });
  }

  leaveFiltered() {
    this.context.actions.leaveFiltered({});
  }

  getCurrentStep() {
    var current_plot = this.props.state.get('Date') == 0? PlotZero : Plot;
    if(current_plot.get(this.props.state.get('Time')).get('filter')(this.props.state) == false) {
      this.leaveFiltered();
    }
    return current_plot.get(this.props.state.get('Time'));
  }

  getTitle(step) {
    if(step.get('title') instanceof Function) {
      return step.get('title')(this.props.state);
    } else {
      return step.get('title');
    }
  }

  getDescription(step) {
    if(step.get('description') instanceof Function) {
      return step.get('description')(this.props.state);
    } else {
      return step.get('description');
    }
  }

  render () {
    debug('Time: ', this.props.state.get('Time'));
    var _this = this;
    var current_step = this.getCurrentStep();

    return <div>
      <h3>{this.getTitle(current_step)}</h3>
      <p>{this.getDescription(current_step)}</p>
      {
        current_step.get('inputs').map(
          function (element, idx) {
            if(element.get('type') == 'character') {
              return <CharacterInput state={_this.props.state} name={'input-' + idx} id={idx} filter={element.get('filter')} key={'input-' + idx}></CharacterInput>;
            }
          }
        )
      }
      {
        current_step.get('buttons').map(
          (element, id) => <input type="button" name={'button-' + id} key={'button-' + id} value={element.get('text')} disabled={element.get('enable') != undefined && element.get('enable')(this.props.state) == false} onClick={this.buttonClicked.bind(this, id)} />)
      }
    </div>;
  }
}

ControlPanel.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired
};

export default ControlPanel;
