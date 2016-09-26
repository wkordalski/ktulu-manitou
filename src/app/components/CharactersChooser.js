import React from 'react/addons';
import Debug from 'debug';
import Component from './Component';
import State from '../../ktulu/state';
import Characters from '../../ktulu/characters';

var debug = Debug('ktulu-manitou');

class CharactersChooser extends Component {

  onAddCharacter(character_id, event) {
    var character = new (Characters.get(character_id).get('type'))();
    this.context.actions.addCharacter({
      character: character
    });
  }

  onRemoveCharacter(character_id, event) {
    this.context.actions.removeCharacter({
      character_index: character_id
    });
  }

  render () {
    var state = this.props.state;

    var _this = this;

    return <div><div>
    {
      Characters.map(function (value, idx) {
        if(value.get('unique') == true &&
          _this.props.state.get('Characters').count(ch => ch.get('ID') == value.get('name')) > 0) {
          return;
        }
        var character = new (value.get('type'))();
        return <div style={
          {
            border: "2px solid " + character.get('FactionColor'),
            margin: "4px",
            width: "200px",
            padding: "2px",
            display: "block"
          }} key={idx}>
            <div style={{flow: "left", display: "block"}}>
              {character.get('Name')}
            </div>
            <div style={{flow: "right", display: "block"}}>
              <input name={value.get('name')} type="button" onClick={_this.onAddCharacter.bind(_this, idx)} value="Dodaj" />
            </div>
          </div>;

      })
    }
    </div>
    <hr />
    <div>
    {
      this.props.state.Characters.map(function(character, idx) {
        return <div style={
          {
            border: "2px solid " + character.get('FactionColor'),
            margin: "4px",
            width: "200px",
            padding: "2px",
            display: "block"
          }} key={character.get('ID') + idx}>
            <div style={{flow: "left", display: "block"}}>
              {character.get('Name')}
            </div>
            <div style={{flow: "right", display: "block"}}>
              <input name={character.get('ID')} type="button" onClick={_this.onRemoveCharacter.bind(_this, idx)} value="Usuń" />
            </div>
          </div>;
      })
    }
    </div></div>;
  }
}

CharactersChooser.propTypes = {
  state: React.PropTypes.instanceOf(State).isRequired
};

export default CharactersChooser;

