# api.m2ind.tk

An API to play to mastermind (numeric version) from different places (web, console, mobile-app, etc)


## Usage

You can find in the `doc` folder ready-to-go postman collections in order to start playing and knowing how works the API


## Start a game

`POST http://api.m2ind.tk/games`

#### parameters:

| name  |values|default|opt|definition                            |
|:-----:|:----:|:-----:|:-:|:-------------------------------------|
|num_pos| 4..9 |   5   |Yes|digits that going to have the sequence|

#### response

``` 
{
  "token": "the-token-that-the-server-creates",
  "num_pos": 5,
  "repeated": false,
  "created": "the-date-of-creation-of-the-game"
}
```

Important: token is used to play turns and set the username in the score if user wins

## Play turn

`POST http://api.m2ind.tk/games_tries`

#### parameters:

| name  |values|opt|definition                            |
|:-----:|:----:|:-:|:-------------------------------------|
|game_token|  |No|token obtained when started a new game|
|try|n digits|No|the guess that the user wants to check.   __restrictions__: non repeated digits and the number of them according to num_pos passed to creation game endpoint|

#### response

```
{
  "try": "123456",
  "success": true,
  "result": "0000",
  "you_win": false,
  "score": null,
  "hint": null,
  "try_num": 1
}
```

`result`: every single zero `0` represent a digit that exists in the sequence but is not well positioned,
meanwhile one `1` means well positioned, the order of ones and zeros don't match with the guess tried byt the user

`hint`: has value every time user gets a well positioned digit (meaning a one `1` in the result), it's up to the frontend to show this hing to the user

#### response if user wins

```
{
  "try": "123456",
  "success": true,
  "result": "11111",
  "you_win": true,
  "score": 89078,
  "hint": "1",
  "try_num": 6
}
```


Important: save the `score` ID returned in order to change later the user name


## Add username to score of finished (and won) game

`PUT http://api.m2ind.tk/scores/{score_id}`

#### parameters


| name  |values|opt|definition                            |
|:-----:|:----:|:-:|:-------------------------------------|
|game_token|  |No|token obtained when started a new game|
|user|string|No|the username that won the game|


#### good response

```
{
  "success": true
}
```

#### bad response

```
{
  "success": false,
  "error": "user is mandatory"
}
```

## Get the top-10 high-scores

`GET http://api.m2ind.tk/scores`

#### response

```
[
  {
    "id": 1,
    "game_token": "EJ8wqyPofhZR4j9ZTifB7TvX",
    "user": "jlaso",
    "tries": 4,
    "seconds": 419,
    "num_pos": 5,
    "repeated": false,
    "created_at": "2016-12-28T12:44:25.245Z",
    "updated_at": "2016-12-28T12:45:08.480Z"
  },
  { ... etc ... }
]
```

## Ask for a Hint

`POST http://api.m2ind.tk/game_hint`

params: 

game_token

#### response

```
{
}
```