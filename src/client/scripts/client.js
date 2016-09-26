import Debug from 'debug';
import App from '../../app';

var attachElement = document.getElementById('app');

var app;

Debug.enable('ktulu-manitou*');

// Create new app and attach to element
app = new App({
    store: undefined
});

app.renderToDOM(attachElement);
