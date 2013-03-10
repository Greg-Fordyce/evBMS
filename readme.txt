An open source battery management system for electric vehicles using lithium cells.

We make no claims about safety/effectiveness/reliability of this system.
It's just one of the many possible solutions now available for the management of EV batteries, and the standard disclaimer below applies.

This BMS carries no warranty or guarantee of any kind! It's used at your own risk, and I make no claims as to suitability for a particular function. Prospective users must evaluate the system before using it, and no liability will be entertained by anyone in any shape or form whatsoever.
The modules and software have been produced at low cost for the benefit of the EV & electronic community. The software is available free via the internet. Users may modify or adapt the system as they see fit. If you are not fully competent to work on potentially lethal battery systems and high voltages, then do not experiment with or use this system. Be aware that vehicle modifications can lead to invalidated insurance and warranty issues. You the end user remain fully liable for any modifications made to your vehicle.
The following licensces cover all aspects of this project. 
Hardware designs are licensed under the  TAPR Open Hardware License - http://www.tapr.org/ohl.html
All software/code is covered by the GPLv3 - http://www.gnu.org/licenses/gpl-3.0.html
Documentation is under the Creative Commons Attribution-ShareAlike 3.0 Unported - http://creativecommons.org/licenses/by-sa/3.0/
A useful list of other available BMS designs for your consideration is here
http://liionbms.com/php/bms_options.php

This is a open source battery management system for electric vehicles. The project started June 2008 and the main development work can be found on the Battery Vehicle Society forums here; http://www.batteryvehiclesociety.org.uk/forums/viewforum.php?f=53

The first generation system consists of slave boards, one for each cell (the latest designs incorporate multiple slaves on a single pcb) and a master board. The slaves report individual cell voltages to the master and also have a small load resistor for balancing cells during charging. The master controls charging and discharging, making sure all cells don't get over or undercharged. In addition the master also reads current through the pack, vehicle speed and pack temperatures and can calculate state of charge, remaining range, watt hours per mile, etc.

The second generation system has multiple slave boards that can do from 4 to 12 cells each and should  be suitable for all lithium battery chemstries along with Nicad and Nimh. Each slave board consists of a LTC6802-2 for measuring cell voltages and temperatures, a 16F1825 pic microcontroller that acts as a interface between the 6802 and master and a TTL-RS232 level converter for reliable comunications in a electric vehicle (while audibly quiet, EVs can be very noisy electrically. The Master used at the moment is based on a Maximite (http://geoffg.net/maximite.html) but the slaves are designed to be very simple to use, only 3 commands required, report cell voltage, report cell temperature and report current, so developing other master options should be fairly straight forward.
Project status as of March 2013. Prototype slaves are being tested/working in a electric vehicle with some simple code. I hope to have slave boards availible around May 2013 for anyone interested in this project. Pcb design is being done in Kicad and slave software is in PicBasic Pro.
Greg