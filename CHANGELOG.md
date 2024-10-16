# 3.4.0
- bug fix to represent match draws as draws and not losses
- added battleground Deephaul Ravine
- added support for Rated Battleground Blitz
    - backwards compatible with records written with previous REFlex version with the following exceptions:
        - old records that were a loss at 0 rating will be interpreted as casual games
        - old records will not have the team data (on shift+alt)
        - old records will be colored like casual games
    - all records recorded with new version will have an explicit flag for Blitz
    - updated bracket dropdown to specify Blitz or RBG on the Rated tab
- updated the stats summary logic to more cleanly and efficiently reflect the current view selected
    - currently only implemented on the battleground side and the arena side was untouched
- updated the rated team details (on shift+alt) to sort by damage done descending
- other minor code cleanup

# prior versions

see the [original repo](https://github.com/AcidWeb/REFlex) for details