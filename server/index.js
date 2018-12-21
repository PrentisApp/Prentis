
    // ------------------------------------------------------
    // Import all required packages and files
    // ------------------------------------------------------

    let Pusher     = require('pusher');
    let express    = require('express');
    let app        = express();
    let bodyParser = require('body-parser')

    let pusher     = new Pusher(require('./config.js'));

    // ------------------------------------------------------
    // Set up Express middlewares
    // ------------------------------------------------------

    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({ extended: false }));

    // ------------------------------------------------------
    // Define routes and logic
    // ------------------------------------------------------

    app.post('/accept', (req, res, next) => {
        let payload = {answer: "accept"}
        pusher.trigger('answers', req.body.channel, payload);

        console.log("channel: " + req.body.channel);
        console.log("You accepted the call");

        res.json({success: 200});
    });

    app.post('/decline', (req, res, next) => {
        let payload = {answer: "decline"}
        pusher.trigger('answers', req.body.channel, payload);

        console.log("channel: " + req.body.channel);
        console.log("You declined the call");
        
        res.json({success: 200});
    });

    app.post('/call', (req, res, next) => {
      let payload = {channel: req.body.channel, caller: req.body.caller};
      pusher.trigger('calls', req.body.channel, payload);
        
      console.log("hi you just called");
      console.log("caller: " + req.body.caller);
      console.log("channel: " + req.body.channel);

      res.json({success: 200});
    });

    app.get('/', (req, res) => {
      res.json("It works!");
    });


    // ------------------------------------------------------
    // Catch errors
    // ------------------------------------------------------

    app.use((req, res, next) => {
        let err = new Error('Not Found: ');
        err.status = 404;
        next(err);
    });


    // ------------------------------------------------------
    // Start application
    // ------------------------------------------------------

    app.listen(4000, () => console.log('App listening on port 4000!'));
