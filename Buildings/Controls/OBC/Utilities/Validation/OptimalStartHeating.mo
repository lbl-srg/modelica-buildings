within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartHeating
  "Validation model for the block OptimalStart for heating system"
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(
    computeHeating=true,
    computeCooling=false)
    "Optimal start for heating system"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Continuous.Integrator TRoo(
    k=0.000005,
    y_start=21+273.15)
    "Room air temperature"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaOcc(
    k=21+273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{7,19},
    period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain UA(
    k=10)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dT(
    k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTdt
    "Temperature derivative"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QHea(
    k=500)
    "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    realTrue=6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=10,
    freqHz=1/86400,
    phase=3.1415926535898,
    offset=10+273.15,
    startTime(
      displayUnit="d")=-172800)
    "Outdoor dry bulb temperature to test heating system"
    annotation (Placement(transformation(extent={{-192,-20},{-172,0}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=1.5)
    "PI control for space heating"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSetHea(
    realTrue=273.15+21,
    realFalse=273.15+15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Room temperature set point for heating"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(dT.y,UA.u)
    annotation (Line(points={{-138,10},{-122,10}},color={0,0,127}));
  connect(dTdt.y,TRoo.u)
    annotation (Line(points={{-58,10},{-42,10}},color={0,0,127}));
  connect(QHea.y,dTdt.u2)
    annotation (Line(points={{-98,-50},{-88,-50},{-88,4},{-82,4}},color={0,0,127}));
  connect(TRoo.y,optStaHea.TZon)
    annotation (Line(points={{-19,10},{-12,10},{-12,7},{18,7}},color={0,0,127}));
  connect(occSch.tNexOcc,optStaHea.tNexOcc)
    annotation (Line(points={{-19,-44},{0,-44},{0,2},{18,2}},color={0,0,127}));
  connect(TSetHeaOcc.y,optStaHea.TSetZonHea)
    annotation (Line(points={{-18,80},{0,80},{0,18},{18,18}},color={0,0,127}));
  connect(TRoo.y,dT.u1)
    annotation (Line(points={{-19,10},{-12,10},{-12,32},{-166,32},{-166,16},{-162,16}},color={0,0,127}));
  connect(UA.y,dTdt.u1)
    annotation (Line(points={{-98,10},{-90,10},{-90,16},{-82,16}},color={0,0,127}));
  connect(add.y,conPID.u_s)
    annotation (Line(points={{142,10},{158,10}},color={0,0,127}));
  connect(conPID.y,QHea.u)
    annotation (Line(points={{182,10},{184,10},{184,-70},{-126,-70},{-126,-50},{-122,-50}},color={0,0,127}));
  connect(TRoo.y,conPID.u_m)
    annotation (Line(points={{-19,10},{-12,10},{-12,-16},{170,-16},{170,-2}},color={0,0,127}));
  connect(optStaHea.optOn,booToRea.u)
    annotation (Line(points={{42,6},{50,6},{50,10},{58,10}},color={255,0,255}));
  connect(TOut.y,dT.u2)
    annotation (Line(points={{-170,-10},{-166,-10},{-166,4},{-162,4}},color={0,0,127}));
  connect(TSetHea.u,occSch.occupied)
    annotation (Line(points={{58,-50},{10,-50},{10,-56},{-19,-56}},color={255,0,255}));
  connect(TSetHea.y,add.u2)
    annotation (Line(points={{82,-50},{104,-50},{104,4},{118,4}},color={0,0,127}));
  connect(booToRea.y,add.u1)
    annotation (Line(points={{82,10},{104,10},{104,16},{118,16}},color={0,0,127}));
  annotation (
    experiment(
      StartTime=-172800,
      StopTime=604800,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartHeating.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model is to validate the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> for space heating system.
</p>
<p>
The room is modeled as a simple differential equation with a time constant of
around 5.6 hours.
The outdoor temperature is also repetitive each day;
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
end OptimalStartHeating;
