within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block EfficiencyCondition
  "Efficiency condition used in staging up and down"

  parameter Integer nSta = 5
    "Number of stages in the boiler plant";

  parameter Real fraNonConBoi(
    final min=0,
    final unit="1",
    displayUnit="1") = 0.9
    "Fraction of design capacity of current stage at which the efficiency condition
    is satisfied for non-condensing boilers";

  parameter Real fraConBoi(
    final min=0,
    final unit="1",
    displayUnit="1") = 1.5
    "Fraction of B-Stage minimum of next higher stage at which the efficiency
    condition is satisfied for condensing boilers";

  parameter Real sigDif(
    final min=0,
    final unit="1",
    final max=1,
    displayUnit="1") = 0.1
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Advanced"));

  parameter Real delCapReq(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating requirement condition";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-160,-200},{-120,-160}}),
      iconTransformation(extent={{-140,70},{-100,110}},
        rotation=90)));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
    "Vector of boiler types for all stages"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp
    "Stage number of next available higher stage"
    annotation (Placement(transformation(extent={{-160,-160},{-120,-120}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Heating capacity required"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDes(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Design heating capacity of current stage"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapUpMin(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Minimum capacity of the next available higher stage"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-water flow-rate"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VUpMinSet_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum flow setpoint for the next available higher stage"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEffCon
    "Efficiency condition for boiler staging"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addParDivZer(
    final p=1e-6)
    "Add small vcalue to input signal to prevent divide by zero"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addParDivZer1(
    final p=1e-6)
    "Add small vcalue to input signal to prevent divide by zero"
    annotation (Placement(transformation(extent={{-112,10},{-92,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Divider to get relative value of required heating capacity"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1e-6)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Divider to get relative value of required heating capacity"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div2
    "Divider to get relative value of flow-rate"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=-sigDif,
    final uHigh=0)
    "Hysteresis loop for flow-rate condition"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    "Constant boolean source"
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=fraNonConBoi - sigDif,
    final uHigh=fraNonConBoi)
    "Hysteresis loop for heating capacity condition of non-condensing boilers"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=fraConBoi - sigDif,
    final uHigh=fraConBoi)
    "Hysteresis loop for heating capacity condition of condensing boilers"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Convert integers in stage-type vector to real data-type"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Pick out stage-type for next stage from vector"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=1)
    "Check for non-condensing boilers"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch for heating capacity condition based on stage type"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Switch for flow-rate condition"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find difference between measurted flowrate and minimum flow setpoint for next higher stage"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=delCapReq)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=delCapReq)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));

equation
  connect(sub1.u1, VHotWat_flow) annotation (Line(points={{-82,-34},{-110,-34},{
          -110,-20},{-140,-20}},  color={0,0,127}));
  connect(sub1.u2, VUpMinSet_flow) annotation (Line(points={{-82,-46},{-110,-46},
          {-110,-60},{-140,-60}}, color={0,0,127}));
  connect(sub1.y, div2.u1)
    annotation (Line(points={{-58,-40},{-50,-40},{-50,-44},{-42,-44}},
      color={0,0,127}));
  connect(div2.y, hys.u)
    annotation (Line(points={{-18,-50},{28,-50}},
      color={0,0,127}));
  connect(div1.y, hys1.u)
    annotation (Line(points={{-58,70},{-42,70}},
      color={0,0,127}));
  connect(div.y, hys2.u)
    annotation (Line(points={{-58,30},{-42,30}},
      color={0,0,127}));
  connect(intToRea.u, uTyp)
    annotation (Line(points={{-82,-100},{-140,-100}},
      color={255,127,0}));
  connect(extIndSig.u, intToRea.y)
    annotation (Line(points={{-42,-100},{-58,-100}},
      color={0,0,127}));
  connect(extIndSig.index, uAvaUp)
    annotation (Line(points={{-30,-112},{-30,-140},{-140,-140}},
      color={255,127,0}));
  connect(greThr.u, extIndSig.y)
    annotation (Line(points={{28,-100},{-18,-100}},
      color={0,0,127}));
  connect(greThr.y, logSwi.u2)
    annotation (Line(points={{52,-100},{92,-100},{92,50},{98,50}},
      color={255,0,255}));
  connect(and2.y, yEffCon)
    annotation (Line(points={{152,0},{180,0}},
      color={255,0,255}));
  connect(logSwi.y, and2.u1)
    annotation (Line(points={{122,50},{126,50},{126,0},{128,0}},
      color={255,0,255}));
  connect(logSwi1.y, and2.u2)
    annotation (Line(points={{122,-30},{126,-30},{126,-8},{128,-8}},
      color={255,0,255}));
  connect(con1.y, logSwi1.u1)
    annotation (Line(points={{52,-10},{80,-10},{80,-22},{98,-22}},
      color={255,0,255}));
  connect(hys.y, logSwi1.u3)
    annotation (Line(points={{52,-50},{80,-50},{80,-38},{98,-38}},
      color={255,0,255}));
  connect(logSwi1.u2, greThr.y)
    annotation (Line(points={{98,-30},{92,-30},{92,-100},{52,-100}},
      color={255,0,255}));
  connect(div.u1, uCapReq) annotation (Line(points={{-82,36},{-100,36},{-100,60},
          {-140,60}}, color={0,0,127}));
  connect(div1.u1, uCapReq) annotation (Line(points={{-82,76},{-100,76},{-100,60},
          {-140,60}}, color={0,0,127}));
  connect(hys1.y, and1.u1)
    annotation (Line(points={{-18,70},{-12,70}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{12,70},{18,70}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{12,30},{18,30}}, color={255,0,255}));
  connect(and3.u1, hys2.y)
    annotation (Line(points={{-12,30},{-18,30}}, color={255,0,255}));
  connect(not1.u, uStaChaProEnd)
    annotation (Line(points={{-42,-180},{-140,-180}}, color={255,0,255}));
  connect(not1.y, and3.u2) annotation (Line(points={{-18,-180},{-16,-180},{-16,22},
          {-12,22}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{-18,-180},{-16,-180},{-16,62},
          {-12,62}}, color={255,0,255}));

  connect(tim.passed, logSwi.u1) annotation (Line(points={{42,62},{80,62},{80,58},
          {98,58}}, color={255,0,255}));
  connect(tim1.passed, logSwi.u3) annotation (Line(points={{42,22},{80,22},{80,42},
          {98,42}}, color={255,0,255}));
  connect(VUpMinSet_flow, addPar.u) annotation (Line(points={{-140,-60},{-110,-60},
          {-110,-70},{-82,-70}}, color={0,0,127}));
  connect(addPar.y, div2.u2) annotation (Line(points={{-58,-70},{-50,-70},{-50,-56},
          {-42,-56}}, color={0,0,127}));
  connect(uCapDes, addParDivZer.u)
    annotation (Line(points={{-140,100},{-112,100}}, color={0,0,127}));
  connect(addParDivZer.y, div1.u2) annotation (Line(points={{-88,100},{-86,100},
          {-86,64},{-82,64}}, color={0,0,127}));
  connect(uCapUpMin, addParDivZer1.u)
    annotation (Line(points={{-140,20},{-114,20}}, color={0,0,127}));
  connect(addParDivZer1.y, div.u2) annotation (Line(points={{-90,20},{-86,20},{-86,
          24},{-82,24}}, color={0,0,127}));
annotation (
  defaultComponentName = "effCon",
  Icon(
    coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-120,146},{100,108}},
                textColor={0,0,255},
                textString="%name")}),
  Diagram(
    coordinateSystem(
      preserveAspectRatio=false,
      extent={{-120,-200},{160,120}})),
  Documentation(
    info="<html>
    <p>
    Efficiency condition used in staging up and down for boiler plants with both
    condensing and non-condensing boilers. Implemented according to the
    specification provided in 5.3.3.10, subsections 6.b, 8.b, 10.b and 12.b in
    RP-1711, March 2020 Draft. Timer reset has been implemented according to
    5.3.3.10.2.
    </p>
    <p align=\"center\">
    <img alt=\"State-machine chart for EfficiencyCondition for condensing boilers\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/EfficiencyCondition_stateMachineChart_v3_conBoi.png\"/>
    <br/>
    State-machine chart for the sequence for condensing boilers defined in RP-1711
    </p>
    <p align=\"center\">
    <img alt=\"State-machine chart for EfficiencyCondition for non-condensing boilers\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/EfficiencyCondition_stateMachineChart_v3_nonConBoi.png\"/>
    <br/>
    State-machine chart for the sequence for non-condensing boilers defined in RP-1711
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end EfficiencyCondition;
