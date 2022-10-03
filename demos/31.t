% Turing demonstration - enumerated and set types
% Randomly choose Baskin-Robbins 31 flavours of the month

% Enumerate the 31 flavours
type Flavour : enum (
    Pralined_Almonds_n_Cream, Strawberry, Chocolate_Almond, 
    Chocolate_Chip, Rocky_Road, Chocolate_Mint, 
    Jamoca_Almond_Fudge, Butter_Pecan, Pralines_n_Cream, 
    Peanut_Butter_n_Chocolate, Chocolate_Fudge, French_Vanilla, 
    Burgundy_Cherries_Jubilee, Jamoca, German_Chocolate_Cake, 
    Pistachio_Almond_Fudge, New_England_Maple_Nut, Peach_Melba, 
    Orange_Pinapple_Nut, Pecan_Caramel_Fudge, Pirates_Gold, 
    Thats_the_Way_the_Cookie_Crumbles, Cherry_Cheesecake, Peanut_Butter_n_Banana, 
    Chocolate_Mousse_Royale, Chocolate_Chipmunk, Orange_Sherbet, 
    Rainbow_Sherbet, Raspberry_Sherbet, Daiquiri_Ice, 
    Pinapple_Ice)

% Map from flavour numbers to flavours
const IntToFlavour : array 1 .. 31 of Flavour := init (
    Flavour.Pralined_Almonds_n_Cream, Flavour.Strawberry, Flavour.Chocolate_Almond,
    Flavour.Chocolate_Chip, Flavour.Rocky_Road, Flavour.Chocolate_Mint, 
    Flavour.Jamoca_Almond_Fudge, Flavour.Butter_Pecan, Flavour.Pralines_n_Cream, 
    Flavour.Peanut_Butter_n_Chocolate, Flavour.Chocolate_Fudge, Flavour.French_Vanilla,
    Flavour.Burgundy_Cherries_Jubilee, Flavour.Jamoca, Flavour.German_Chocolate_Cake, 
    Flavour.Pistachio_Almond_Fudge, Flavour.New_England_Maple_Nut, Flavour.Peach_Melba, 
    Flavour.Orange_Pinapple_Nut, Flavour.Pecan_Caramel_Fudge, Flavour.Pirates_Gold,
    Flavour.Thats_the_Way_the_Cookie_Crumbles, Flavour.Cherry_Cheesecake, Flavour.Peanut_Butter_n_Banana, 
    Flavour.Chocolate_Mousse_Royale, Flavour.Chocolate_Chipmunk, Flavour.Orange_Sherbet,
    Flavour.Rainbow_Sherbet, Flavour.Raspberry_Sherbet, Flavour.Daiquiri_Ice, 
    Flavour.Pinapple_Ice)

% English names of the flavours
const * FlavourName : array Flavour of string := init (
    "Pralined Almonds'n'Cream", "Strawberry", "Chocolate Almond",
    "Chocolate Chip", "Rocky Road", "Chocolate Mint", 
    "Jamoca Almond Fudge", "Butter Pecan", "Pralines'n'Cream", 
    "Peanut Butter'n'Chocolate", "Chocolate Fudge", "French Vanilla",
    "Burgundy Cherries Jubilee", "Jamoca", "German Chocolate Cake", 
    "Pistachio Almond Fudge", "New England Maple Nut", "Peach Melba", 
    "Orange Pinapple Nut", "Pecan Caramel Fudge", "Pirates Gold",
    "Thats the Way the Cookie Crumbles", "Cherry Cheesecake", "Peanut Butter'n'Banana",
    "Chocolate Mousse Royale", "Chocolate Chipmunk", "Orange Sherbet",
    "Rainbow Sherbet", "Raspberry Sherbet", "Daiquiri Ice",
    "Pinapple Ice")

% Sets of similar flavours
type ThirtyWonderful : set of Flavour

const Chocolates := ThirtyWonderful (
    Flavour.Chocolate_Almond, Flavour.Chocolate_Chip, Flavour.Chocolate_Mint,
    Flavour.Peanut_Butter_n_Chocolate, Flavour.Chocolate_Fudge, Flavour.German_Chocolate_Cake,
    Flavour.Chocolate_Mousse_Royale, Flavour.Chocolate_Chipmunk)

