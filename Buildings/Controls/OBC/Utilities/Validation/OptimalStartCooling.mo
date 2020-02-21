within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartCooling
  "Validation model for the block OptimalStart for cooling system"

  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(
    computeHeating=false,computeCooling=true)
    "Optimal start for cooling system"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=0.0000005,  y_start=24 +
        273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    freqHz=1/86400,
    offset=28 + 273.15,
    startTime(displayUnit="h") = 0)
    "Outdoor dry bulb temperature to test cooling system"
    annotation (Placement(transformation(extent={{-194,-20},{-174,0}})));
  CDL.Continuous.Gain UA(k=100) "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Continuous.Add dTdt1 "Temperature derivative"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Gain QCoo(k=-800)  "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Continuous.Gain TSetUp(k=-6)
    "Cooling setpoint temperature setup during unoccupied period"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetCoo(
    table=[0,30 + 273.15; 7*3600,24 + 273.15; 19*3600,30 + 273.15; 24*3600,30
         + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{118,0},{138,20}})));
  CDL.Continuous.LimPID conPID1(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti(displayUnit="s") = 2,
    yMax=1,
    yMin=0,
    reverseAction=true)
            annotation (Placement(transformation(extent={{152,0},{172,20}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19}, period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(dT.y, UA.u)
    annotation (Line(points={{-138,10},{-122,10}}, color={0,0,127}));
  connect(TOut.y, dT.u2) annotation (Line(points={{-172,-10},{-166,-10},{-166,4},
          {-162,4}}, color={0,0,127}));
  connect(dTdt1.y, integrator1.u)   annotation (Line(points={{-58,10},{-42,10}},  color={0,0,127}));
  connect(QCoo.y, dTdt1.u2) annotation (Line(points={{-98,-50},{-88,-50},{-88,4},
          {-82,4}},        color={0,0,127}));
  connect(integrator1.y, optStaCoo.TZon) annotation (Line(points={{-19,10},{-8,
          10},{-8,7},{-2,7}},      color={0,0,127}));
  connect(integrator1.y, dT.u1) annotation (Line(points={{-19,10},{-14,10},{-14,
          36},{-166,36},{-166,16},{-162,16}}, color={0,0,127}));
  connect(TSetCooOcc.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-18,80},
          {-6,80},{-6,13},{-2,13}},     color={0,0,127}));
  connect(UA.y, dTdt1.u1) annotation (Line(points={{-98,10},{-90,10},{-90,16},{
          -82,16}}, color={0,0,127}));
  connect(optStaCoo.optOn, booToRea1.u) annotation (Line(points={{22,6},{30,6},
          {30,10},{38,10}},        color={255,0,255}));
  connect(booToRea1.y, TSetUp.u)
    annotation (Line(points={{62,10},{78,10}},   color={0,0,127}));
  connect(add1.y, conPID1.u_s)
    annotation (Line(points={{140,10},{150,10}},   color={0,0,127}));
  connect(integrator1.y, conPID1.u_m) annotation (Line(points={{-19,10},{-14,10},
          {-14,-20},{162,-20},{162,-2}},      color={0,0,127}));
  connect(conPID1.y, QCoo.u) annotation (Line(points={{174,10},{178,10},{178,
          -70},{-130,-70},{-130,-50},{-122,-50}},   color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-19,-44},
          {-10,-44},{-10,2},{-2,2}}, color={0,0,127}));
  connect(TSetCoo.y[1], add1.u1) annotation (Line(points={{101,80},{108,80},{
          108,16},{116,16}}, color={0,0,127}));
  connect(TSetUp.y, add1.u2) annotation (Line(points={{102,10},{108,10},{108,4},
          {116,4}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStart.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation models for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>.
</p>
<p>
Two models are included to validate two different types of systems: space heating
and cooling.
</p>
<p>
In the heating case, the heating system has a very large heating capacity,
with a heat injection that is large enough to increase the zone temperature to
heating setpoint in a short period. The optimal start block therefore outputs
a very small optimal start time <code>tOpt</code> after the three initialization days.
</p>
<p>
In the cooling case, the capacity of the cooling system is not big enough to cool
down the space as quick as in the heating case. The optimal start time
remains relatively stable because the outdoor condition is the same every day and
the indoor condition slightly varies each day.
</p>
<p>
Another difference between the heating and cooling cases is the thermal capacitance
of their serving zone. This parameter also impacts the temperature change rate of
a zone. The heating zone has a higher thermal capacitance than the cooling zone; however,
the difference between the heating and cooling power plays a dominant row than the difference
of thermal capacitance in these two test cases.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{200,
            160}})));
end OptimalStartCooling;
