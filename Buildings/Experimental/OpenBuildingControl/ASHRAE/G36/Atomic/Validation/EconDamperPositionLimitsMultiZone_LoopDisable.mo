within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconDamperPositionLimitsMultiZone_LoopDisable
  "Validation model for the multiple zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  parameter Types.FreezeProtectionStage freProStage1 = Types.FreezeProtectionStage.stage1
    "Freeze protection stage 1";
  parameter Types.FreezeProtectionStage freProStage2 = Types.FreezeProtectionStage.stage2
    "Freeze protection stage 2";
  parameter Integer freProStage1Num = Integer(freProStage1)-1
    "Numerical value for freeze protection stage 1";
  parameter Integer freProStage2Num = Integer(freProStage2)-1
    "Numerical value for freeze protection stage 2";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "AHU operation mode is \"Occupied\"";
  parameter Types.OperationMode warmUp = Types.OperationMode.warmUp
    "AHU operation mode is \"Warmup\"";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for AHU operation mode \"Occupied\"";
  parameter Integer warmUpNum = Integer(warmUp)
    "Numerical value for AHU operation mode \"WarmUp\"";
  parameter Real VOutSet_flow(unit="m3/s", quantity="VolumeFlowRate")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real minSenOutVolAirflow(unit="m3/s", quantity="VolumeFlowRate")=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  parameter Real senOutVolAirIncrease(unit="m3/s", quantity="VolumeFlowRate")=0.2
    "Maximum increase in airflow volume during the example simulation";

  // Fan Status
  CDL.Logical.Constant fanStatus(k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  CDL.Integers.Constant freProSta(k=freProStage1Num) "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  CDL.Integers.Constant operationMode(k=occupiedNum) "AHU operation mode is \"Occupied\""
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));

  // Operation Mode
  CDL.Logical.Constant fanStatus1(k=true)  "Fan is on"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Integers.Constant freProSta1(k=freProStage1Num) "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Integers.Constant operationMode1(k=warmUpNum)
    "AHU operation mode is NOT \"Occupied\""
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  // Freeze Protection Stage
  CDL.Logical.Constant fanStatus2(k=true)  "Fan is on"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  CDL.Integers.Constant freProSta2(k=freProStage2Num)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Integers.Constant operationMode2(k=occupiedNum) "AHU operation mode is \"Occupied\""
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Modelica.Blocks.Sources.Ramp VOut_flow(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Modelica.Blocks.Sources.Ramp VOut1_flow(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp VOut2_flow(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  CDL.Continuous.Constant VOutMinSet_flow(k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  CDL.Continuous.Constant VOutMinSet_flow1(k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Continuous.Constant VOutMinSet_flow2(k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  EconDamperPositionLimitsMultiZone ecoDamLim
    "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  EconDamperPositionLimitsMultiZone ecoDamLim1
    "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  EconDamperPositionLimitsMultiZone ecoDamLim2
    "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
      annotation (Placement(transformation(extent={{160,-20},{180,0}})));

equation
  connect(VOut_flow.y, ecoDamLim.VOut_flow) annotation (Line(points={{-179,70},{-140,70},
          {-140,-2},{-121,-2}}, color={0,0,127}));
  connect(VOutMinSet_flow.y, ecoDamLim.VOutMinSet_flow)
    annotation (Line(points={{-179,30},{-150,30},{-150,-5},{-121,-5}}, color={0,0,127}));
  connect(fanStatus.y, ecoDamLim.uSupFan)
    annotation (Line(points={{-179,-10},{-160,-10},{-121,-10}}, color={255,0,255}));
  connect(operationMode.y, ecoDamLim.uOperationMode)
    annotation (Line(points={{-179,-50},{-160,-50},{-160,-28},{-160,-15},{-121,-15}},
    color={255,127,0}));
  connect(freProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-179,-90},{-150,-90},{-150,-18},{-121,-18}}, color={255,127,0}));
  connect(VOut1_flow.y, ecoDamLim1.VOut_flow) annotation (Line(points={{-39,70},{0,70},{
          0,-2},{19,-2}}, color={0,0,127}));
  connect(VOutMinSet_flow1.y, ecoDamLim1.VOutMinSet_flow) annotation (Line(points={{-39,
          30},{-10,30},{-10,-5},{19,-5}}, color={0,0,127}));
  connect(fanStatus1.y, ecoDamLim1.uSupFan) annotation (Line(points={{-39,-10},
          {-20,-10},{19,-10}}, color={255,0,255}));
  connect(operationMode1.y, ecoDamLim1.uOperationMode) annotation (Line(points={{-39,-50},{
          -20,-50},{-20,-28},{-20,-15},{19,-15}}, color={255,127,0}));
  connect(freProSta1.y, ecoDamLim1.uFreProSta) annotation (Line(points={{-39,
          -90},{-10,-90},{-10,-18},{19,-18}}, color={255,127,0}));
  connect(VOut2_flow.y, ecoDamLim2.VOut_flow) annotation (Line(points={{101,70},{140,70},
          {140,-2},{159,-2}}, color={0,0,127}));
  connect(VOutMinSet_flow2.y, ecoDamLim2.VOutMinSet_flow) annotation (Line(points={{101,
          30},{130,30},{130,-5},{159,-5}}, color={0,0,127}));
  connect(fanStatus2.y, ecoDamLim2.uSupFan) annotation (Line(points={{101,-10},
          {120,-10},{159,-10}}, color={255,0,255}));
  connect(operationMode2.y, ecoDamLim2.uOperationMode) annotation (Line(points={{101,-50},{
          120,-50},{120,-28},{120,-15},{159,-15}}, color={255,127,0}));
  connect(freProSta2.y, ecoDamLim2.uFreProSta) annotation (Line(points={{101,
          -90},{130,-90},{130,-18},{159,-18}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsMultiZone_LoopDisable.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{
            220,120}}), graphics={
        Text(
          extent={{-200,110},{-166,98}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Fan is off"),
        Text(
          extent={{-60,114},{68,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Operation mode is other than \"Occupied\""),
        Text(
          extent={{80,114},{208,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Freeze protection status is higher than 1")}),
    Documentation(info="<html>
  <p>
  This example validates enable/disable conditions for
  <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a>
  for the following input signals: <code>uSupFan</code>, <code>uFreProSta</code>, <code>uOperationMode</code>.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  June 06, 2017, by Milica Grahovac:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end EconDamperPositionLimitsMultiZone_LoopDisable;