const Sherbets := ThirtyWonderful (
    Flavour.Orange_Sherbet, Flavour.Rainbow_Sherbet, Flavour.Raspberry_Sherbet,
    Flavour.Daiquiri_Ice, Flavour.Pinapple_Ice) 

const Nuts := ThirtyWonderful (
    Flavour.Peanut_Butter_n_Chocolate, Flavour.Peanut_Butter_n_Banana, Flavour.Pralined_Almonds_n_Cream,
    Flavour.Chocolate_Almond, Flavour.Jamoca_Almond_Fudge, Flavour.Pistachio_Almond_Fudge,
    Flavour.Butter_Pecan, Flavour.Pecan_Caramel_Fudge, Flavour.Pralines_n_Cream)

const Creams := ThirtyWonderful (
    Flavour.Pralined_Almonds_n_Cream, Flavour.Butter_Pecan, Flavour.Pralines_n_Cream,
    Flavour.French_Vanilla, Flavour.Chocolate_Mousse_Royale)

const Crunches := ThirtyWonderful (
    Flavour.Pralined_Almonds_n_Cream, Flavour.Chocolate_Almond, Flavour.Chocolate_Chip,
    Flavour.Rocky_Road, Flavour.Jamoca_Almond_Fudge, Flavour.Butter_Pecan,
    Flavour.Pralines_n_Cream, Flavour.Pistachio_Almond_Fudge, Flavour.New_England_Maple_Nut,
    Flavour.Orange_Pinapple_Nut, Flavour.Pecan_Caramel_Fudge, Flavour.Thats_the_Way_the_Cookie_Crumbles,
    Flavour.Chocolate_Chipmunk)

const Fruits := ThirtyWonderful (
    Flavour.Strawberry, Flavour.Burgundy_Cherries_Jubilee, Flavour.Peach_Melba,
    Flavour.Orange_Pinapple_Nut, Flavour.Cherry_Cheesecake, Flavour.Peanut_Butter_n_Banana,
    Flavour.Orange_Sherbet, Flavour.Rainbow_Sherbet, Flavour.Raspberry_Sherbet,
    Flavour.Daiquiri_Ice, Flavour.Pinapple_Ice) 

const NuttyChocolates := Nuts * Chocolates
assert (NuttyChocolates <= Nuts and NuttyChocolates <= Chocolates)

const NuttySherbets := Nuts * Sherbets
assert (NuttySherbets /* is silly */ = ThirtyWonderful ())

const NutsAndSherbets := Nuts + Sherbets
assert (Nuts <= NutsAndSherbets)
assert (Flavour.Butter_Pecan in NutsAndSherbets)

% Names of the months
const MonthName : array 1 .. 12 of string := init (
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December")


% Main program - for each month of the year, choose and describe the flavour of the month
var yearSoFar := ThirtyWonderful ()
var flavourOfTheMonth : Flavour

% Randomly
randomize

for month : 1 .. 12
    % Choose a new random flavour we haven't yet chosen this year
    loop
	var irand : int
	randint (irand, 1, 31)
	flavourOfTheMonth := IntToFlavour (irand)
	exit when flavourOfTheMonth not in yearSoFar
    end loop

    % Got one!
    put skip, "The flavour of the month for ", MonthName (month), " is ", FlavourName (flavourOfTheMonth), "."

    % Now describe it
    put "This is a " ..

    % Some months are delicious, some are nice
    case month mod 3 of
	label 0 :
	    put "delicious " ..
	label 1 :
	    put "scrumptious " ..
	label 2 :
	    put "nice " ..
    end case

    % Desribe the attributes of the flavour
    if flavourOfTheMonth in Nuts then
	put "nutty " ..
    end if

    if flavourOfTheMonth in Fruits then
	put "fruity " ..
    end if

    if flavourOfTheMonth in Crunches then
	put "crunchy " ..
    end if

    if flavourOfTheMonth in Chocolates then
	put "chocolatey " ..
    end if

    if flavourOfTheMonth in Sherbets then
	put "sherbet" ..
    else
	put "ice cream" ..
    end if

    if flavourOfTheMonth in Creams then
	put " with a smooth creamy texture."
    else
	put "."
    end if

    % Remember we've already chosen this one
    yearSoFar := yearSoFar + ThirtyWonderful (flavourOfTheMonth)

end for
