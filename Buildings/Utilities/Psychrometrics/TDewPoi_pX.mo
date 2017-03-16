within Buildings.Utilities.Psychrometrics;
block TDewPoi_pX
  "Calculate dew point temperature from pressure and mass fraction of water"
  extends Modelica.Blocks.Icons.Block;

  // CONSTANTS
  constant Real phiSat(min=0,max=1,unit="1") = 1;
  constant Real XMin = 0.0001;

  // INPUTS
  Modelica.Blocks.Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar") = 101325
    "Pressure of the fluid"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput XSat(min=0,max=1,unit="1")
    "Mass fraction of water in air"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  // OUTPUTS
  Modelica.Blocks.Interfaces.RealOutput TDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Dew point temperature of air"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.SIunits.AbsolutePressure pSat(start=2000)
    "Saturation pressure of moist air";
  Real XSatAct
    "The actual value of XSat used in the equations; protects from
    not being able to solve for 100% dry air";

algorithm
  if XSat < XMin then
    XSatAct := XMin;
  else
    XSatAct := XSat;
  end if;

equation
  pSat = Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi_amb(
    T=TDewPoi);
  XSatAct = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
    pSat=pSat, p=p, phi=phiSat);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{76,-72},{66,-70},{66,-74},{76,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{74,-72},{-74,-72}}),
        Line(points={{-76,86},{-76,-72}}),
        Polygon(
          points={{-76,88},{-74,74},{-78,74},{-76,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{74,-74},{96,-92}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          extent={{-68,94},{-40,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Tdp"),
        Line(points={{-64,-72},{-64,-42}},color={175,175,175}),
        Line(points={{-76,-46},{-62,-42},{-32,-30},{0,-2},{12,22},{20,54},{24,74}}),
        Polygon(
          points={{-36,-32},{-22,-30},{-22,-34},{-36,-32}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,-32},{-36,-32}},
          color={255,0,0},
          thickness=0.5),
        Line(points={{-36,-72},{-36,-32}},color={175,175,175}),
        Line(points={{-6,-72},{-6,-8}},
                                     color={175,175,175}),
        Line(points={{24,-72},{24,74}},color={175,175,175}),
        Text(
          extent={{-98,48},{-78,34}},
          lineColor={28,108,200},
          textString="p"),
        Text(
          extent={{-96,-34},{-76,-48}},
          lineColor={28,108,200},
          textString="XSat"),
        Text(
          extent={{78,8},{98,-6}},
          lineColor={28,108,200},
          textString="Tdp")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TDewPoi_pX;
