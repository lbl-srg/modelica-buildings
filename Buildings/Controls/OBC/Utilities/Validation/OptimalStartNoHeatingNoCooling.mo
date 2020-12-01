within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartNoHeatingNoCooling
  "Validation model for the block OptimalStart for the case with no preheating nor precooling"

  Buildings.Controls.OBC.Utilities.OptimalStart optSta(
    computeHeating=false,
    computeCooling=false) "Optimal start for both heating and cooling system"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Continuous.Integrator TRoo(k = 0.0000004, y_start = 19 + 273.15)
    "Room air temperature" annotation (
    Placement(transformation(extent = {{-20, 0}, {0, 20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOutBase(
    amplitude=5,
    freqHz=1/86400,
    offset=15 + 273.15,
    startTime(displayUnit="h") = 0)
    "Outdoor dry bulb temperature, base component"
    annotation (Placement(transformation(extent={{-208,-20},{-188,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain UA(k=25)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QCoo(k=-4000)
    "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=-6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=3,
    reverseActing=false) "PI control for space cooling"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{7,19},
    period=24*3600) "Daily schedule"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=3) "Sum heat gains"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2(realTrue=6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=3) "PI control for space heating"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QHea(k=2000)
    "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TOut "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-170,-40},{-150,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    amplitude=15,
    period(displayUnit="d") = 1209600,
    delay(displayUnit="d") = 604800)
    "Range of outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-210,-60},{-190,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSetHea(
    realTrue=273.15 + 21,
    realFalse=273.15 + 15,
    y(final unit="K", displayUnit="degC"))
    "Room temperature set point for heating"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSetCoo(
    realTrue=273.15 + 24,
    realFalse=273.15 + 30,
    y(final unit="K", displayUnit="degC"))
    "Room temperature set point for cooling"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
equation
  connect(dT.y, UA.u)   annotation (Line(points={{-118,10},{-102,10}}, color={0,0,127}));
  connect(TRoo.y, optSta.TZon) annotation (
    Line(points={{1,10},{10,10},{10,7},{38,7}},          color = {0, 0, 127}));
  connect(TRoo.y, dT.u1) annotation (
    Line(points = {{1, 10}, {6, 10}, {6, 34}, {-146, 34}, {-146, 16}, {-142, 16}}, color = {0, 0, 127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{62,6},{70,6},{70,
          10},{78,10}}, color={255,0,255}));
  connect(add1.y, conPID1.u_s)   annotation (Line(points={{162,10},{178,10}},   color={0,0,127}));
  connect(TRoo.y, conPID1.u_m) annotation (
    Line(points = {{1, 10}, {6, 10}, {6, -12}, {190, -12}, {190, -2}}, color = {0, 0, 127}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{1,-44},{10,-44},
          {10,2},{38,2}},       color={0,0,127}));
  connect(UA.y, mulSum.u[1]) annotation (Line(points={{-78,10},{-70,10},{-70,
          11.3333},{-62,11.3333}},
                          color={0,0,127}));
  connect(TRoo.u, mulSum.y) annotation (
    Line(points = {{-22, 10}, {-38, 10}}, color = {0, 0, 127}));
  connect(optSta.optOn, booToRea2.u) annotation (Line(points={{62,6},{70,6},{70,
          50},{78,50}}, color={255,0,255}));
  connect(add2.y, conPID.u_s)   annotation (Line(points={{162,50},{178,50}}, color={0,0,127}));
  connect(conPID.u_m, dT.u1) annotation (Line(points={{190,38},{190,34},{-146,34},
          {-146,16},{-142,16}}, color={0,0,127}));
  connect(conPID1.y, QCoo.u) annotation (Line(points={{202,10},{210,10},{210,-80},
          {-110,-80},{-110,-30},{-102,-30}}, color={0,0,127}));
  connect(conPID.y, QHea.u) annotation (Line(points={{202,50},{212,50},{212,-120},
          {-108,-120},{-108,-100},{-102,-100}},
                                              color={0,0,127}));
  connect(QCoo.y, mulSum.u[2]) annotation (Line(points={{-78,-30},{-70,-30},{-70,
          10},{-62,10}}, color={0,0,127}));
  connect(QHea.y, mulSum.u[3]) annotation (Line(points={{-78,-100},{-68,-100},{-68,
          8.66667},{-62,8.66667}}, color={0,0,127}));
  connect(TOutBase.y, TOut.u1) annotation (Line(points={{-186,-10},{-178,-10},{
          -178,-24},{-172,-24}}, color={0,0,127}));
  connect(TOut.y, dT.u2) annotation (Line(points={{-148,-30},{-146,-30},{-146,4},
          {-142,4}}, color={0,0,127}));
  connect(pul.y, TOut.u2) annotation (Line(points={{-188,-50},{-176,-50},{-176,
          -36},{-172,-36}}, color={0,0,127}));
  connect(TSetCoo.y, add1.u2) annotation (Line(points={{102,-30},{130,-30},{130,
          4},{138,4}},
                    color={0,0,127}));
  connect(occSch.occupied, TSetCoo.u) annotation (Line(points={{1,-56},{60,-56},
          {60,-30},{78,-30}}, color={255,0,255}));
  connect(TSetHea.u, occSch.occupied) annotation (Line(points={{78,-60},{60,-60},
          {60,-56},{1,-56}}, color={255,0,255}));
  connect(TSetHea.y, add2.u2) annotation (Line(points={{102,-60},{126,-60},{126,
          44},{138,44}}, color={0,0,127}));
  connect(booToRea2.y, add2.u1) annotation (Line(points={{102,50},{126,50},{126,
          56},{138,56}}, color={0,0,127}));
  connect(booToRea1.y, add1.u1) annotation (Line(points={{102,10},{120,10},{120,
          16},{138,16}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=2419200,
      Tolerance=1e-06),
      __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartNoHeatingNoCooling.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This models validates the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> for the case when the optimal start
is not turned on for preheating or precooling before the scheduled occupancy.
</p>
<p>
The results shows that the optimal start time <code>tOpt</code> remains zero and
the optimal start on signal <code>optOn</code> remains false during the simulation.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2020, by Michael Wetter:<br/>
Simplified setpoint implementation.
</li>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,160}})));
end OptimalStartNoHeatingNoCooling;
