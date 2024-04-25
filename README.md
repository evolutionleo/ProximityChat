# ProximityChat
A simple mutliplayer proximity chat example project

## Instructions:

1) Run the server.js file using [Node](https://nodejs.org/en)

2) Run the GameMaker client normally, it should pop open 2 windows

3) Press R to start recording voice, press R again to stop. 0-9 numbers to change the recording device

## Limitations:
1) BEWARE OF MEMORY LEAKS!

2) As of 2024, 16KHz rate is still the hard limit for recording audio in GameMaker (for some reason) so it compresses it pretty badly lol. No way around that unless you find some .DLL-based extension for recording audio
## Credits:
[MultiClient](https://github.com/tabularelf/multiclient) by [TabularElf](https://github.com/tabularelf)
