import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

function Square(props) {
  return (
    <button
      className = 'square'
      onClick = {props.onClick} //onClick property is a function!
    >
      {props.value}
    </button>
  );
}

class Board extends React.Component {
  // constructor for shared state of all squares
  constructor(props) {
    super(props);
    this.state = {
      squares: Array(9).fill(null),
      xIsNext: true,
    };
  }

   handleClick(i) {
    const squares = this.state.squares.slice(); // create  copy of state - immutability - instead of mutating state
    squares[i] = this.state.xIsNext ? 'X' : 'O';
    this.setState({
      squares: squares,
      xIsNext: !this.state.xIsNext,
    });
  }

  // function to render the Square react component
  renderSquare(i) {
    //pass a prop called "value" to Square Component
    return (
      <Square
        value = { this.state.squares[i] }
        onClick = {() => this.handleClick(i)}
      />
    );
  }



  // render some HTML with 9 Squares
  render() {
    const status = 'Next player: ' + (this.state.xIsNext ? 'X' : 'O');

    return (
      <div>
        <div className = 'status'>{status}</div>
        <div className = 'board-row'>
          {this.renderSquare(0)}
          {this.renderSquare(1)}
          {this.renderSquare(2)}
        </div>
        <div className = 'board-row'>
          {this.renderSquare(3)}
          {this.renderSquare(4)}
          {this.renderSquare(5)}
        </div>
        <div className = 'board-row'>
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
        </div>
      </div>
    );
  }
}

class Game extends React.Component {
  // Render the Board react component and some additional divs
  render() {
    return (
      <div className = 'game'>
        <div className = 'game-board'>
          <Board />
        </div>
        <div className = 'game-info'>
          <div>{/* status */}</div>
          <ol>{/* TO DO */}</ol>
        </div>
      </div>
    );
  }
}


// ========================================

ReactDOM.render(
  <Game />,
  document.getElementById('root')
);
