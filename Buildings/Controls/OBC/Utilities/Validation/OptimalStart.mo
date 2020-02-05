within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStart "Validation model for the block OptimalStart"

  Buildings.Controls.OBC.Utilities.OptimalStart optSta(computeHeating=true)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Continuous.Integrator integrator(y_start=16 + 273.15)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Continuous.Sources.Constant TSetHeaOcc(k=21 + 273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  SetPoints.OccupancySchedule                    occSchWee(occupancy=3600*{7,19,
        31,43,55,67,79,91,103,115,127,139}, period=7*24*3600) "Week schedule"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  CDL.Continuous.Sources.Sine TOut(
    amplitude=2,
    freqHz=1/82800,
    phase=3.1415926535898,
    offset=18 + 273.15,
    startTime(displayUnit="h") = 0) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-146,0},{-126,20}})));
  CDL.Continuous.Gain UA(k=500) "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  CDL.Continuous.Add dTdt "Temperature differential"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Gain QHea(k=2350) "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
equation
  connect(integrator.y, optSta.TZon) annotation (Line(points={{21,30},{30,30},{30,
          27},{38,27}}, color={0,0,127}));
  connect(occSchWee.tNexOcc, optSta.tNexOcc) annotation (Line(points={{21,-4},{30,
          -4},{30,22},{38,22}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optSta.TSetZonHea) annotation (Line(points={{22,80},{36,
          80},{36,38},{38,38}}, color={0,0,127}));
  connect(dT.y, UA.u)
    annotation (Line(points={{-88,30},{-82,30}}, color={0,0,127}));
  connect(QHea.y, dTdt.u2) annotation (Line(points={{-58,-10},{-48,-10},{-48,24},
          {-42,24}}, color={0,0,127}));
  connect(integrator.y, dT.u1) annotation (Line(points={{21,30},{30,30},{30,54},
          {-116,54},{-116,36},{-112,36}}, color={0,0,127}));
  connect(TOut.y, dT.u2) annotation (Line(points={{-124,10},{-116,10},{-116,24},
          {-112,24}}, color={0,0,127}));
  connect(dTdt.y, integrator.u)
    annotation (Line(points={{-18,30},{-2,30}}, color={0,0,127}));
  connect(booToRea.y, QHea.u) annotation (Line(points={{142,30},{146,30},{146,-32},
          {-88,-32},{-88,-10},{-82,-10}}, color={0,0,127}));
  connect(optSta.optOn, or2.u1) annotation (Line(points={{62,26},{74,26},{74,30},
          {78,30}}, color={255,0,255}));
  connect(or2.y, booToRea.u)
    annotation (Line(points={{102,30},{118,30}}, color={255,0,255}));
  connect(occSchWee.occupied, or2.u2) annotation (Line(points={{21,-16},{74,-16},
          {74,22},{78,22}}, color={255,0,255}));
  connect(UA.y, dTdt.u1) annotation (Line(points={{-58,30},{-48,30},{-48,36},{-42,
          36}}, color={0,0,127}));
  annotation (
  experiment(StopTime=604800, Tolerance=1e-06),__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStart.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation models for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>.
</p>
<p>
Three models are included to validate three different types of systems: space heating,
cooling and heat pump system. The three models use the same weekly occupancy schedule
with no occupants on the 7th day. Each model uses its own zone temperature profile based
on a sinusoidal function.
The sinusoidal period of zone temperatures is not 24 hours so that a different indoor 
condition is tested each day.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
                                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end OptimalStart;
