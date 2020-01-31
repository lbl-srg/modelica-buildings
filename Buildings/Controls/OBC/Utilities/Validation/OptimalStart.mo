within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStart "Validation model for the block OptimalStart"
  extends Modelica.Icons.Example;
  CDL.Continuous.Sources.Constant TSetHeaOcc(k=21 + 273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Continuous.Sources.Sine TZon(
    amplitude=-1.3,
    freqHz=1/82800,
    offset=21 + 273.15,
    startTime(displayUnit="h") = 0) "Zone temperature for heating case"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(heating_only=false,
      cooling_only=true) "Cooling only case"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optSta(heating_only=false,
      cooling_only=false) "Both heating and cooling"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Continuous.Sources.Sine TZon1(
    amplitude=1,
    freqHz=1/82800,
    offset=24 + 273.15,
    startTime(displayUnit="h") = 0) "Zone temperature for cooling case"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Sources.Sine TZon2(
    amplitude=3,
    freqHz=1/165600,
    offset=22.5 + 273.15,
    startTime(displayUnit="h") = 0)
    "Zone temperature for both heating and cooling case"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  SetPoints.OccupancySchedule                    occSchWee(occupancy=3600*{7,19,
        31,43,55,67,79,91,103,115,127,139}, period=7*24*3600) "Week schedule"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
equation
  connect(TZon.y, optStaHea.TZon)
    annotation (Line(points={{-58,80},{20,80},{20,27},{38,27}},
                                                color={0,0,127}));
  connect(optStaCoo.TSetZonCoo, TSetCooOcc.y) annotation (Line(points={{38,-7},{
          6,-7},{6,-80},{-58,-80}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optSta.TSetZonHea) annotation (Line(points={{-58,-40},{
          16,-40},{16,-42},{38,-42}}, color={0,0,127}));
  connect(TSetCooOcc.y, optSta.TSetZonCoo) annotation (Line(points={{-58,-80},{6,
          -80},{6,-47},{38,-47}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optStaHea.TSetZonHea) annotation (Line(points={{-58,-40},
          {16,-40},{16,38},{38,38}}, color={0,0,127}));
  connect(TZon1.y, optStaCoo.TZon) annotation (Line(points={{-58,40},{10,40},{
          10,-13},{38,-13}}, color={0,0,127}));
  connect(TZon2.y, optSta.TZon) annotation (Line(points={{-58,0},{-40,0},{-40,
          -53},{38,-53}}, color={0,0,127}));
  connect(occSchWee.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-19,
          26},{-8,26},{-8,-18},{38,-18}}, color={0,0,127}));
  connect(occSchWee.tNexOcc, optSta.tNexOcc) annotation (Line(points={{-19,26},
          {-8,26},{-8,-58},{38,-58}}, color={0,0,127}));
  connect(occSchWee.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-19,
          26},{-8,26},{-8,22},{38,22}}, color={0,0,127}));
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
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{80,100}})));
end OptimalStart;
