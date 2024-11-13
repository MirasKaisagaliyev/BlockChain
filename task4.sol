// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {

    enum Choice { None, Rock, Paper, Scissors }
    enum GameResult { Ongoing, PlayerOneWins, PlayerTwoWins, Draw }

    struct Game {
        address playerOne;
        address playerTwo;
        Choice playerOneChoice;
        Choice playerTwoChoice;
        GameResult result;
    }

    Game[] public games;
    
    function play(Choice _choice) public returns (uint) {
        address player = msg.sender;

        // Find a game that the player is participating in
        for (uint i = 0; i < games.length; i++) {
            Game storage game = games[i];

            // If playerOne hasn't played yet
            if (game.playerOne == player && game.playerOneChoice == Choice.None) {
                game.playerOneChoice = _choice;
                if (game.playerTwoChoice != Choice.None) {
                    // Both players have played, determine result
                    game.result = determineWinner(game.playerOneChoice, game.playerTwoChoice);
                }
                return i;
            }

            // If playerTwo hasn't played yet
            if (game.playerTwo == player && game.playerTwoChoice == Choice.None) {
                game.playerTwoChoice = _choice;
                if (game.playerOneChoice != Choice.None) {
                    // Both players have played, determine result
                    game.result = determineWinner(game.playerOneChoice, game.playerTwoChoice);
                }
                return i;
            }
        }

        // If no ongoing game found, create a new game
        games.push(Game(player, address(0), _choice, Choice.None, GameResult.Ongoing));
        return games.length - 1;
    }

    function determineWinner(Choice playerOneChoice, Choice playerTwoChoice) public pure returns (GameResult) {
        if (playerOneChoice == playerTwoChoice) return GameResult.Draw;
        if (playerOneChoice == Choice.Rock && playerTwoChoice == Choice.Scissors) return GameResult.PlayerOneWins;
        if (playerOneChoice == Choice.Scissors && playerTwoChoice == Choice.Paper) return GameResult.PlayerOneWins;
        if (playerOneChoice == Choice.Paper && playerTwoChoice == Choice.Rock) return GameResult.PlayerOneWins;
        return GameResult.PlayerTwoWins;
    }

    function getGameHistory() public view returns (Game[] memory) {
        return games;
    }
}
