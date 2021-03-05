import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

// Square is no longer a component class, it is a component function. no state, no props of its own
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
    if (calculateWinner(squares) || squares[i]) {
      return;
    }
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
    const winner = calculateWinner(this.state.squares);
    let status;
    if(winner) {
      status = 'Winner: ' + winner;
    } else {
      status = 'Next player: ' + (this.state.xIsNext ? 'X' : 'O');
    }


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

function calculateWinner(squares) {
  // winning combinations
  const lines = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6],
  ];
  for (let i = 0; i < lines.length; i++) {
    const [a, b, c] = lines[i];
    if(squares[a] && squares[a] === squares[b] && squares[a] === sqaures[c]) {
      return squares[a]
    }
  }
  return null;
}
