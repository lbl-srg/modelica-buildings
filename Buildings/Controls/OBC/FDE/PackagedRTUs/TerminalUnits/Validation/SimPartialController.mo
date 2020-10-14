within Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.Validation;
model SimPartialController
  "This model simulates SimPartialController"

  parameter Real coolTStpt(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=297.15
   "Zone cooling temperature set point."
   annotation (Dialog(group="Temperature set points"));
  parameter Real heatTStpt(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=293.15
   "Zone heating temperature set point."
   annotation (Dialog(group="Temperature set points"));
  parameter Real coolMinDelay(
    final unit="s",
    final quantity="Time")=5
    "Minimum delay before issuing cool request after trigger"
    annotation (Dialog(group="Trigger delay times"));
  parameter Real heatMinDelay(
    final unit="s",
    final quantity="Time")=5
    "Minimum delay before issuing heat request after trigger"
    annotation (Dialog(group="Trigger delay times"));
   parameter Real occMinDelay(
    final unit="1",
    final quantity="Time")=5
    "Minimum delay before issuing occupancy request after trigger"
    annotation (Dialog(group="Trigger delay times"));
  parameter Real coolDStpt(
    final unit="1")=0.85
    "Trigger cool request when cooling PID exceeds this value"
    annotation (Dialog(group="PID trigger set points"));
  parameter Real heatDStpt(
    final unit="1")=0.85
    "Trigger heat request when cooling PID exceeds this value"
    annotation (Dialog(group="PID trigger set points"));
  parameter Integer coolReqG(
     min=1) = 1
     "Cooling request gain"
    annotation (Dialog(group="Request gain parameters"));
  parameter Integer heatReqG(
     min=1) = 1
     "Heating request gain"
    annotation (Dialog(group="Request gain parameters"));
  parameter Integer occReqG(
     min=1) = 1
     "Occupancy request gain"
    annotation (Dialog(group="Request gain parameters"));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine SpaceTGen(
    amplitude=3,
    freqHz=1/3600,
    offset=295.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  OccGen(width=0.5, period=2880)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController
    SimPartCon annotation (Placement(transformation(extent={{54,-10},{74,10}})));
equation
  connect(SpaceTGen.y, SimPartCon.ZoneT) annotation (Line(points={{-38,20},{8,20},
          {8,3.6},{52,3.6}}, color={0,0,127}));
  connect(OccGen.y, SimPartCon.OccOvrd) annotation (Line(points={{-38,-20},{8,-20},
          {8,-3.2},{52,-3.2}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=11520,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/TerminalUnits/Validation/SimPartialController.mos"
        "Simulate and plot"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>September 9, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>"));
end SimPartialController;
