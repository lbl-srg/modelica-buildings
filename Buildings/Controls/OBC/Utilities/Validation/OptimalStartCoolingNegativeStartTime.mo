within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartCoolingNegativeStartTime
  "Validation model for the block OptimalStart for cooling system with a negative start time"
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(
    computeHeating=false,
    computeCooling=true)
    "Optimal start for cooling system"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Continuous.Integrator TRoo(
    k=0.0000005,
    y_start=24+273.15)
    "Room air temperature"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCooOcc(
    k=24+273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=5,
    freqHz=1/86400,
    offset=28+273.15,
    startTime(
      displayUnit="s")=-691200)
    "Outdoor dry bulb temperature to test cooling system"
    annotation (Placement(transformation(extent={{-194,50},{-174,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter UA(k=100)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Add dTdt
    "Temperature derivative"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter QCoo(k=-2000)
    "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    realTrue=-6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Add add
    "Reset setpoint from unoccupied to occupied during optimal start period"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=1,
    reverseActing=false)
    "PI control signal for the cooling power"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{7,19},
    period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSetCoo(
    realTrue=273.15+24,
    realFalse=273.15+30,
    y(final unit="K",
      displayUnit="degC"))
    "Room temperature set point for cooling"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(dT.y,UA.u)
    annotation (Line(points={{-138,10},{-122,10}},color={0,0,127}));
  connect(dTdt.y,TRoo.u)
    annotation (Line(points={{-58,10},{-42,10}},color={0,0,127}));
  connect(QCoo.y,dTdt.u2)
    annotation (Line(points={{-98,-50},{-88,-50},{-88,4},{-82,4}},color={0,0,127}));
  connect(TRoo.y,optStaCoo.TZon)
    annotation (Line(points={{-19,10},{-8,10},{-8,6},{18,6}},color={0,0,127}));
  connect(TSetCooOcc.y,optStaCoo.TSetZonCoo)
    annotation (Line(points={{-18,80},{0,80},{0,14},{18,14}},color={0,0,127}));
  connect(UA.y,dTdt.u1)
    annotation (Line(points={{-98,10},{-90,10},{-90,16},{-82,16}},color={0,0,127}));
  connect(optStaCoo.optOn,booToRea.u)
    annotation (Line(points={{42,6},{50,6},{50,10},{58,10}},color={255,0,255}));
  connect(add.y,conPID.u_s)
    annotation (Line(points={{142,10},{158,10}},color={0,0,127}));
  connect(TRoo.y,conPID.u_m)
    annotation (Line(points={{-19,10},{-14,10},{-14,-20},{170,-20},{170,-2}},color={0,0,127}));
  connect(occSch.tNexOcc,optStaCoo.tNexOcc)
    annotation (Line(points={{-19,-44},{0,-44},{0,2},{18,2}},color={0,0,127}));
  connect(conPID.y,QCoo.u)
    annotation (Line(points={{182,10},{188,10},{188,-80},{-130,-80},{-130,-50},{-122,-50}},color={0,0,127}));
  connect(occSch.occupied,TSetCoo.u)
    annotation (Line(points={{-19,-56},{10,-56},{10,-50},{58,-50}},color={255,0,255}));
  connect(TSetCoo.y,add.u2)
    annotation (Line(points={{82,-50},{110,-50},{110,4},{118,4}},color={0,0,127}));
  connect(booToRea.y,add.u1)
    annotation (Line(points={{82,10},{86,10},{86,16},{118,16}},color={0,0,127}));
  connect(TRoo.y, dT.u2)
    annotation (Line(points={{-19,10},{-14,10},{-14,-20},{-166,-20},{-166,4},{-162,4}},
      color={0,0,127}));
  connect(TOut.y, dT.u1)
    annotation (Line(points={{-172,60},{-166,60},{-166,16},{-162,16}}, color={0,0,127}));

  annotation (
    experiment(
      StartTime=-660000,
      StopTime=0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartCoolingNegativeStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model is to validate the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> for space cooling system with
a negative simulation start time.
</p>
<p>
The room is modeled as a simple differential equation with a time constant of
around 5.6 hours. The cooling power is relatively large compared to the heat gain from
the outdoor temperature. The outdoor temperature is repetitive each day;
the optimal start time converges to a small amount of time <code>tOpt</code> after a few days.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 19, 2020, by Michael Wetter:<br/>
Simplified setpoint implementation.'
</li>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-160},{200,160}})));
end OptimalStartCoolingNegativeStartTime;
