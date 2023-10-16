within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls;
model Reset
  "Supervisory supply temperature reset"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Temperature THeaWatSupSetMin(displayUnit="degC")
    "Minimum value of heating water supply temperature set point";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
    iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point after reset"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minSet(
    k=THeaWatSupSetMin)
    "Minimum value of HW set point"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiHea
    "Switch"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate ramLimHea(raisingSlewRate
      =0.1) "Limit the rate of change"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(THeaWatSupPreSet,swiHea.u1)
    annotation (Line(points={{-120,-50},{-80,-50},{-80,8},{-2,8}},color={0,0,127}));
  connect(minSet.y,swiHea.u3)
    annotation (Line(points={{-38,-20},{-20,-20},{-20,-8},{-2,-8}},color={0,0,127}));
  connect(uHea,swiHea.u2)
    annotation (Line(points={{-120,60},{-60,60},{-60,0},{-2,0}},color={255,0,255}));
  connect(swiHea.y,ramLimHea.u)
    annotation (Line(points={{22,0},{48,0}},color={0,0,127}));
  connect(ramLimHea.y,THeaWatSupSet)
    annotation (Line(points={{72,0},{120,0}},color={0,0,127}));
  annotation (
    defaultComponentName="resTSup",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the supervisory reset of the heating water
supply temperature.
The heating water supply temperature is reset down whenever the
heating demand signal yielded by the building automation system
is <code>false</code>.
This enables operating the chiller at a reduced lift whenever
there is no requirement on the water temperature supplied to the
building system.
</p>
<p>
Note that the chilled water supply temperature is not reset
for the sake of simplicity. It would indeed require a more
involved algorithm preventing the reset in case it limits
the cold rejection capacity considering the actual
district water temperature.
</p>
</html>"));
end Reset;
