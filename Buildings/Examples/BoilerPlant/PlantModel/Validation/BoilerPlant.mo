within Buildings.Examples.BoilerPlant.PlantModel.Validation;
model BoilerPlant
    "Validation for boiler plant model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";

  Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant boilerPlant(
    final boiCap1=60000,
    final boiCap2=60000,
    final TRadRet_nominal=273.15 + 50)
    "Boiler plant model"
    annotation (Placement(transformation(extent={{-50,-12},{-30,8}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[1](
    final k=fill(true, 1))
    "Boiler availability signal"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=0)
    "Bypass valve position signal"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=273.15 + 60,
    final uHigh=273.15 + 70)
    "Check if hot water supply temperature is at setpoint"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real converter"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2)
    "Real replicator"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=-Q_flow_nominal)
    "Thermal load on zone"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=273.15 + 21.7,
    final uHigh=273.15 + 23.89)
    "Check if zone temperature is at setpoint"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Enable boilers only if supply temperature is below setpoint and pumps are on"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=273.15 + 21)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 70)
    "Boiler hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=2)
    "Real replicator"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

equation
  connect(con.y, boilerPlant.uPumSta) annotation (Line(points={{-88,20},{-80,20},
          {-80,1},{-52,1}},     color={255,0,255}));

  connect(con2.y, boilerPlant.uBypValSig) annotation (Line(points={{-88,-20},{
          -80,-20},{-80,-5},{-52,-5}},
                                    color={0,0,127}));

  connect(hys.y, not1.u)
    annotation (Line(points={{12,20},{18,20}},     color={255,0,255}));

  connect(booRep.y, boilerPlant.uBoiSta) annotation (Line(points={{102,20},{110,
          20},{110,40},{-60,40},{-60,7},{-52,7}},            color={255,0,255}));

  connect(booToRea.y, reaRep.u)
    annotation (Line(points={{72,-20},{78,-20}},   color={0,0,127}));

  connect(reaRep.y, boilerPlant.uHotIsoVal) annotation (Line(points={{102,-20},
          {110,-20},{110,-40},{-70,-40},{-70,4},{-52,4}},
                                                    color={0,0,127}));

  connect(con1.y, boilerPlant.QRooInt_flowrate) annotation (Line(points={{-88,60},
          {-70,60},{-70,10},{-52,10}},        color={0,0,127}));

  connect(boilerPlant.ySupTem, hys.u) annotation (Line(points={{-28,4},{-20,4},
          {-20,20},{-12,20}},   color={0,0,127}));

  connect(boilerPlant.yZonTem, hys1.u) annotation (Line(points={{-28,7},{-24,7},
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

  connect(booToRea.y,boilerPlant.uRadConVal)  annotation (Line(points={{72,-20},
          {76,-20},{76,-50},{-60,-50},{-60,-8},{-52,-8}},   color={0,0,127}));

  connect(con3.y, boilerPlant.TOutAir) annotation (Line(points={{-88,-60},{-76,
          -60},{-76,-11},{-52,-11}},
                                color={0,0,127}));

  connect(con4.y, reaScaRep.u)
    annotation (Line(points={{-88,-100},{-82,-100}}, color={0,0,127}));

  connect(reaScaRep.y, boilerPlant.TBoiHotWatSupSet) annotation (Line(points={{
          -58,-100},{-58,-14},{-52,-14}}, color={0,0,127}));

  connect(booToRea.y, boilerPlant.uPumSpe) annotation (Line(points={{72,-20},{
          76,-20},{76,-50},{-60,-50},{-60,-2},{-52,-2}}, color={0,0,127}));

  annotation (Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant\">
      Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      October 13, 2021, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-120},{120,
            120}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlant/PlantModel/Validation/BoilerPlant.mos"
        "Simulate and plot"),
    experiment(
      StopTime=60000,
      Interval=1,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BoilerPlant;
