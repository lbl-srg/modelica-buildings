within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses;
partial model PartialVDI6007
  "Partial model for equivalent air temperature as defined in VDI 6007 Part 1"

  parameter Modelica.Units.SI.Emissivity aExt
    "Coefficient of absorption of exterior walls (outdoor)";
  parameter Integer n "Number of orientations (without ground)";
  parameter Real wfWall[n](each final unit="1") "Weight factors of the walls";
  parameter Real wfWin[n](each final unit="1") "Weight factors of the windows";
  parameter Real wfGro(unit="1")
    "Weight factor of the ground (0 if not considered)";
  parameter Modelica.Units.SI.Temperature TGro
    "Temperature of the ground in contact with floor plate";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConWallOut
    "Exterior walls convective coefficient of heat transfer (outdoor)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hRad
    "Coefficient of heat transfer for linearized radiation";
  parameter Boolean withLongwave=true
    "Set to true to include longwave radiation exchange"
    annotation(choices(checkBox = true));

  Modelica.Units.SI.Temperature TEqWall[n] "Equivalent wall temperature";
  Modelica.Units.SI.Temperature TEqWin[n] "Equivalent window temperature";
  Modelica.Units.SI.TemperatureDifference delTEqLW
    "Equivalent long wave temperature";
  Modelica.Units.SI.TemperatureDifference delTEqLWWin
    "Equivalent long wave temperature for windows";
  Modelica.Units.SI.TemperatureDifference delTEqSW[n]
    "Equivalent short wave temperature";

  Modelica.Blocks.Interfaces.RealInput HSol[n](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2") "Solar radiation per unit area"
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
  Modelica.Blocks.Interfaces.RealInput sunblind[n](
    each min=0,
    each max=1,
    each final unit="1")
    "Opening factor of sunblinds for each direction (0 - open to 1 - closed)"
    annotation (Placement(
    transformation(
    extent={{-20,-20},{20,20}},
    rotation=-90,
    origin={0,120})));

initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGro) > 0.1),
 "The sum of the weighting factors (walls,windows and ground) in the
   equivalent air temperature calculation is close to 0.
   If there are no walls, windows and ground at all, this might be
   irrelevant.", level=AssertionLevel.warning);

equation
  delTEqLW=(TBlaSky - TDryBul)*hRad/(hRad + hConWallOut);
  delTEqSW=HSol*aExt/(hRad + hConWallOut);
  if withLongwave then
    TEqWin=TDryBul.+delTEqLWWin*(ones(n)-sunblind);
    TEqWall=TDryBul.+delTEqLW.+delTEqSW;
  else
    TEqWin=TDryBul*ones(n);
    TEqWall=TDryBul.+delTEqSW;
  end if;

  annotation (  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}}),
  graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
  Ellipse(
    extent={{-92,94},{-20,24}},
    lineColor={255,221,0},
    fillColor={255,225,0},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-70,-110},{76,-146}},
    textColor={0,0,255},
    lineThickness=0.5,
    fillColor={236,99,92},
    fillPattern=FillPattern.Solid,
    textString="%name"),
  Rectangle(
    extent={{-2,54},{100,-82}},
    fillColor={215,215,215},
    fillPattern=FillPattern.Backward,
    lineColor={0,0,0}),
  Rectangle(
    extent={{2,50},{100,-78}},
    lineColor={0,0,0},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Line(points={{2,50},{32,20},{100,20}},color={0,0,0}),
  Line(points={{2,-78},{32,-48},{100,-48}}, color={0,0,0}),
  Line(points={{32,20},{32,-48}}, color={0,0,0})}),
  Documentation(info="<html>
  <p><code>PartialVDI6007</code> is a partial model for <code>EquivalentAirTemperature</code>
  models.</p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaRad</code> to <code>hRad</code>,
  <code>alphaWinOut</code> to <code>hConWallOut</code>
  </li>
  <li>
  September 26, 2016, by Moritz Lauster:<br/>
  Removed deprecated parameters and values
  0.93 and <code>eExt</code>.<br/>
  Renamed <code>alphaRadWall</code> to
  <code>alphaRad</code>. Deleted
  <code>alphaRadWin</code>.<br/>
  Moved calculations from
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007\">
  Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007</a> and
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow\">
  Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow</a> to here.
  </li>
  <li>
  September 2015, by Moritz Lauster:<br/>
  Got rid of cardinality and used assert for warnings.<br/>
  Adapted to Annex 60 requirements.
  </li>
  <li>
  October 2014, by Peter Remmen:<br/>
  Implemented.
  </li>
  </ul>
</html>"));
end PartialVDI6007;
