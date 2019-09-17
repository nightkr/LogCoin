import React from 'react';
import 'bootstrap';
import { Button, FormControl, InputGroup } from 'react-bootstrap';
import { Route, Link, BrowserRouter, Switch } from 'react-router-dom';
import './App.css';
import { Sankey } from 'react-vis';

class SearchInput extends React.Component {
  constructor(props) {
    super(props);
    this.state = { id: "" }
  }

  handleInputChange(id) {
      this.setState({
        id
      })
  }

  render() {
    return (
      <div className="centered-container">
          <InputGroup className="mb-3">
            <FormControl
              placeholder="Enter consignment ID"
              onChange={event => this.handleInputChange(event.target.value)} 
              type="text"
            />
            <InputGroup.Append>
              <Link className="btn btn-outline-primary" to={`/network-graph/${this.state.id}`}>Search</Link>
            </InputGroup.Append>
          </InputGroup>
      </div>
    );
  }
}

class NetworkGraph extends React.Component {
  constructor(props) {
    super(props)
    this.state = { 
      id: this.props.match.params.id,
      transactions: {
        nodes: [],
        links: []
      }
    }
  }

  componentWillMount() {
    var transactionId = this.state.id

    /*var transactions = [
      {
        "from": [
          {"account": "Mine 1", "amount": 5.49}, 
          {"account": "Mine 2", "amount": 10.9},
          {"account": "Mine 3", "amount": 5.49},
        ],
        "to": {"account": "Melter", "amount": 5.49},
      }
    ]*/

    fetch(`http://127.0.0.1:8080/account/${transactionId}/transaction-tree`)
    .then(response => response.json())
    .then(function(response) {
      //var transactions = JSON.parse(`{"items":[{"transaction":"fb40faaf-4519-4550-bc20-85cd22d775e9","from":[],"to":{"account":"d0840394-5ed2-46db-807a-7a5ca9c8924a","amount":10000}},{"transaction":"70667bbb-1931-42df-b643-95ea9a39ffdc","from":[{"account":"d0840394-5ed2-46db-807a-7a5ca9c8924a","amount":5000}],"to":{"account":"d1ae5ed1-b0d9-4252-9a41-70dbc392670b","amount":5000}}]}`).items
      //var transactions = response.json()
      var transactions = response.items;
      
      console.log(transactions)
      // nodes: [{"name": "foo", "name": "bar", "name": "tar"}]
      //                    foo            bar
      // links: [{"source": "0", "target": "1", "value": "1.0"}]
      var result = {
        "nodes": [],
        "links": []
      };

      var fromNames = transactions.map((transaction) => transaction.from.map((from) => from.account)).flat()
      var toNames = transactions.map((transaction) => transaction.to.account)
      var names = new Set()
      fromNames.concat(toNames).forEach((name) => names.add(name))
      result.nodes = Array.from(names).map((name) => ({"name": name}))
      var onlyNames = result.nodes.map((obj) => obj.name)
      var links = []
      transactions.forEach((transaction) => {
        transaction.from.forEach((from) => { 
          links.push({source: onlyNames.indexOf(from.account), target: onlyNames.indexOf(transaction.to.account), value: from.amount})
        }); 
      });
      result.links = links
      this.setState({
        transactions: result
      })
    });
  }

  render() {
    return (
      <Sankey
          animation
          margin={50}
          nodes={this.state.transactions.nodes}
          links={this.state.transactions.links}
          width={960}
          height={800}
          layout={24}
          nodeWidth={15}
          nodePadding={10}
          style={{
            links: {
              opacity: 0.3
            },
            labels: {
              fontSize: '12px',
            },
          }}
        />
    );
  }
}

function App() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/network-graph/:id" component={NetworkGraph}/>
        <Route path="/" component={SearchInput} exactMatch={true}/>
      </Switch>
    </BrowserRouter>
  );
}

export default App;
