within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartHeatingCooling
  "Validation model for the block OptimalStart for both heating and cooling system"

  Buildings.Controls.OBC.Utilities.OptimalStart optSta(computeHeating=false,
      computeCooling=false) "Optimal start for both heating and cooling system"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=0.00000005, y_start=22.5
         + 273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  CDL.Continuous.Sources.Sine TOut(
    amplitude=30,
    freqHz=1/172800,
    offset=22.5 + 273.15,
    startTime(displayUnit="h") = 0) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-194,-20},{-174,0}})));
  CDL.Continuous.Gain UA1(k=100)  "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Continuous.Add dT1(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Continuous.Gain QCoo(k=-8000) "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Continuous.Gain TSetUp(k=-6)
    "Cooling setpoint temperature setup during unoccupied period"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetCoo(
    table=[0,30 + 273.15; 7*3600,24 + 273.15; 19*3600,30 + 273.15; 24*3600,30
         + 273.15],
    y(unit="K"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  CDL.Continuous.LimPID conPID1(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti(displayUnit="s") = 2,
    yMax=1,
    yMin=0,
    reverseAction=true)
            annotation (Placement(transformation(extent={{160,0},{180,20}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19}, period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Continuous.MultiSum mulSum(nin=3)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Sources.Constant TSetHeaOcc(k=21 + 273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Conversions.BooleanToReal booToRea2 "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CDL.Continuous.Gain TSetBak(k=6)
    "Heating setpoint temperature set back during unoccupied period"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti(displayUnit="s") = 1,
    yMax=1,
    yMin=0) annotation (Placement(transformation(extent={{160,40},{180,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetHea(
    table=[0,15 + 273.15; 7*3600,21 + 273.15; 19*3600,15 + 273.15; 24*3600,15
         + 273.15],
    y(unit="K"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  CDL.Continuous.Gain QHea(k=8000) "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
equation
  connect(dT1.y, UA1.u)   annotation (Line(points={{-138,10},{-122,10}}, color={0,0,127}));
  connect(TOut.y, dT1.u2) annotation (Line(points={{-172,-10},{-166,-10},{-166,4},
          {-162,4}}, color={0,0,127}));
  connect(integrator1.y, optSta.TZon) annotation (Line(points={{-19,10},{-10,10},
          {-10,7},{-2,7}}, color={0,0,127}));
  connect(integrator1.y, dT1.u1) annotation (Line(points={{-19,10},{-14,10},{-14,
          34},{-166,34},{-166,16},{-162,16}},     color={0,0,127}));
  connect(TSetCooOcc.y, optSta.TSetZonCoo) annotation (Line(points={{-18,70},{-10,
          70},{-10,13},{-2,13}}, color={0,0,127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{22,6},{30,6},{30,
          10},{38,10}}, color={255,0,255}));
  connect(booToRea1.y, TSetUp.u)   annotation (Line(points={{62,10},{78,10}},   color={0,0,127}));
  connect(TSetUp.y, add1.u1) annotation (Line(points={{102,10},{112,10},{112,16},
          {118,16}},  color={0,0,127}));
  connect(TSetCoo.y[1], add1.u2) annotation (Line(points={{101,-50},{114,-50},{
          114,4},{118,4}}, color={0,0,127}));
  connect(add1.y, conPID1.u_s)   annotation (Line(points={{142,10},{158,10}},   color={0,0,127}));
  connect(integrator1.y, conPID1.u_m) annotation (Line(points={{-19,10},{-14,10},
          {-14,-20},{170,-20},{170,-2}},      color={0,0,127}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{-19,-44},{-10,
          -44},{-10,2},{-2,2}}, color={0,0,127}));
  connect(UA1.y, mulSum.u[1]) annotation (Line(points={{-98,10},{-90,10},{-90,
          11.3333},{-82,11.3333}},
                          color={0,0,127}));
  connect(integrator1.u, mulSum.y)    annotation (Line(points={{-42,10},{-58,10}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optSta.TSetZonHea) annotation (Line(points={{-18,110},{-6,
          110},{-6,18},{-2,18}}, color={0,0,127}));
  connect(optSta.optOn, booToRea2.u) annotation (Line(points={{22,6},{30,6},{30,
          50},{38,50}}, color={255,0,255}));
  connect(booToRea2.y, TSetBak.u)   annotation (Line(points={{62,50},{78,50}}, color={0,0,127}));
  connect(TSetHea.y[1], add2.u1) annotation (Line(points={{101,90},{110,90},{
          110,56},{118,56}}, color={0,0,127}));
  connect(TSetBak.y, add2.u2) annotation (Line(points={{102,50},{108,50},{108,44},
          {118,44}}, color={0,0,127}));
  connect(add2.y, conPID.u_s)   annotation (Line(points={{142,50},{158,50}}, color={0,0,127}));
  connect(conPID.u_m, dT1.u1) annotation (Line(points={{170,38},{170,34},{-166,34},
          {-166,16},{-162,16}}, color={0,0,127}));
  connect(conPID1.y, QCoo.u) annotation (Line(points={{182,10},{190,10},{190,-64},
          {-130,-64},{-130,-30},{-122,-30}}, color={0,0,127}));
  connect(conPID.y, QHea.u) annotation (Line(points={{182,50},{192,50},{192,-108},
          {-128,-108},{-128,-90},{-122,-90}}, color={0,0,127}));
  connect(QCoo.y, mulSum.u[2]) annotation (Line(points={{-98,-30},{-90,-30},{-90,
          10},{-82,10}}, color={0,0,127}));
  connect(QHea.y, mulSum.u[3]) annotation (Line(points={{-98,-90},{-88,-90},{-88,
          8.66667},{-82,8.66667}}, color={0,0,127}));
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
end OptimalStartHeatingCooling;
