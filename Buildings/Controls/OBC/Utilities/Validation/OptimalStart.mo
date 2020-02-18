within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStart "Validation model for the block OptimalStart"

  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(
    computeHeating=true, computeCooling=false)
    "Optimal start for heating system"
    annotation (Placement(transformation(extent={{6,80},{26,100}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.000005, y_start=21 +
        273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-34,80},{-14,100}})));
  CDL.Continuous.Sources.Constant TSetHeaOcc(k=21 + 273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-34,130},{-14,150}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19}, period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  CDL.Continuous.Gain UA(k=10)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-114,80},{-94,100}})));
  CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-154,80},{-134,100}})));
  CDL.Continuous.Add dTdt "Temperature derivative"
    annotation (Placement(transformation(extent={{-74,80},{-54,100}})));
  CDL.Continuous.Gain QHea(k=1000) "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-114,40},{-94,60}})));
  CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{46,80},{66,100}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(
    computeHeating=false,computeCooling=true)
    "Optimal start for cooling system"
    annotation (Placement(transformation(extent={{6,-60},{26,-40}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=0.000005,   y_start=24 +
        273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-34,-60},{-14,-40}})));
  CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-34,-120},{-14,-100}})));
  CDL.Continuous.Sources.Sine TOutCoo(
    amplitude=5,
    freqHz=1/86400,
    offset=28 + 273.15,
    startTime(displayUnit="h") = 0)
    "Outdoor dry bulb temperature to test cooling system"
    annotation (Placement(transformation(extent={{-194,-80},{-174,-60}})));
  CDL.Continuous.Gain UA1(k=10)   "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-114,-60},{-94,-40}})));
  CDL.Continuous.Add dT1(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-154,-60},{-134,-40}})));
  CDL.Continuous.Add dTdt1 "Temperature derivative"
    annotation (Placement(transformation(extent={{-74,-60},{-54,-40}})));
  CDL.Continuous.Gain QCoo(k=-800)  "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-114,-100},{-94,-80}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{46,-60},{66,-40}})));
  CDL.Continuous.Sources.Sine TOutHea(
    amplitude=10,
    freqHz=1/86400,
    phase=3.1415926535898,
    offset=10 + 273.15,
    startTime(displayUnit="h") = 0)
    "Outdoor dry bulb temperature to test heating system"
    annotation (Placement(transformation(extent={{-194,60},{-174,80}})));
  CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti(displayUnit="s") = 1,
    yMax=1,
    yMin=0) annotation (Placement(transformation(extent={{158,80},{178,100}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[0,15 + 273.15; 7*3600,21 + 273.15; 19*3600,15 + 273.15; 24*3600,15
         + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{86,130},{106,150}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{124,80},{144,100}})));
  CDL.Continuous.Gain TSetBac(k=6)
    "Heating setpoint temperature setback in the unoccupied period"
    annotation (Placement(transformation(extent={{86,80},{106,100}})));
  CDL.Continuous.Gain TSetUp(k=-6)
    "Cooling setpoint temperature setup during unoccupied period"
    annotation (Placement(transformation(extent={{86,-60},{106,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[0,30 + 273.15; 7*3600,24 + 273.15; 19*3600,30 + 273.15; 24*3600,30
         + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{86,-120},{106,-100}})));
  CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{124,-60},{144,-40}})));
  CDL.Continuous.LimPID conPID1(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti(displayUnit="s") = 2,
    yMax=1,
    yMin=0,
    reverseAction=true)
            annotation (Placement(transformation(extent={{158,-60},{178,-40}})));
