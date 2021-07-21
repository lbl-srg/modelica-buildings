within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model ASHRAE2006Winter
  "Variable air volume flow system with terminal reheat and five thermal zones using a control sequence published by ASHRAE in 2006"
  extends Buildings.Examples.VAVReheat.ASHRAE2006(
    redeclare replaceable Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor flo
      constrainedby Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor,
    ACHCor=4,
    ACHSou=4,
    ACHEas=6,
    ACHNor=4,
    ACHWes=6);
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/ASHRAE2006Winter.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-380,-400},{1420,660}})),
    Documentation(
      info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Impementation of <a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a> model with an EnergyPlus thermal zone instance.
</li>
</ul>
</html>"));
end ASHRAE2006Winter;
