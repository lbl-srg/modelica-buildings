within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses;
partial model PartialVDI6007
  "Partial model for equivalent air temperature as defined in VDI 6007 Part 1"

  parameter Modelica.SIunits.Emissivity aExt
    "Coefficient of absorption of exterior walls (outdoor)";
  parameter Modelica.SIunits.Emissivity eExt
    "Coefficient of emission of exterior walls (outdoor)";
  parameter Integer n "Number of orientations (without ground)";
  parameter Real wfWall[n](each final unit="1") "Weight factors of the walls";
  parameter Real wfWin[n](each final unit="1") "Weight factors of the windows";
  parameter Real wfGro(unit="1")
    "Weight factor of the ground (0 if not considered)";
  parameter Modelica.SIunits.Temperature TGro
    "Temperature of the ground in contact with floor plate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWallOut
    "Exterior walls convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRadWall
    "Coefficient of heat transfer for linearized radiation for exterior walls";
  parameter Boolean withLongwave=true
    "Set to true to include longwave radiation exchange"
    annotation(choices(checkBox = true));

  Modelica.SIunits.Temperature TEqWall[n] "Equivalent wall temperature";
  Modelica.SIunits.Temperature TEqWin[n] "Equivalent window temperature";
  Modelica.SIunits.TemperatureDifference delTEqLW
    "Equivalent long wave temperature";
  Modelica.SIunits.TemperatureDifference delTEqSW[n]
    "Equivalent short wave temperature";

  Modelica.Blocks.Interfaces.RealInput HSol[n](
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Solar radiation per unit area"
    annotation (Placement(
    transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature"
    annotation (Placement(
    transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature"
    annotation (Placement(
    transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput TEqAir(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Equivalent air temperature"
    annotation (Placement(
    transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput sunblind[n]
    "Opening factor of sunblinds for each direction (0 - open to 1 - closed)"
    annotation (Placement(
    transformation(
    extent={{-20,-20},{20,20}},
    rotation=-90,
    origin={0,120})));

initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGro) > 0.1),
  "The sum of the weighting factors (walls,windows and ground) in eqAirTemp is close
   to 0. If there are no walls, windows and ground at all, this might be
   irrelevant.", level=AssertionLevel.warning);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}}),
  graphics={
  Rectangle(
    extent={{-70,70},{78,-76}},
    lineColor={170,213,255},
    lineThickness=1,
    fillPattern=FillPattern.Solid,
    fillColor={170,213,255}),
  Ellipse(
    extent={{-70,70},{-16,18}},
    lineColor={255,221,0},
    fillColor={255,225,0},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-70,-92},{76,-128}},
    lineColor={0,0,255},
    lineThickness=0.5,
    fillColor={236,99,92},
    fillPattern=FillPattern.Solid,
    textString="%name"),
  Rectangle(
    extent={{4,46},{78,-76}},
    fillColor={215,215,215},
    fillPattern=FillPattern.Backward,
    lineColor={0,0,0}),
  Rectangle(
    extent={{8,42},{78,-72}},
    lineColor={0,0,0},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Line(points={{8,42},{30,14},{78,14}}, color={0,0,0}),
  Line(points={{10,-72},{30,-40},{78,-40}}, color={0,0,0}),
  Line(points={{30,14},{30,-40}}, color={0,0,0})}),
  Documentation(info="<html>
  <p><code>PartialVDI6007</code> is a partial model for <code>EquivalentAirTemperature</code>
  models.</p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  September 2015, by Moritz Lauster:<br/>
  Got rid of cardinality
  and used assert for warnings.<br/>
  Adapted to Annex 60 requirements.
  </li>
  <li>
  October 2014, by Peter Remmen:<br/>
  Implemented.
  </li>
  </ul>
  </html>"));
end PartialVDI6007;
