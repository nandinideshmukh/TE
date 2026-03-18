import React from 'react'

export default class User extends React.Component {

    style = {
        padding: '5px',
        margin: '2px',
        background: '#EEE',
    }

    render() {
        return <div style={this.style}>{this.props.name}</div>;
    }

}