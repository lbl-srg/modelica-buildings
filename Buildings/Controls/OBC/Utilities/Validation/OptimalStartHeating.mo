within Buildings.Controls.OBC.Utilities.Validation;
model OptimalStartHeating
  "Validation model for the block OptimalStart for heating system"

  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(
    computeHeating=true, computeCooling=false)
    "Optimal start for heating system"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.000005,y_start=21+273.15)
    "Integrate temperature derivative with k indicating the inverse of zone thermal capacitance"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaOcc(k=21+273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{7,19},period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain UA(k=10)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dT(k1=-1)
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTdt "Temperature derivative"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain QHea(k=500)  "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=10,
    freqHz=1/86400,
    phase=3.1415926535898,
    offset=10 + 273.15,
    startTime(displayUnit="d") = -172800)
    "Outdoor dry bulb temperature to test heating system"
    annotation (Placement(transformation(extent={{-192,-20},{-172,0}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=1.5,
    yMax=1,
    yMin=0) "PI control for space heating"
            annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetHea(
    table=[0,15 + 273.15; 7*3600,21 + 273.15; 19*3600,15 + 273.15; 24*3600,15
         + 273.15],
    y(unit="K"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime(displayUnit="d") = -172800)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain TSetBac(k=6)
    "Heating setpoint temperature setback in the unoccupied period"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
equation
  connect(dT.y, UA.u)    annotation (Line(points={{-138,10},{-122,10}},
                                                                      color={0,0,127}));
  connect(dTdt.y, integrator.u)   annotation (Line(points={{-58,10},{-42,10}},color={0,0,127}));
  connect(QHea.y, dTdt.u2) annotation (Line(points={{-98,-50},{-88,-50},{-88,4},
          {-82,4}},  color={0,0,127}));
  connect(integrator.y, optStaHea.TZon) annotation (Line(points={{-19,10},{-12,
          10},{-12,7},{-2,7}},
                            color={0,0,127}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-19,-44},
          {-8,-44},{-8,2},{-2,2}}, color={0,0,127}));
  connect(TSetHeaOcc.y, optStaHea.TSetZonHea) annotation (Line(points={{-18,80},
          {-8,80},{-8,18},{-2,18}},  color={0,0,127}));
  connect(integrator.y, dT.u1) annotation (Line(points={{-19,10},{-12,10},{-12,
          32},{-166,32},{-166,16},{-162,16}},
                                           color={0,0,127}));
  connect(UA.y, dTdt.u1) annotation (Line(points={{-98,10},{-90,10},{-90,16},{
          -82,16}}, color={0,0,127}));
  connect(booToRea.y, TSetBac.u)   annotation (Line(points={{62,10},{78,10}}, color={0,0,127}));
  connect(add.y, conPID.u_s)   annotation (Line(points={{142,10},{158,10}}, color={0,0,127}));
  connect(conPID.y, QHea.u) annotation (Line(points={{182,10},{184,10},{184,-70},
          {-126,-70},{-126,-50},{-122,-50}},
                                          color={0,0,127}));
  connect(integrator.y, conPID.u_m) annotation (Line(points={{-19,10},{-12,10},
          {-12,-16},{170,-16},{170,-2}},
                                     color={0,0,127}));
  connect(TSetBac.y, add.u2) annotation (Line(points={{102,10},{106,10},{106,4},
          {118,4}}, color={0,0,127}));
  connect(TSetHea.y[1], add.u1) annotation (Line(points={{101,80},{110,80},{110,
          16},{118,16}}, color={0,0,127}));
  connect(optStaHea.optOn, booToRea.u) annotation (Line(points={{22,6},{30,6},{
          30,10},{38,10}},  color={255,0,255}));
  connect(TOut.y, dT.u2) annotation (Line(points={{-170,-10},{-166,-10},{-166,4},
          {-162,4}}, color={0,0,127}));
  annotation (
  experiment(
      StartTime=-172800,
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartHeating.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model is to validate the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> for space heating system.
</p>
<p>
The room is modelled as a simple differential equation with a time constant of 
around 5.6 hours, which is the same as the cooling case 
<a href=\"modelica://Buildings.Controls.OBC.Utilities.Validation.OptimalStartCooling\">
Buildings.Controls.OBC.Utilities.Validation.OptimalStartCooling</a>. 
The outdoor temperature is also repetitive each day; 
the optimal start time converges to a small amount of time <code>tOpt</code> after a few days.
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
end OptimalStartHeating;
