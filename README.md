# Code from the GodotGetaway Course

## Purpose
This repository captures the lecture by lecture code entry for the GodotGetaway course for reference and code reuse.

## How to use this
Commits should reflect lecture-by-lecture change to the overall code through the course of the lectures.

## Limitations
The repository was created after quite a lot of coding was done. The content which is not reflected in individual commits includes: 
* setting up multiplayer functionality
* controlling the vehiclebody and customizing the driving experience
* starting with procedural generation of the city's gridmap for single player and multiplayer

Subsequent commits should reflect finer-grained changes to the code. 
 ## Section Content
 
 Each lecture covers different content, as follows:
 
 ### 6. Preparing the multiplayer lobby
 * The bare minimum to connect a server to a client
 * Creating a placeholder lobby
 * Intro to IP addresses and ports
 * Localhost/loopback IP
 
 ### 7. Creating a network
 * Introducing NetworkedMultiplayerENet
 * Creating a server
 * Connecting to a server
 * Generating player IDs
 * Introducing remote and rpc()
 
 ### 8. Introducing RPCs
 * Intro to RPC
 * Reliable and Unrealiable calls
 * Calls to a specific peer
 * Using Remote and Sync keywords
 
 ### 9. Using a save file
 * res:// vs user://
 * Creating a save file if there isn't one already
 * Using the players dictionary
 
 ### 10. Populating the waiting room
 * Saving the player's name
 * Specifying an IP and Port
 * Updating the waiting room with ItemList
 * using rset()
  
 ### 17. City Generation overview
 * Looking at our tiles
 * Basics of using procedural generation for the city
 
 ### 18. Setting up the Gridmap
 * Importing the road pieces
 * Converting a scene to a mesh library
 * Setting up the Gridmap
 
 ### 19. Code and Gridmaps
 * What a Gridmap is
 * Clearing a Gridmap
 * Filling a map with blank tiles
 * Filling a map with random tiles
 
 ### 20. Making a Maze
 * Making a recursive backtracker algorithm
 * Generating a perfect maze with a Gridmap
 
 ### 21. Filling Gaps
 * Identifying the gaps in the road
 * Picking the right piece for the gaps
 * Filling the gaps
 
 ### 22. Erasing Walls
 * Remove a percentage of walls randomly from the map
 * Keep the new road pieces from going off the edge
 
 ### 23. Adding Buildings
 * Importing and preparing our buildings
 * Picking a random building
 * Placing buildings in the city
 
 ### 24. Rotating Buildings
 * Picking a random cell rotation
 * Rotating all building tiles randomly
 
 ### 25. Chance of skyscraper
 * Picking a specific building type
 * Assigning special rules to that building type
 
 ### 26. Networked City Generation
 * Putting the host in charge of city generation
 * Having clients generate identical maps
 
 ### 27. Pausing until everyone's ready
 * Pausing the game
 * Tracking how many players are ready
 * Spawning players when everyone's ready
 
 ### 28. Making a map border
 * Using CSG to make a map border
 * Having the host resize the border
 * Resizing the border to fit the map
 * Making sure the border's collision works
 
 ### 29. Preparing Props
 * Making a Parked Cars scene
 * Setting the scene up for map generation
 
 ### 30. Parked Cars
 * Make an array of all road tiles
 * Pick a tile at random from the allowed array
 * Find out what directions the cars can be rotated
 * Spawn the cars at the same place on all machines
 
 ### 31. Billboards
 * Using CSGCombiner to make simple CSG objects
 * Picking a random material from a folder
 * Spawning billboards
 
 ### 32. Traffic Cones
 * Deciding if props should be tracked accurately over the network
 * Making a traffic cone
 * Having props despawn 10 seconds after being hit
 
 ### 33. Hydrants
 * Making the car easier to drive
 * Making a fire hydrant scene
 * Emitting water particles when the hydrant is hit
 * Having the car react to the water
 
 ### 34. Street Lights
 * Why not to put streetlights on the gridmap
 * Setting up the streetlights
 * Shadows and light
 
 ### 35. Dumpsters
 * When two props want to be in the same place
 
 ### 36. Scaffolding
 * Making a prop out of multiple RigidBody nodes
 * Sound effects on collision
 
 ### 37. Preparing Neighborhoods
 * Reusing existing meshes with different materials
 * Adding buildings to the city
 
 ### 38. Neighborhoods
 * Adding unique buildings to each neighborhood
 * Splitting the city into four neighborhoods
 
 ### 39. Preparing Cafes
 * Getting cafe tables and chairs ready for spawning
 * Reusing the cone script
 
 ### 40. Cafes
 * Checking if a tile is on of a list of buildings
 * Placing a prop on specific buildings
 
 ### 41. Zeppelin
 * Adding a zeppelin to the city
 * Having the zeppelin drift slowly
 
 ### 42. Setting up Teams
 * Change the player mesh
 * Add cops to a group
 * Use collision layers
 
 ### 43. MiniMap
 * Setting up a second camera as a minimap
 * Using multiple cameras at once
 * Viewports and ViewportContainers
 * Adjusting the minimap with player speed
 
 ### 44. Grid References
 * Adding a grid reference to the minimap
 * Using Stepify