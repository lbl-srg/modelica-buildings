within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
model OnOffFuzzyLogic
  "Fuzzy logic approach for on-off control"
  parameter Real ySetRed
    "Reduced relative compressor speed to allow longer on-time";
  Modelica.Blocks.Interfaces.BooleanInput turOn(start=false, fixed=true)
    "Indicates if device should turn on" annotation (Placement(transformation(
          extent={{-132,-76},{-100,-44}})));
  Modelica.Blocks.Interfaces.BooleanInput isAblToTurOn
    "Indicates if the device can turn on" annotation (Placement(transformation(
          extent={{-132,-106},{-100,-74}})));
  Modelica.Blocks.Interfaces.BooleanInput turOff(start=false, fixed=true)
    "Indicates if the device should turn off" annotation (Placement(
        transformation(extent={{-132,14},{-100,46}})));
  Modelica.Blocks.Interfaces.BooleanInput isAblToTurOff
    "Indicates if the device can turn off"
    annotation (Placement(transformation(extent={{-132,74},{-100,106}})));
  Modelica.Blocks.Interfaces.BooleanInput staOff
    "Indicates if the device has to stay off" annotation (Placement(
        transformation(extent={{-132,-46},{-100,-14}})));
  Modelica.Blocks.Interfaces.BooleanInput staOn
    "Indicates if the device has to stay on" annotation (Placement(transformation(
          extent={{-132,44},{-100,76}})));
  Modelica.Blocks.Interfaces.RealOutput yOut
    "Output for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput ySet
    "Input for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{-132,-16},{-100,16}})));
protected
  Integer devRunMin(start=0, fixed=true)
    "Indicates if device needs to run at minimal limit";
  Integer devTurOff(start=0, fixed=true)
    "Indicates if device needs to turn off";
  Integer devNorOpe(start=1, fixed=true)
    "Indicates if device is at normal operation";
equation
  // The part "+ 0 * devTurOff" is implicitly included
  yOut = ySet * devNorOpe + ySetRed  * devRunMin;
  when edge(turOn) then
    if isAblToTurOn then
      devTurOff = 0;
      devRunMin = 0;
      devNorOpe = 1;
   else
      devTurOff = 1;
      devRunMin = 0;
      devNorOpe = 0;
    end if;
  elsewhen edge(turOff) then
    if isAblToTurOff then
      devTurOff = 0;
      devRunMin = 0;
      devNorOpe = 1;
    else
      devTurOff = 0;
      devRunMin = 1;
      devNorOpe = 0;
    end if;
  elsewhen isAblToTurOn and turOn then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen isAblToTurOff and turOff then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen staOff then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  elsewhen staOn then
    devTurOff = 0;
    devRunMin = 0;
    devNorOpe = 1;
  end when;

  annotation (Documentation(info="<html>
<p>
The model uses a fuzzy logic approach to avoid the need for a state-machine.
The device either has to turn off, run at the desired operating speed, or run
at the minimal speed.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>December 06, 2023</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/Buildings/issues/1576\">IBPSA #1576</a>)
  </li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-154,138},{146,98}},
        textString="%name",
        textColor={0,0,255})}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OnOffFuzzyLogic;
