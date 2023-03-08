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
  
 ### 41. Zeppelin
 * Adding a zeppelin to the city
 * Having the zeppelin drift slowly