equation
  connect(dT.y, UA.u)    annotation (Line(points={{-132,90},{-116,90}},
                                                                      color={0,0,127}));
  connect(dTdt.y, integrator.u)   annotation (Line(points={{-52,90},{-36,90}},color={0,0,127}));
  connect(QHea.y, dTdt.u2) annotation (Line(points={{-92,50},{-82,50},{-82,84},
          {-76,84}}, color={0,0,127}));
  connect(integrator.y, optStaHea.TZon) annotation (Line(points={{-13,90},{-6,
          90},{-6,87},{4,87}},
                            color={0,0,127}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-13,56},
          {-2,56},{-2,82},{4,82}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optStaHea.TSetZonHea) annotation (Line(points={{-12,140},
          {-2,140},{-2,98},{4,98}},  color={0,0,127}));
  connect(integrator.y, dT.u1) annotation (Line(points={{-13,90},{-6,90},{-6,
          112},{-160,112},{-160,96},{-156,96}},
                                           color={0,0,127}));
  connect(dT1.y, UA1.u)   annotation (Line(points={{-132,-50},{-116,-50}},
                                                                         color={0,0,127}));
  connect(TOutCoo.y, dT1.u2) annotation (Line(points={{-172,-70},{-160,-70},{
          -160,-56},{-156,-56}},
                            color={0,0,127}));
  connect(dTdt1.y, integrator1.u)   annotation (Line(points={{-52,-50},{-36,-50}},color={0,0,127}));
  connect(QCoo.y, dTdt1.u2) annotation (Line(points={{-92,-90},{-82,-90},{-82,
          -56},{-76,-56}}, color={0,0,127}));
  connect(integrator1.y, optStaCoo.TZon) annotation (Line(points={{-13,-50},{-8,
          -50},{-8,-54},{-2,-54},{-2,-53},{4,-53}},
                                   color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-13,56},
          {-2,56},{-2,-58},{4,-58}}, color={0,0,127}));
  connect(integrator1.y, dT1.u1) annotation (Line(points={{-13,-50},{-8,-50},{
          -8,-24},{-160,-24},{-160,-44},{-156,-44}},
                                                  color={0,0,127}));
  connect(TSetCooOcc.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-12,
          -110},{0,-110},{0,-47},{4,-47}},
                                        color={0,0,127}));
  connect(TOutHea.y, dT.u2) annotation (Line(points={{-172,70},{-160,70},{-160,
          84},{-156,84}}, color={0,0,127}));
  connect(UA.y, dTdt.u1) annotation (Line(points={{-92,90},{-84,90},{-84,96},{
          -76,96}}, color={0,0,127}));
  connect(UA1.y, dTdt1.u1) annotation (Line(points={{-92,-50},{-84,-50},{-84,
          -44},{-76,-44}}, color={0,0,127}));
  connect(booToRea.y, TSetBac.u)
    annotation (Line(points={{68,90},{84,90}}, color={0,0,127}));
  connect(add2.y, conPID.u_s)
    annotation (Line(points={{146,90},{156,90}}, color={0,0,127}));
  connect(conPID.y, QHea.u) annotation (Line(points={{180,90},{186,90},{186,30},
          {-122,30},{-122,50},{-116,50}}, color={0,0,127}));
  connect(integrator.y, conPID.u_m) annotation (Line(points={{-13,90},{-6,90},{
          -6,64},{168,64},{168,78}}, color={0,0,127}));
  connect(TSetBac.y, add2.u2) annotation (Line(points={{108,90},{112,90},{112,84},
          {122,84}}, color={0,0,127}));
  connect(TSetRooHea.y[1], add2.u1) annotation (Line(points={{107,140},{116,140},
          {116,96},{122,96}}, color={0,0,127}));
  connect(optStaHea.optOn, booToRea.u) annotation (Line(points={{28,86},{36,86},
          {36,90},{44,90}}, color={255,0,255}));
  connect(optStaCoo.optOn, booToRea1.u) annotation (Line(points={{28,-54},{36,
          -54},{36,-50},{44,-50}}, color={255,0,255}));
  connect(booToRea1.y, TSetUp.u)
    annotation (Line(points={{68,-50},{84,-50}}, color={0,0,127}));
  connect(TSetUp.y, add1.u1) annotation (Line(points={{108,-50},{116,-50},{116,-44},
          {122,-44}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], add1.u2) annotation (Line(points={{107,-110},{118,-110},
          {118,-56},{122,-56}}, color={0,0,127}));
  connect(add1.y, conPID1.u_s)
    annotation (Line(points={{146,-50},{156,-50}}, color={0,0,127}));
  connect(integrator1.y, conPID1.u_m) annotation (Line(points={{-13,-50},{-8,
          -50},{-8,-80},{168,-80},{168,-62}}, color={0,0,127}));
  connect(conPID1.y, QCoo.u) annotation (Line(points={{180,-50},{184,-50},{184,
          -130},{-124,-130},{-124,-90},{-116,-90}}, color={0,0,127}));
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
            160}}),
        graphics={
        Rectangle(
          extent={{-196,156},{196,14}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-194,146},{-130,118}},
          lineColor={255,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Tests space heating"),
        Rectangle(
          extent={{-196,-12},{196,-154}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-190,-126},{-126,-154}},
          lineColor={255,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Tests space cooling")}));
end OptimalStart;
