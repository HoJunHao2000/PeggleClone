# Tests

## Unit Tests

Unit tests were done for:

All models

-   BallGameObject
-   PegGameObject
-   GameEngine
-   PhysicsObject
-   CircularPhysicsObject
-   LinePhysicsObject
-   PhysicsEngine
-   Intersector
-   CollisionHandler

> [!NOTE]
>
> -   
> -   No test done for view model as most of the functions are simply wrappers around GameEngine functions

View all unit tests [here](../PeggleClone/PeggleCloneTests/).

## Check Representations

Check representations functions were implemented for

`GameEngine`

-   The total number of pegs in the `pegs` array must equal the number of pegs in the `gameboard.pegs` array.
-   The number of removed pegs must be at least 0 and not more than the total number of pegs.
-   The score must be at least 0 and equal to the number of removed pegs.
-   The number of balls remaining must be at least 0 and not more than the initial number of balls.
-   If the ball is not `nil`, the number of balls remaining must be less than the initial number of balls.
-   If the ball is not `nil`, it must have a corresponding physics object in the `physicsEngine`.
-   If the ball is not `nil`, its position must be within the game boundary.
-   All pegs in the `pegs` array that are not in `removedPegs` must have a corresponding physics object in the `physicsEngine`.
-   All pegs in the `removedPegs` set must have been removed from the `physicsEngine`.

`PhysicsEngine`

-   The array of PhysicsObject instances must not contain any duplicate objects.

`PhysicsObject`

-   The hit count must be non-negative.
-   The mass must be non-negative.
-   The elasticity must be non-negative.

> [!NOTE]
>
> Check representations not implemented for
>
> -   BallGameObject
> -   PegGameObject
> -   LinePhysicsObject
> -   CircularPhysicsObject
> -   CollisionHanlder
> -   Intersector
>
> These models are simple with compulsory fields during initialisation and don't have much to check

## UI Tests

-   Peggle game should start looking like this below.

![Start](./images/ps3_start.png)

-   Peggle game should have the following views

![UIView](./images/ps3_UIView.png)

> [!NOTE]
> BallView will not be visible until game starts and ball is shot

## Integration Tests

-   PeggleClone

    -   When tapping gameboard

        -   If the tapped position is outside the gameboard

            -   Nothing happens

        -   If the tapped position inside the gameboard

            -   Cannon should immediately rotate to the point of contact
            -   Cannon fires ball in direction of contact
            -   Balls left decrement by 1

    -   When dragging finger around gameboard

        -   If the finger position is outside the gameboard

            -   Nothing happens

        -   If the finger position is in the gameboard

            -   Cannon should swivel and aim towards direction of finger
            -   On release, cannon fire ball in direction of contact
            -   Balls left decrement by 1

    -   To test that ball always remain in the gameboard

        -   Fire at side of board at locations indicated in red.
        -   This is to test that balls will remain in gameboard despite hitting the sides of the gameboard.
            ![side test](./images/ps3_sideboardertest.png)
            > [!NOTE]
            > - You may need to aim and adjust a little to hit the targetted spots
            > - Pegs may be in the way of target, hence you might need to clear some of the pegs first
            > - If you run out of balls, reset the game and try on the remaining untested spots
        -   Fire at the specific peg indicated below
            ![top test](./images/ps3_topbordertest.png)
        -   In both cases, ball should bounce off the boundaries downwards and not phase through the boundary

    -   To test that ball disappears after leaving gameboard

        -   Fire ball toward the bottom of gameboard (bypassing pegs)
        -   Ball should disappear after hitting bottom of gameboard

    -   To test that hit pegs are lit up

        -   Fire ball into the "ring of pegs"
        -   Check that pegs that come in contact with the ball light up
        -   Pegs that don't come in contact should not light up
        -   It should look something like this
            ![lit pegs](./images/ps3_litpegs.png)

    -   To test that pegs can be removed prematurely

        -   Fire ball into the "ring of pegs"
        -   Ball should get trapped inside the "ring of pegs"
        -   After waiting a while, pegs below the ball should fade and your points should increase
        -   It should look something like this
            ![premature](./images/ps3_premature.png)

    -   To test that lit pegs are removed from game after ball exit

        -   Fire the ball into some pegs to light them up
        -   Once ball leaves, lit pegs should fade away
        -   Score should increase according to the number of pegs faded
        -   It should look something like this
            ![exit](./images/ps3_exit.png)

    -   To test gameover

        -   Gameover occurs if
            1. all pegs have faded or
            2. there are no balls remaining
        -   To test (1)
            -   Fire balls at peg until no pegs remain
            -   There should be more than enough balls
            -   If you run out of balls, restart the game application
        -   To test (2)
            -   Fire all balls into the bottom of gameboard (bypassing pegs)
        -   In both cases the outcome should be a pop up looking like this
            ![gameover](./images/ps3_gameover.png)
        -   Clicking the replay button should restart the game to the beginning state

    -   To test multiobject collision (i.e. ball hits 2 object at the same time)

        -   Fire ball into the "ring of pegs"
        -   Observe how the ball interacts with the pegs
        -   The ball should "settle" on the bottom middle 2 pegs of "ring" and stop moving (this may take a couple tries depending on how ball moves)
            ![middleball](./images/ps3_middleball.png)
        -   There should be any overlaps between the ball and 2 pegs
        -   This test is to ensure that collision handling even when there is 2 overlaps with ball is handled smoothly.

    -   To test ball movement

        -   Fire the ball at the pegs
        -   Observe ball motion
        -   The ball should bounce off in the direction that mirrors the incoming direction about the perpendicular at the point of contact.
        -   Ball should slow down after hitting either the boundary or pegs
        -   Balls that ascend after striking pegs should eventually descend in a parabolic trajectory, decelerating as they ascend and accelerating as they descend, provided they encounter no other obstacles.
        -   There should be no polygonal movements

Do note when testing that:

1. There is no persistent storage yet, thus game only has 1 preloaded level
2. Gameboard and Peg are imported from PS2 and assumed to be ok, thus no testing will be done for these 2 (PS4 will include the tests from PS2)
3. Landscape is not supported, only portrait
4. Ball is affected by gravity so it will not fire exactly at direction of point of contact
5. Game should work on all ipad sizes
