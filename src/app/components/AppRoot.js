import React from 'react/addons';
import Debug from 'debug';
import Actions from '../actions';

import Component from './Component';
import SetupPage from './Setup'
import UndoComponent from './UndoComponent';
import CharactersStatus from './CharactersStatus';
import ControlPanel from './ControlPanel';

import config from '../../../config/app';

import State from '../../ktulu/state';

var debug = Debug('ktulu-manitou');


class AppRoot extends React.Component {

  shouldComponentUpdate () {
    return React.addons.PureRenderMixin.shouldComponentUpdate.apply(this, arguments);
  }

  getChildContext () {
    return {
      actions: this.props.actions
    };
  }

  render () {
    debug('render <AppRoot/>');

    if(this.props.state.Started) {
        return <div>
          <ControlPanel state={this.props.state}></ControlPanel>
          <CharactersStatus state={this.props.state}></CharactersStatus>
          <UndoComponent state={this.props.state}></UndoComponent>
        </div>;
    } else {
        return <div>
          <SetupPage state={this.props.state}></SetupPage>
          <UndoComponent state={this.props.state}></UndoComponent>
        </div>;
    }
  }
}

AppRoot.childContextTypes = Component.contextTypes;

AppRoot.propTypes = {
  actions: React.PropTypes.instanceOf(Actions).isRequired,
  state: React.PropTypes.instanceOf(State).isRequired
};

export default AppRoot;
