within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStart "Validation model for the block OptimalStart"

  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(computeHeating=true,
      computeCooling=false)
    annotation (Placement(transformation(extent={{40,76},{60,96}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.00001, y_start=20 +
        273.15)
    "Integrate temperature derivative with k indicates the inverse of thermal capacitance"
    annotation (Placement(transformation(extent={{0,76},{20,96}})));
  CDL.Continuous.Sources.Constant TSetHeaOcc(k=21 + 273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19}, period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{0,36},{20,56}})));
  CDL.Continuous.Gain UA(k=1000)
                                "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-80,76},{-60,96}})));
  CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-120,76},{-100,96}})));
  CDL.Continuous.Add dTdt "Temperature derivative"
    annotation (Placement(transformation(extent={{-40,76},{-20,96}})));
  CDL.Continuous.Gain QHea(k=3500) "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-80,36},{-60,56}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{80,76},{100,96}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{120,76},{140,96}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(computeHeating=false,
      computeCooling=true)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=0.001, y_start=25 +
        273.15)
    "Integrate temperature derivative with k indicates the inverse of thermal capacitance"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Continuous.Sources.Constant TSetCooOcc(k=24 + 273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  CDL.Continuous.Sources.Sine TOut1(
    amplitude=2,
    freqHz=1/86400,
    offset=25 + 273.15,
    startTime(displayUnit="h") = 0) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  CDL.Continuous.Gain UA1(k=1000)
                                "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Add dT1(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.Add dTdt1 "Temperature derivative"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Continuous.Gain QCoo(k=-2500) "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  CDL.Continuous.Sources.Sine TOut(
    amplitude=2,
    freqHz=1/86400,
    phase=3.1415926535898,
    offset=20 + 273.15,
    startTime(displayUnit="h") = 0) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-160,56},{-140,76}})));
equation
  connect(dT.y, UA.u)
    annotation (Line(points={{-98,86},{-82,86}}, color={0,0,127}));
  connect(dTdt.y, integrator.u)
    annotation (Line(points={{-18,86},{-2,86}}, color={0,0,127}));
  connect(optStaHea.optOn, or2.u1) annotation (Line(points={{62,82},{68,82},{68,
          86},{78,86}}, color={255,0,255}));
  connect(or2.y, booToRea.u)
    annotation (Line(points={{102,86},{118,86}}, color={255,0,255}));
  connect(QHea.y, dTdt.u2) annotation (Line(points={{-58,46},{-48,46},{-48,80},
          {-42,80}}, color={0,0,127}));
  connect(integrator.y, optStaHea.TZon) annotation (Line(points={{21,86},{28,86},
          {28,83},{38,83}}, color={0,0,127}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{21,52},{
          30,52},{30,78},{38,78}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optStaHea.TSetZonHea) annotation (Line(points={{2,130},
          {32,130},{32,94},{38,94}}, color={0,0,127}));
  connect(integrator.y, dT.u1) annotation (Line(points={{21,86},{28,86},{28,110},
          {-126,110},{-126,92},{-122,92}}, color={0,0,127}));
  connect(dT1.y, UA1.u)
    annotation (Line(points={{-98,-50},{-82,-50}}, color={0,0,127}));
  connect(TOut1.y, dT1.u2) annotation (Line(points={{-138,-70},{-126,-70},{-126,
          -56},{-122,-56}}, color={0,0,127}));
  connect(dTdt1.y, integrator1.u)
    annotation (Line(points={{-18,-50},{-2,-50}}, color={0,0,127}));
  connect(or1.y, booToRea1.u)
    annotation (Line(points={{102,-50},{118,-50}}, color={255,0,255}));
  connect(QCoo.y, dTdt1.u2) annotation (Line(points={{-58,-90},{-48,-90},{-48,
          -56},{-42,-56}}, color={0,0,127}));
  connect(integrator1.y, optStaCoo.TZon) annotation (Line(points={{21,-50},{28,
          -50},{28,-53},{38,-53}}, color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{21,52},{
          30,52},{30,-58},{38,-58}}, color={0,0,127}));
  connect(integrator1.y, dT1.u1) annotation (Line(points={{21,-50},{28,-50},{28,
          -24},{-126,-24},{-126,-44},{-122,-44}}, color={0,0,127}));
  connect(TSetCooOcc.y, optStaCoo.TSetZonCoo) annotation (Line(points={{2,-130},
          {34,-130},{34,-47},{38,-47}}, color={0,0,127}));
  connect(occSch.occupied, or2.u2) annotation (Line(points={{21,40},{72,40},{72,
          78},{78,78}}, color={255,0,255}));
  connect(optStaCoo.optOn, or1.u2) annotation (Line(points={{62,-54},{68,-54},{
          68,-58},{78,-58}}, color={255,0,255}));
  connect(occSch.occupied, or1.u1) annotation (Line(points={{21,40},{72,40},{72,
          -50},{78,-50}}, color={255,0,255}));
  connect(booToRea.y, QHea.u) annotation (Line(points={{142,86},{152,86},{152,
          22},{-88,22},{-88,46},{-82,46}}, color={0,0,127}));
  connect(booToRea1.y, QCoo.u) annotation (Line(points={{142,-50},{152,-50},{
          152,-108},{-88,-108},{-88,-90},{-82,-90}}, color={0,0,127}));
  connect(TOut.y, dT.u2) annotation (Line(points={{-138,66},{-126,66},{-126,80},
          {-122,80}}, color={0,0,127}));
  connect(UA.y, dTdt.u1) annotation (Line(points={{-58,86},{-50,86},{-50,92},{
          -42,92}}, color={0,0,127}));
  connect(UA1.y, dTdt1.u1) annotation (Line(points={{-58,-50},{-50,-50},{-50,
          -44},{-42,-44}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),             __Dymola_Commands(file=
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
In the heating case, the space heating system has a very large heating capacity,
with a heat injection that is large enough to increase the zone temperature to
heating setpoint in a short amount of time. The optimal start block therefore outputs
a very small time period after a few days, even though it is the same outdoor
condition every day.
</p>
<p>
In the cooling case, the capacity of the cooling system is not big enough to cool
down the space as quick as in the heating case. The optimal start block outputs
remain relatively stable in this test case.
</p>
<p>
Another difference between the heating and cooling cases is the heat capacity
of their serving zone. This parameter also impacts the temperature change rate of
a zone. The heating zone has a higher heat capacity than the cooling zone; however,
the heating/cooling power plays a dominant row in these two test cases.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,
            160}}), graphics={
        Rectangle(
          extent={{-168,152},{164,10}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,-16},{164,-152}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-160,146},{-96,118}},
          lineColor={255,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Tests space heating"),
        Text(
          extent={{-160,-128},{-96,-156}},
          lineColor={255,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Tests space cooling")}));
end OptimalStart;
