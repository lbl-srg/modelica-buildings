within Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones controlled using an ASHRAE G36 controller"
  extends Buildings.Examples.VAVReheat.Guideline36(
    redeclare replaceable Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.Floor flo(
      redeclare package Medium = MediumA),
    ACHCor=0.5*6,
    ACHSou=0.75*6,
    ACHEas=1*9,
    ACHNor=0.75*6,
    ACHWes=1*7,
    conAHU(kFanSpe=1));

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/VAVReheatRefBldgSmallOffice/Guideline36.mos"
        "Simulate and plot"),
    experiment(StopTime=172800, Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,extent={{-400,-320},{1380,680}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.ASHRAE2006\">
Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.ASHRAE2006</a>..
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Impementation of <a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a> model with an EnergyPlus thermal zone instance.
</li>
</ul>
</html>"));

end Guideline36;
