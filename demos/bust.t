% Turing demonstration program

% Blackjack Simulation 
% J.R. Cordy, Computer Systems Research Group, 
% University of Toronto, July 1975             

% For instructions on use, run once with no input

% hands of players                             
const maxcardsinhand := 7
type handarray: array 1 .. maxcardsinhand of int
var playershand, dealershand : handarray
var playerscards, dealerscards : int

% game counts for each shuffle                 
var gamesplayed, gamesplayerwon, gamesdealerwon : int

% player's hand values                         
var dealerscount, playerscount : int

% flags to indicate player's status            
var dealerstops, playerstops : boolean

% player parameters                            
var playersname : string

% player's count limit for naive strategy      
var joenaivesguts : int


% deck to deal cards from                      
module carddeck 
    export shuffle, dealcard, cardsleft

    var deck : array 1 .. 52 of int
    var nextcard : int

    proc shuffle 
	% puts a new shuffled deck of cards in the array "deck".  
	% cards are coded as 1 to 13, 1 being ace,     
	% 2-10 as they are, and 11-13 being j,q,k respectively. 

	var cardcount : array 1 .. 13 of int

	for c : 1 .. 13
	    cardcount (c) := 0
	end for

	for ncards : 1 .. 52
	    var card : int
	    randint (card, 1, 13)
	    loop
		exit when cardcount (card) not= 4
		randint (card, 1, 13)
	    end loop

	    deck (ncards) := card
	    cardcount (card) += 1
	end for

	nextcard := 0
    end shuffle

    proc dealcard (var card : int)
	nextcard += 1
	card := deck (nextcard)
    end dealcard

    proc cardsleft (var number : int)
	number := 52 - nextcard + 1
    end cardsleft

end carddeck


module namesofcards 
    export handimage

    % alphanumeric card names                      
    var cardnames : array 1 .. 13 of string := 
        init ( "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K")

    proc handimage (ncards : int, var hand : handarray, var image: string)
	% returns a character string image of the hand 
	image := ""

	for i : 1 .. ncards
	    image += " " + cardnames (hand (i))
	end for
    end handimage
end namesofcards


proc somebodyplays (var r : boolean)
    % returns true and initializes a new shuffle if there is another shuffle to be played 
    %    (i.e. if another player name is input), 
    % otherwise returns false 

    gamesplayed := 0
    gamesplayerwon := 0
    gamesdealerwon := 0

    put "" 
    put "New shuffle." 
    put ""

    put "Enter player name (E for E.O.Thorp, your name for you, q to quit): " ..
    get playersname

    if playersname = "E" or playersname = "e" then
	playersname := "E.O.Thorp"
    end if

    if playersname = "q" then
	r := false
    else 
	if playersname not= "E.O.Thorp" then
	    put "What does he/she stand on? "
	    get joenaivesguts
	    loop
		exit when (joenaivesguts > 0) and (joenaivesguts <= 20)
		put "(1..20): " ..
		get joenaivesguts
	    end loop
	end if

	if playersname = "E.O.Thorp" then
	    put ""
	    put "E.O.Thorp plays this time." 
	else
	    put ""
	    put "Next player is " + playersname + "." 
	    put "He stops at ", joenaivesguts, "." 

	    if joenaivesguts < 15 then
		put "(What a hamburger!)"
	    else
		put "Good luck, " + playersname + "." 
	    end if
	end if

	r := true
    end if
end somebodyplays


