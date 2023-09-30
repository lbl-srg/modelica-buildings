within Buildings.Controls.OBC.RooftopUnits.DXCoil;
block Controller
  "Sequences to stage DX coils and regulate their corresponding compressor speeds"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi(min=1)=2
    "Number of DX coils"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real conCoiLow(
    final min=0,
    final max=1)=0.2
    "Constant lower DX coil signal"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real conCoiHig(
    final min=0,
    final max=1)=0.8
    "Constant higher DX coil signal"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoiUp(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoiDow(
    final min=0,
    final max=1)=0.2
    "Threshold of coil valve position signal below which DX coil staged down"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoi2(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is enabled"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoi3(
    final min=0,
    final max=1)=0.1
    "Threshold of coil valve position signal below which DX coil is disabled"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real minComSpe(
    final min=0,
    final max=maxComSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  parameter Real maxComSpe(
    final min=minComSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCoiSeq[nCoi]
    "DX coil available sequence order"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coil valve position"
    annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uComSpe[nCoi](
    displayUnit="1")
    "Compressor speed ratio"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi[nCoi]
    "DX coil signal"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nCoi]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-190,110},{-170,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea(
    final nin=nCoi)
    "DX coil index"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nCoi]
    "Logical Switch"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nCoi](
    final k=fill(false,nCoi))
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{130,30},{150,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nCoi]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-148,-50},{-128,-30}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nCoi)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Integer Add"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Output true Boolean signal if integer is greater or equal than threshold"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=1)
    "Output true Boolean signal if integer is less or equal than threshold"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexDXCoi(nin=nCoi)
    "Next DX coil"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasDXCoi(nin=nCoi)
    "Last DX coil"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage DXCoiSta(
    final nCoi=nCoi,
    final uThrCoiUp=uThrCoiUp,
    final uThrCoiDow=uThrCoiDow,
    final dUHys=dUHys,
    final timPerUp=timPer,
    final timPerDow=timPer1)
    "DX coil staging"
    annotation (Placement(transformation(extent={{-150,26},{-130,46}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable DXCoiEna(
    final nCoi=nCoi,
    final uThrCoiEna=uThrCoi2,
    final uThrCoiDis=uThrCoi3,
    final timPerEna=timPer2,
    final timPerDis=timPer3,
    final dUHys=dUHys)
    "DX coil enable and disable"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ZeroIndexCorrection zerStaIndCor
    "Pass the correct input details when index signal is zero"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{0,114},{22,134}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta1(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{130,72},{152,92}})));

protected
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of DX coil controller"
    annotation (Dialog(group="P controller"));

  parameter Real k = (maxComSpe - minComSpe) / (conCoiHig- conCoiLow)
    "Gain of DX coil controller"
    annotation (Dialog(group="P controller"));

equation
  connect(uCoiSeq, intToRea.u)
    annotation (Line(points={{-240,0},{-200,0},{-200,120},{-192,120}}, color={255,127,0}));
  connect(intToRea.y, extIndRea.u)
    annotation (Line(points={{-168,120},{-152,120}}, color={0,0,127}));
  connect(conInt.y, extIndRea.index)
    annotation (Line(points={{-168,80},{-140,80},{-140,108}}, color={255,127,0}));
  connect(extIndRea.y, reaToInt.u)
    annotation (Line(points={{-128,120},{-102,120}}, color={0,0,127}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-126,-40},{-112,-40}}, color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-168,80},{-110,80},{-110,6},{-102,6}}, color={255,127,0}));
  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-88,-40},{-74,-40},{-74,-20},{-110,-20},{-110,-6}, {-102,-6}},
                color={255,127,0}));
  connect(reaToInt.y, chaSta.uNexDXCoi)
    annotation (Line(points={{-78,120},{-2,120}}, color={255,127,0}));
  connect(reaToInt.y, chaSta.uLasDXCoi) annotation (Line(points={{-78,120},{-40,
          120},{-40,116},{-2,116}},  color={255,127,0}));
  connect(uDXCoi, chaSta.uDXCoil) annotation (Line(points={{-240,40},{-160,40},{
          -160,70},{-20,70},{-20,124},{-2,124}}, color={255, 0,255}));
  connect(uDXCoi, DXCoiEna.uDXCoi) annotation (Line(points={{-240,40},{-160,40},
          {-160,6},{-152,6}}, color={255,0,255}));
  connect(uCoi, DXCoiEna.uCoi) annotation (Line(points={{-240,-60},{-180,-60},{-180,
          -6},{-152,-6}}, color={0,0,127}));
  connect(DXCoiEna.yDXCoi, chaSta.uNexDXCoiSta) annotation (Line(points={{-128,0},
          {-120,0},{-120,106},{-60,106},{-60,132},{-2,132}}, color={255,0,255}));
  connect(DXCoiEna.yDXCoi, chaSta.uLasDXCoiSta) annotation (Line(points={{-128,0},
          {-120,0},{-120,106},{-60,106},{-60,128},{-2,128}},color={255,0,255}));
  connect(chaSta.yDXCoi, chaSta1.uDXCoil) annotation (Line(points={{24,124},{118,
          124},{118,82},{128,82}}, color={255,0,255}));
  connect(DXCoiSta.uCoi, uCoi) annotation (Line(points={{-152,36},{-180,36},{-180,
          -60},{-240,-60}}, color={0,0,127}));
  connect(uDXCoi, DXCoiSta.uDXCoi) annotation (Line(points={{-240,40},{-190,40},
          {-190,42},{-152,42}}, color={255,0,255}));
  connect(mulSumInt.y, intGreEquThr.u) annotation (Line(points={{-88,-40},{-60,-40},
          {-60,0},{-52,0}}, color={255,127,0}));
  connect(mulSumInt.y, intLesEquThr.u)
    annotation (Line(points={{-88,-40},{-52,-40}}, color={255,127,0}));
  connect(DXCoiSta.yUp, and2.u1) annotation (Line(points={{-128,42},{-60,42},{-60,
          90},{38,90}}, color={255,0,255}));
  connect(intGreEquThr.y, and2.u2) annotation (Line(points={{-28,0},{30,0},{30,82},
          {38,82}}, color={255,0,255}));
  connect(intLesEquThr.y, or2.u2) annotation (Line(points={{-28,-40},{-20,-40},{
          -20,22},{38,22}}, color={255,0,255}));
  connect(or2.y, chaSta1.uLasDXCoiSta) annotation (Line(points={{62,30},{100,30},
          {100,86},{128,86}}, color={255,0,255}));
  connect(and2.y, chaSta1.uNexDXCoiSta)
    annotation (Line(points={{62,90},{128,90}},color={255,0,255}));
  connect(chaSta1.yDXCoi, logSwi.u1) annotation (Line(points={{154,82},{160,82},
          {160,68},{178,68}},   color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{152,40},{160,40},{160,52},
          {178,52}}, color={255,0,255}));
  connect(uDXCoiAva, logSwi.u2) annotation (Line(points={{-240,100},{20,100},{20,
          60},{178,60}},                              color={255,0,255}));
  connect(intToRea.y, nexDXCoi.u) annotation (Line(points={{-168,120},{-160,120},
          {-160,96},{-10,96},{-10,-40},{-2,-40}}, color={0,0,127}));
  connect(intToRea.y, lasDXCoi.u) annotation (Line(points={{-168,120},{-160,120},
          {-160,96},{-10,96},{-10,-80},{-2,-80}}, color={0,0,127}));
  connect(addInt.y, nexDXCoi.index) annotation (Line(points={{-78,0},{-68,0},{-68,
          -56},{10,-56},{10,-52}}, color={255,127,0}));
  connect(nexDXCoi.y, reaToInt1.u) annotation (Line(points={{22,-40},{50,-40},{50,
          0},{78,0}}, color={0,0,127}));
  connect(reaToInt2.y, chaSta1.uLasDXCoi) annotation (Line(points={{102,-40},{120,
          -40},{120,74},{128,74}}, color={255,127,0}));
  connect(logSwi.y, yDXCoi)
    annotation (Line(points={{202,60},{240,60}},   color={255,0,255}));
  connect(mulSumInt.y, zerStaIndCor.uInd) annotation (Line(points={{-88,-40},{-74,
          -40},{-74,-76},{-52,-76}}, color={255,127,0}));
  connect(zerStaIndCor.yIndMod, lasDXCoi.index) annotation (Line(points={{-28,-76},
          {-14,-76},{-14,-96},{10,-96},{10,-92}}, color={255,127,0}));
  connect(lasDXCoi.y, zerStaIndCor.uRea) annotation (Line(points={{22,-80},{30,-80},
          {30,-100},{-60,-100},{-60,-84},{-52,-84}}, color={0,0,127}));
  connect(zerStaIndCor.yReaMod, reaToInt2.u) annotation (Line(points={{-28,-84},
          {-20,-84},{-20,-108},{60,-108},{60,-40},{78,-40}}, color={0,0,127}));
  connect(DXCoiSta.yDow, not1.u)
    annotation (Line(points={{-128,30},{-52,30}}, color={255,0,255}));
  connect(not1.y, or2.u1)
    annotation (Line(points={{-28,30},{38,30}}, color={255,0,255}));
  connect(reaToInt1.y, chaSta1.uNexDXCoi) annotation (Line(points={{102,0},{110,
          0},{110,78},{128,78}},  color={255,127,0}));
  connect(uDXCoi, booToInt.u) annotation (Line(points={{-240,40},{-190,40},{-190,
          -40},{-150,-40}}, color={255,0,255}));
  connect(uComSpe, DXCoiSta.uComSpe) annotation (Line(points={{-240,-100},{-170,
          -100},{-170,30},{-152,30}}, color={0,0,127}));

  annotation (defaultComponentName="DXCoiCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Text(
            extent={{-100,140},{100,140}},
            textColor={0,0,255}),
          Text(
            extent={{-100,-34},{-66,-48}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{-96,8},{-50,-6}},
            textColor={255,127,0},
            textString="uCoiSeq"),
          Text(
            extent={{-98,48},{-52,34}},
            textColor={255,0,255},
            textString="uDXCoi"),
          Text(
            extent={{-94,88},{-40,72}},
            textColor={255,0,255},
            textString="uDXCoiAva"),
          Text(
            extent={{52,8},{94,-6}},
            textColor={255,0,255},
            textString="yDXCoi"),
          Text(
            extent={{-94,-72},{-46,-88}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="uComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,160}})),
  Documentation(info="<html>
  <p>
  This is a control module for DX coils staging. 
  The control module consists of: 
  </p>
  <ul>
  <li>
  Subsequences to stage up and down DX coils 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage</a>.
  </li>
  <li>
  Subsequences to enable and disable DX coils 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable</a>.
  </li>
  <li>
  Subsequences to change DX coil status 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus</a>.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 8, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end Controller;
