**Note:** All the steps are tagged as 'step-1', 'step-2' and 'step-3'. Checkout at each step and give a try.
After every checkout, whenever 'package.json' changes, execute `npm install`

# Frontend - ReactJS

*Use `git checkout step-1`*

**Development Mode**

Runs a temporary server in local for easier development (say hotswapping changes)

Access Url: [http://localhost:3000](http://localhost:3000)

```
$ npm start
```
**Production Mode**

Transpiles (ES6 -> Old JS), Bundles (Single JS) and create a production ready static files.

Access Folder Name: `build/`

```
$ npm run build
```

# Backend - Node Server with Express Framework

*Use `git checkout step-2`*

Starts the actual node server (same for development and production)

Access Url:  [http://localhost:5000](http://localhost:5000/api/user)

```
$ node server.js
```

### Using Pages and Api Calls via same domain

*Use `git checkout step-3`*

For pages, Production ready frontend pages are available in **'build'** folder

For api, Node server (in this example) is started in 5000 port [http://localhost:5000](http://localhost:5000)

Now we need to access the frontend pages ('build' folder) via node server. For this, we'll tell express to use 'build' folder using one line of code (See [here](https://github.com/rambabusaravanan/mern-starter/commit/62ce2910d167b89d4b3e531c1bded593c88fb178#diff-78c12f5adc1848d13b1c6f07055d996eR28))


### Connecting MongoDB - using 'mongoskin'

*Use `git checkout step-4`*

**Insert data via http post api call or in mongo shell directly**

POST /api/user  --data '{"name": "Andro", "age": 24}'

**Access the data via api or in [main page](http://localhost:5000)**

GET /api/user

GET /api/user/{userid}

GET /api/search?name=Andro

GET /api/search?age=24


### Important

Whenever you want to view both pages with api calls in action, always run `npm run build` followed by `node server.js`