proc playing (var r : boolean)
    % returns true if (enough cards left for        
    % another game, otherwise prints a shuffle     
    % summary and returns false.                   

    var numcards: int
    carddeck.cardsleft (numcards)

    if numcards > 10 then
	put ""
	put "New game." 
	gamesplayed += 1
	r := true
    else
	put ""
	put "Too few cards left for another game." 
	put "Of ", gamesplayed, " games, ", playersname,
	    " won ", gamesplayerwon, ", dealer won ", gamesdealerwon, "."

	if gamesdealerwon > gamesplayerwon then
	    put "House cleans up on " + playersname + " this time." 
	elsif gamesplayerwon > gamesdealerwon then
	    if playersname = "E.O.Thorp" then
		put "E.O.Thorp does it again." 
	    else
		put playersname + " must have doctored the shuffle." 
	    end if
	else
	    put "Even shuffle." 
	end if

	r := false
    end if
end playing


proc playertakesacard 
    % player's hand gets another card from the top of the deck.                                 
    playerscards += 1
    carddeck.dealcard (playershand (playerscards))
end playertakesacard


proc dealertakesacard 
    % dealer's hand gets another card from the top 
    % of the deck.                                 
    dealerscards += 1
    carddeck.dealcard (dealershand (dealerscards))
end dealertakesacard


proc deal
    % initializes for a new hand and performs initial deal.                                
    % player and dealer each get two cards.        
    var image: string

    playerstops := false
    dealerstops := false
    playerscards := 0
    dealerscards := 0

    % Two cards each to begin
    playertakesacard 
    dealertakesacard 
    playertakesacard 
    dealertakesacard 

    % Show the initial hands
    namesofcards.handimage (playerscards, playershand, image)
    put "The initial deal gives ", playersname, " :", image 
    namesofcards.handimage (dealerscards, dealershand, image)
    put "  and the dealer :", image, "." 
end deal


proc evaluate (ncards : int, var hand : handarray, var softhand : boolean, var value : int)
    % evaluates the best count for the hand, and   
    % sets "softhand" to true if one or more aces are counted as 11.                           

    var nacescounted11 := 0
    value := 0

    for i : 1 .. ncards

	case hand (i) of
	  label 1:
	    % A 
	    value += 11
	    nacescounted11 += 1
	  label 2, 3, 4, 5, 6, 7, 8, 9, 10:
	    % 2-10 
	    value += hand (i)
	  label:
	    % J,Q,K 
	    value += 10
	end case
    end for

    loop 
	exit when value <= 21 or nacescounted11 = 0
	value -= 10
	nacescounted11 -= 1
    end loop

    softhand := nacescounted11 > 0

end evaluate


proc dealer 
    % simulates play of dealer.                    
    % dealer plays the standard strategy of standing with 17 or better.                  
    % when dealer decides to stop, prints hand summary.                                     

    var softhand : boolean
    evaluate (dealerscards, dealershand, softhand, dealerscount)

    if dealerscount > 21 then
	put "Dealer goes bust." 
	dealerstops := true
	gamesplayerwon += 1
    elsif dealerscount = 21 then
	put "Dealer calls blackjack." 
	dealerstops := true
	gamesdealerwon += 1
    else
	if dealerscount < 17 then
	    dealertakesacard 
	else
	    dealerstops := true
	end if

	if dealerstops then
	    put "Dealer stands with ", dealerscount, "." 

	    if dealerscount > playerscount then
		put "House wins." 
		gamesdealerwon +=  1
	    elsif dealerscount < playerscount then
		put playersname + " wins." 
		gamesplayerwon += 1
	    else
		put "Tie game." 
	    end if
	else
            var image : string
	    namesofcards.handimage (dealerscards, dealershand, image)
	    put "Dealer takes a card and now has ", image, "." 
	end if
    end if
end dealer


module players 
    export player

    proc playerjoenaive 
	% simulates the naive player strategy          

	if playerscount < joenaivesguts then
	    playertakesacard 
	else
	    playerstops := true
	end if
    end playerjoenaive

    proc playerthorp (softhand : boolean)
	% simulates a simplified version of the player strategy described by E.O.Thorp in his book  
	% "Beat the Dealer" (Vintage books, 1966) pp. 20,21.                                   

	var dealershows := dealershand (1)

	if softhand then
	    % soft hand strategy 
	    if dealershows > 8 then
		% 9 or 10 
		playerstops := playerscount > 18
	    else
		% 2-8,A 
		playerstops := playerscount > 17
	    end if
	else
	    % hard hand strategy 
	    if dealershows > 1 and dealershows < 4 then
		% 2 or 3 
		playerstops := playerscount > 12
	    elsif dealershows > 3 and dealershows < 7 then
		% 4 to 6 
		playerstops := playerscount > 11
	    else
		% 7 to 10,A 
		playerstops := playerscount > 16
	    end if
	end if

	if not playerstops then
	    playertakesacard 
	end if
    end playerthorp

    proc player 
	% simulates play of player                     
	% player plays either the naive strategy or, 
	% if playersname = "E.O.Thorp", E.O.Thorp's strategy.                                    

	var softhand : boolean
	evaluate (playerscards, playershand, softhand, playerscount)

	if playerscount = 21 then
	    put playersname + " calls blackjack." 
	    playerstops := true
	    dealerstops := true
	    gamesplayerwon += 1
	elsif playerscount > 21 then
	    put playersname + " goes bust." 
	    playerstops := true
	    dealerstops := true
	    gamesdealerwon += 1
	else
	    if playersname = "E.O.Thorp" then
		playerthorp (softhand)
	    else
		playerjoenaive 
	    end if

	    if playerstops then
		put playersname, " stands with ", playerscount, "." 
	    else
		var image : string
		namesofcards.handimage (playerscards, playershand, image)
		put playersname, " takes a card and now has ", image, "." 
	    end if
	end if
    end player

end players


% main program 

% continue flag
var yes : boolean

% print program explanation                    
put "This program simulates the game of blackjack." 
put ""
put "The dealer plays the compulsory strategy of standing on 17 or better." 
put ""
put "The player plays either" 
put "  (1) The standard naive strategy of standing on n or better, or" 
put "  (2) A simplified version of the strategy described by  E.O.Thorp in his book "
put "      'Beat the Dealer' (Vintage Books, 1966 pp. 20-21.)" 
put ""
put "Input :" 
put "  For each shuffle, a player name (character string of <= 20 characters)"
put "  and if the player name specified is not 'E.O.Thorp', the count (n)"
put "  on which the player stands." 
put ""
put "If the player name specified is 'E.O.Thorp', the player strategy used will be Thorp's."
put ""
put "Otherwise, the player will use the standard stop on count > n strategy." 
put ""
put "The program will simulate one complete shuffle of play for each player." 

% commence the games!
somebodyplays (yes)

loop
    exit when not yes

    carddeck.shuffle 
    playing (yes)

    loop
	exit when not yes

	deal 

	loop 
	    exit when playerstops
	    players.player 
	end loop

	loop 
	    exit when dealerstops
	    dealer 
	end loop

	playing (yes)
    end loop

    somebodyplays (yes)

end loop
