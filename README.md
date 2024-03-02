[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/BAJPqr99)

# CS3217 Problem Set 4

**Name:** Ho Jun Hao

**Matric No:** A0234730M

## Tips

1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

    In addition, keep in mind that, ultimately, this tool is only a guideline;
    some exceptions may be made as long as code quality is not compromised.

3. Do not burn out. Have fun!

## Dev Guide

Read the development guide [here](./docs/DEVELOPER_GUIDE.md).

## Rules of the Game

The game is simple. The goal is to destroy pegs (circular objects) in the game within the allocated time and cannonballs. You destroy pegs by firing cannonballs from you cannon at various objects in the game. Depending on what the object is your cannonball hit, the game may react differently (e.g. gain sepcial powers, destroy object, bounce off object). Some objects may be harder to destroy and need multiple hits.

Your cannonball exits the gameboard by falling down and out of the gameboard. After which if you have balls remaining, you can fire your cannonball again.

Every peg that you hit will be lit up and once you exit the lit pegs will be destroyed. There exist pegs that may need multiple hits and thus will not disappear despite being lit and ball exiting.

On occasion, your cannonball might get stuck on a peg. In this scenario, wait for a while and the peg will disappear from below the cannonball.

### Main Menu

This is the first screen the user would see when they first open the application.

Here the user has 2 options

1. Play a game of peggle by pressing the `Play` button
2. Design their own peggle level by pressing the `Level Designer` button

### Level Selector

If the user chooses option 1 in the Main Menu, they will be led to the Level Selector screen, where they can choose from a list of levels to play. There are 3 preloaded levels by default. Any other levels that the user has designed would also appear in the list after saving in the Level Designer. To play a level just tap on it. This will proceed to start the game.

If the user changes his mind and decide to go back, he can click the `<` circle button located at the top-left of the screen. This will bring him from the Level Selector back to the Main Menu.

### Cannon Direction

The user has 2 ways of using the cannon

1. They can tap the screen which will instantly rotate and fire the cannon in the direction they tapped
2. They can drag their finger on the screen to rotate the cannon and fire when they release their finger

> [!NOTE]
>
> -   Cannon can only be fired if you tapped within the gameboard region (i.e. the background)
> -   It will not fire if you tap outside the gameboard (e.g. the score board)
> -   You can only fire downwards or sideways, it is impossible to fire upwards
> -   You cannot fire your cannon if there already exists a cannonball active in the game. Wait until the cannonball exits the gameboard before firing again

### Types of game objects

`Cannon`

-   Located at the top-middle of the screen
-   Cannonball is being fired from the cannon
-   No physical body (i.e. has no physical effect on the cannonball)

`Cannonball`

-   a small grey ball that bounces off various surfaces

`Walls and ceilings`

-   When cannonball hits a wall or ceiling, it will lose a bit of speed and bounces off the surface

`Normal Peg`

-   Blue circular objects
-   No special effects
-   Immovable
-   Cannonball loses significant speed and bounces off surface
-   Lights up after 1 hit

`Goal Peg`

-   Orange circular objects
-   These are the pegs you want to destroy to win the game
-   Immovable
-   Cannonball loses significant speed and bounces off surface
-   Lights up after 1 hit

`Spooky Peg`

-   Purple circular objects
-   Cannonball will turn purple too, and after exiting, cannonball will reappear above the map without reducing cannonballs remaining
-   Immovable
-   Cannonball loses significant speed and bounces off surface
-   Lights up after 1 hit

`Kaboom Peg`

-   Green circlular objects
-   Cannonball will gain speed and be blasted away in opposite direction of explosion.
-   Will destroy surrounding pegs too
-   Immovable
-   Destroyed upon impact
-   Will activate other pegs and destroy them if within the explosion radius

`Health Peg`

-   Yellow circular objects
-   Takes 3 hits before being destroyed on exit or destroyed on 4th hit
    -   No hit: yellow
    -   1 hit: yellow glow
    -   2 hit: pink glow
    -   3 hit: red
-   Immovable
-   Cannonball loses significant speed and bounces off surface

`Stubborn Peg`

-   Grey circular objects
-   Unable to be destroyed by cannonball
-   Not moving initally, but upon impact, some energy will be transferred from the impacter to the stubborn peg causing it to start moving around the gameboard
-   Stubborn pegs can also hit other stubborn pegs causing them to move
-   Stubborn pegs may collide with other game objects but will not cause them to be activated
-   Cannonball loses significant speed and bounces off surface
-   Only way for stubborn peg to be destroyed is for it to exit the gameboard from the bottom
-   Stubborn peg will bounce off the bucket (including the top)
-   Conservation of momenetum is followed, bigger objects would move slower after colliding compared to smaller lighter objects

