const express = require('express')
const app = express()
const port = 5000
const bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

const {
    User
} = require("./models/User")

const {
    MongoClient
} = require('mongodb');
const uri = "mongodb+srv://scyun:<password>@boilerplate.q8rhm.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";
const client = new MongoClient(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true
});
client.connect(err => {
    const collection = client.db("test").collection("devices");
    // perform actions on the collection object
    client.close();
});

app.get('/', (req, res) => res.send('Hello World! 안녕하세요'))

app.post('/register', (req, res) => {
    //회원 가입 정보 db insert
    const user = new User(req.body);
    user.save((err, doc) => {
        if (err) return err.json({
            success: false,
            err
        });
        return res.status(200).json({
            success: true
        })
    });
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))