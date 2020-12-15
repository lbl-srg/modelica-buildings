within Buildings.Examples.BoilerPlant.PlantModel.Validation;
model BoilerPlant
    "Validation for boiler plant model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water
    "Medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";

  Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant boilerPlant(
    final TRadRet_nominal=273.15 + 50)
    "Boiler plant model"
    annotation (Placement(transformation(extent={{-50,-12},{-30,12}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2))
    "Pump enable status"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=0)
    "Bypass valve position"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=273.15 + 60,
    final uHigh=273.15 + 70)
    "Turn on boiler plants when hot water supply temperature falls below setpoint"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=2)
    "Real replicator"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=-Q_flow_nominal)
    "Internal heat gain of thermal zone"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=273.15 + 21.7,
    final uHigh=273.15 + 23.89)
    "Turn on hot water pumps when the zone temperature falls below the heating setpoint"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Enable boiler plant only when pumps are enabled"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=273.15 + 21)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));

equation
  connect(con.y, boilerPlant.uPumSta) annotation (Line(points={{-88,0},{-80,0},{
          -80,2},{-52,2}},      color={255,0,255}));

  connect(con2.y, boilerPlant.uBypValSig) annotation (Line(points={{-88,-40},{-80,
          -40},{-80,-4},{-52,-4}},  color={0,0,127}));

  connect(hys.y, not1.u)
    annotation (Line(points={{12,20},{18,20}},     color={255,0,255}));

  connect(booRep.y, boilerPlant.uBoiSta) annotation (Line(points={{102,20},{110,
          20},{110,40},{-60,40},{-60,8},{-52,8}},            color={255,0,255}));

  connect(booToRea.y, reaRep.u)
    annotation (Line(points={{72,-20},{78,-20}},   color={0,0,127}));

  connect(reaRep.y, boilerPlant.uHotIsoVal) annotation (Line(points={{102,-20},{
          110,-20},{110,-40},{-70,-40},{-70,5},{-52,5}},
                                                    color={0,0,127}));

  connect(reaRep.y, boilerPlant.uPumSpe) annotation (Line(points={{102,-20},{110,
          -20},{110,-40},{-70,-40},{-70,-1},{-52,-1}},
                                                   color={0,0,127}));

  connect(con1.y, boilerPlant.QRooInt_flowrate) annotation (Line(points={{-88,40},
          {-70,40},{-70,11},{-52,11}},        color={0,0,127}));

  connect(boilerPlant.ySupTem, hys.u) annotation (Line(points={{-28,4},{-20,4},{
          -20,20},{-12,20}},    color={0,0,127}));

  connect(boilerPlant.yZonTem, hys1.u) annotation (Line(points={{-28,8},{-24,8},
          {-24,-20},{-12,-20}},     color={0,0,127}));

  connect(hys1.y, not2.u)
    annotation (Line(points={{12,-20},{18,-20}},   color={255,0,255}));

  connect(not2.y, booToRea.u)
    annotation (Line(points={{42,-20},{48,-20}},   color={255,0,255}));

  connect(booRep.u, and2.y)
    annotation (Line(points={{78,20},{72,20}},     color={255,0,255}));

  connect(not1.y, and2.u1)
    annotation (Line(points={{42,20},{48,20}},     color={255,0,255}));

  connect(not2.y, and2.u2) annotation (Line(points={{42,-20},{46,-20},{46,12},{
          48,12}},    color={255,0,255}));

  connect(booToRea.y, boilerPlant.uRadIsoVal) annotation (Line(points={{72,-20},
          {76,-20},{76,-50},{-60,-50},{-60,-7},{-52,-7}},   color={0,0,127}));

  connect(con3.y, boilerPlant.TOutAir) annotation (Line(points={{-88,-80},{-76,-80},
          {-76,-10},{-52,-10}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant\">
Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant</a>.
The model uses simple hysteresis loops to activate the hot water pumps and the
boilers in the plant.
</p>
<ul>
<li>
The pumps are activated when the zone temperature falls below the heating setpoint.
</li>
<li>
The boilers are activated when the hot water supply temperature falls below the supply
temperature setpoint.
</li>
</ul>
<p>
The model checks for whether the plant responds to the corresponding activation
signals and the effect on the various measured values.
</p>
</html>", revisions="<html>
<ul>
<li>
December 15, 2020, by Karthik Devaprasad:<br/>
First implementation.<br/>
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-120},{120,
            120}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlant/PlantModel/Validation/BoilerPlant.mos"
        "Simulate and plot"),
    experiment(
      StopTime=30000,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BoilerPlant;
