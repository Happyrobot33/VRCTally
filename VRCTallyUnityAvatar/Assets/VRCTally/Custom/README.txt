This is for creation of your own custom avatar actions in response to the various states of the VRCTally system
Customise the various "VRCTally_CustomControl_*" Animations to drive whatever material/material properties/animations/ect you want.
Then, simply add the "VRCTally_CustomControl" prefab to your avatar's root. 
VRCFury required.

VRCTally_CustomControl_Disabled
- Empty animation for the system toggle off state. Leave empty.

VRCTally_CustomControl_NoHeartbeat
- Animation for no heartbeat. Usual shader mode is a flashing yellow.

VRCTally_CustomControl_Heartbeat_NoState
- Animation for a valid heartbeat with no state. Usual shader mode is a flashing light blue ("Shader error").

VRCTally_CustomControl_Error
- Animation for "Error" state. Usual shader mode is a flashing magenta.

VRCTally_CustomControl_Preview
- Animation for 'Preview' state. Usual shader mode is a solid green.

VRCTally_CustomControl_Program
- Animation for 'Program' state. Usual shader mode is a solid red.

VRCTally_CustomControl_StandBy
- Animation for 'StandBy' state. Usual shader mode is a solid dark blue.
