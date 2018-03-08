import React, { Component } from 'react';
import { Form, Button, Input, Message } from 'semantic-ui-react';

import Layout from '../../components/Layout';
import factory from '../../ethereum/factory';
import web3 from '../../ethereum/web3';
import { Router } from '../../routes';

class CampaignNew extends Component {
  state = {
    minimumContribution: '',
    loading: false,
    errorMessage: '',
  };

  onSubmit = async () => {
    const accounts = await web3.eth.getAccounts();
    this.setState({ loading: true, errorMessage: '' });
    try {
      await factory.methods
        .createCampaign(this.state.minimumContribution)
        .send({ from: accounts[0] });
    } catch (err) {
      this.setState({ errorMessage: err.message.split('\n')[0] });
    }
    Router.pushRoute('/');
    this.setState({ loading: false });
  };

  render() {
    return (
      <Layout>
        <h3>Create a Campaign</h3>
        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Minimum Contribution</label>
            <Input
              label="wei"
              labelPosition="right"
              onChange={event =>
                this.setState({ minimumContribution: event.target.value })
              }
            />
          </Form.Field>
          <Button loading={this.state.loading} primary>
            Create!
          </Button>
          <Message error header="Oops!" content={this.state.errorMessage} />
        </Form>
      </Layout>
    );
  }
}

export default CampaignNew;
