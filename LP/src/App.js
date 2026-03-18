import React, { Component } from 'react';
import './App.css';
import request from 'superagent';

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      users: [],
      name: '',
      age: '',
      errors: {
        name: '',
        age: ''
      },
      showSuccess: false
    };
  }

  componentDidMount() {
    this.getUsers();
  }

  // Fetch users
  getUsers = () => {
    request.get('http://localhost:5000/api/user')
      .then((res) => {
        this.setState({ users: res.body });
      })
      .catch(err => console.log(err));
  }

  // Handle input
  handleChange = (e) => {
    const { name, value } = e.target;
    this.setState({ 
      [name]: value,
      errors: {
        ...this.state.errors,
        [name]: '' // Clear error when user starts typing
      }
    });
  }

  // Validate inputs
  validateInputs = () => {
    const { name, age } = this.state;
    let isValid = true;
    const errors = {
      name: '',
      age: ''
    };

    // Validate name
    if (!name.trim()) {
      errors.name = 'Name is required';
      isValid = false;
    } else if (name.trim().length < 3) {
      errors.name = 'Name must be at least 3 characters long';
      isValid = false;
    }

    // Validate age
    if (!age) {
      errors.age = 'Age is required';
      isValid = false;
    } else {
      const ageNum = Number(age);
      if (isNaN(ageNum) || ageNum < 1 || ageNum > 120) {
        errors.age = 'Please enter a valid age (1-120)';
        isValid = false;
      }
    }

    this.setState({ errors });
    return isValid;
  }

  // Add user
  addUser = () => {
    if (!this.validateInputs()) {
      return;
    }
    // replace with your public ip of instance
    request.post('http://localhost:5000/api/user')
      .send({
        name: this.state.name.trim(),
        age: this.state.age
      })
      .then(() => {
        this.getUsers(); // refresh list
        this.setState({ 
          name: '', 
          age: '',
          errors: {
            name: '',
            age: ''
          },
          showSuccess: true
        });

        // Hide success message after 3 seconds
        setTimeout(() => {
          this.setState({ showSuccess: false });
        }, 3000);
      })
      .catch(err => {
        console.log(err);
        this.setState({
          errors: {
            ...this.state.errors,
            name: 'Error adding user. Please try again.'
          }
        });
      });
  }

  // Handle enter key
  handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      this.addUser();
    }
  }

  render() {
    const { name, age, users, errors, showSuccess } = this.state;

    return (
      <div className="app-container">
        <div className="content-wrapper">
          <div className="header">
            <h1>User Management</h1>
            <p className="subtitle">Add and manage your users</p>
          </div>

          {/* Success Message */}
          {showSuccess && (
            <div className="success-message">
              <span className="success-icon">✓</span>
              User added successfully!
            </div>
          )}

          {/* Form Card */}
          <div className="form-card">
            <h3>Add New User</h3>
            <div className="form-group">
              <div className="input-wrapper">
                <input
                  type="text"
                  name="name"
                  minLength={3}
                  placeholder="Enter full name"
                  value={name}
                  onChange={this.handleChange}
                  onKeyPress={this.handleKeyPress}
                  className={`form-input ${errors.name ? 'error' : ''}`}
                />
                {errors.name && (
                  <div className="error-message">
                    <span className="error-icon">⚠</span>
                    {errors.name}
                  </div>
                )}
                <div className="input-hint">
                  Minimum 3 characters
                </div>
              </div>

              <div className="input-wrapper">
                <input
                  type="number"
                  name="age"
                  placeholder="Enter age"
                  value={age}
                  onChange={this.handleChange}
                  onKeyPress={this.handleKeyPress}
                  className={`form-input ${errors.age ? 'error' : ''}`}
                />
                {errors.age && (
                  <div className="error-message">
                    <span className="error-icon">⚠</span>
                    {errors.age}
                  </div>
                )}
                <div className="input-hint">
                  Age must be between 1-120
                </div>
              </div>

              <button onClick={this.addUser} className="add-button">
                <span className="button-icon">+</span>
                Add User
              </button>
            </div>
          </div>

          {/* Users List */}
          <div className="users-card">
            <div className="card-header">
              <h3>User List</h3>
              <span className="user-count">{users.length} {users.length === 1 ? 'user' : 'users'}</span>
            </div>
            
            {users.length === 0 ? (
              <div className="empty-state">
                <p>No users yet. Add your first user above!</p>
              </div>
            ) : (
              <div className="users-list">
                {users.map((user, index) => (
                  <div key={user.id} className="user-item" style={{animationDelay: `${index * 0.05}s`}}>
                    <div className="user-avatar">
                      {user.name.charAt(0).toUpperCase()}
                    </div>
                    <div className="user-info">
                      <span className="user-name">{user.name}</span>
                      <span className="user-age">{user.age} years old</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    );
  }
}

export default App;