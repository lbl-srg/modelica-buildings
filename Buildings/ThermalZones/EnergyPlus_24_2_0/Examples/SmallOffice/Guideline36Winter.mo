within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model Guideline36Winter
  "Variable air volume flow system with terminal reheat and five thermal zones controlled using an ASHRAE G36 controller"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding(
    mCor_flow_nominal=ACHCor*VRooCor*conv,
    mSou_flow_nominal=ACHSou*VRooSou*conv,
    mEas_flow_nominal=ACHEas*VRooEas*conv,
    mNor_flow_nominal=ACHNor*VRooNor*conv,
    mWes_flow_nominal=ACHWes*VRooWes*conv,
    redeclare Buildings.Examples.VAVReheat.BaseClasses.Guideline36 hvac,
    redeclare
      Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor
      flo);

  parameter Real ACHCor(final unit="1/h")=4
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=4
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=6
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=4
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=6
    "Design air change per hour west";

  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/Guideline36Winter.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
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
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system,
and see the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor</a>
for a description of the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36\">
Buildings.Controls.OBC.ASHRAE.G36</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter</a>..
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations and added optimal start up.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Impementation of <a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a> model with an EnergyPlus thermal zone instance.
</li>
</ul>
</html>"));
end Guideline36Winter;