`Block`

-   Brown rectangular objects
-   Unable to be destroyed by cannonball
-   Comes if various length and widths
-   May be rotated
-   Cannonball loses some speed and bounces off it

`Bucket`

-   A bucket that moves left and right at the bottom of the gameboard

> [!NOTE]
>
> -   If cannonball enters the bucket from the top, user will gain score (500 points) and an extra cannonball
> -   If cannonball hits bucket from the side (left and right), it will bounce off it.

### Win and Lose Conditions

-   Win conditions
    -   Time has not run out
    -   All Goal Pegs (i.e. orange pegs) have been destroyed
-   Lose conditions
    -   Time has ran out
    -   No more balls remaining
    -   There exists Goal pegs on the gameboard

Upon either of this condition, a pop up will appear and the user and click on the `OK` button to return the Main menu.

If at any moment the use doesn't want to play the game anymore, he can click on the `<` buttom at the bottom-left of the Game screen

## Level Designer Additional Features

Continuing from the main menu, if the user decide to choose option 2 and click on `Level Designer` where they can design their own level.

The user first decides what type of peg/block he want by tapping on the corresponding buttons at the bottom of the screen. Then tap on the gameboard to place the object at that location.

> [!NOTE]
>
> -   You can only place pegs/blocks inside the gameboard region
> -   The object must not overlap with other objects

The user can move the object around by dragging said object

To remove the object from the gameboad, simply long-press and release the object. Alternatively, you can tap the delete button (i.e. circular button with arrow), then tap on the object (remember to tap on the delete button again once you are done to disable it).

### Peg Rotation and Resizing

The player is allowed to rotate and resize the peg.

This is done so my first tapping on peg you want to modify. A red ring should appear around it. The sliders located at the bottom of the screen should become enable and you are free to adjust the diameter and rotation by sliding the sliders.

The maximum you can rotate is 360 degrees and the maximum you can set the diameter is 4 times the default size.

> [!NOTE]
>
> -   All modifications must not cause the object to overlap with other objects or exit the gameboard area
> -   Any modifications that do so will not be allowed by the game (i.e. slider will not slide pass a certain point)

### Block Rotation and Resizing

The player is also allowed to rotate and resize the blocks.

Similarly to the pegs, on selection, a red rectangle will appear around selected block and sliders will become enabled below.

Same restriction of no overlaps with other objects and no objects outside of gameboard area apply.

> [!NOTE]
>
> -   If you slide the rotation slider and it reaches an angle that overlaps with an object, the block will remain at that angle
> -   however if you continue sliding and if it reaches a larger/smaller angle in which the block no longer overlaps, the rotation will be allowed and the block will rotate as such

## Bells and Whistles

1. Scoring system

-   I used the multipler systems based on [this](https://cs3217.github.io/cs3217-docs/problem-sets/problem-set-4/#scoring-system).
-   Base points differ however
    -   Normal Peg: 10
    -   Goal Peg: 100
    -   Kaboom: 50
    -   Spooky: 0
    -   HealthPeg: 30
    -   StubbornPeg: 20
-   Sounds and music throughtout the game
-   Displaying number of pegs remaining in the game
-   Displaying the number pegs placed in the level designer
-   Timer that results in gameover when it ends

## Tests

Read the testing plan [here](./docs/TEST_PLAN.md).

## Written Answers

### Reflecting on your Design

> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
>
> -   do you think you have designed your code in the previous problem sets well
>     enough?
> -   is there any technical debt that you need to clean in this problem set?
> -   if you were to redo the entire application, is there anything you would
>     have done differently?

Overall I felt like I learnt alot over these 6 weeks doing the 3 problem sets.

My architecture was that of MVVM, something that i felt not many people did. There were definitely some challenges that I faced as a result, but overall it was not too bad.

I managed to learnt and incorporate design patterns such as delegation and double dispatch.

I felt that my code design was alright. There is definitely room for improvement particularly with respect to trying to following OCP. When doing PS2 and PS3 I tried as much as possible to make it modular, but there are definitely still some areas that are coupled. In terms of technical debt, it was not as bad as I thought due to the reason above, but i still did spend sometime trying to incorporate both PS2 and PS3 together as things were not as decoupled as I hoped.

If had to redo my entire project I would try to make physics engine and game engine more decoupled. I would perhaps like to also try out MVC and using storyboard instead of SwiftUI.
