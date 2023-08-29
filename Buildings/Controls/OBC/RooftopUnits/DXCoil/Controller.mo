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

  parameter Real uThrCoi(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoi1(
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

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCoiSeq[nCoi]
    "DX coil available sequence order"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coil valve position"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi[nCoi]
    "DX coil signal"
    annotation (Placement(transformation(extent={{220,60},{260,100}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpe[nCoi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{220,-140},{260,-100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nCoi]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-190,130},{-170,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-190,90},{-170,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea(
    final nin=nCoi)
    "DX coil index"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nCoi]
    "Logical Switch"
    annotation (Placement(transformation(extent={{180,70},{200,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nCoi](
    final k=fill(false,nCoi))
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{130,50},{150,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nCoi]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nCoi)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Integer Add"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Output true Boolean signal if integer is greater or equal than threshold"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=1)
    "Output true Boolean signal if integer is less or equal than threshold"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-50,44},{-30,64}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{40,44},{60,64}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexDXCoi(nin=nCoi)
    "Next DX coil"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasDXCoi(nin=nCoi)
    "Last DX coil"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage DXCoiSta(
    final nCoi=nCoi,
    final uThrCoi=uThrCoi,
    final uThrCoi1=uThrCoi1,
    final dUHys=dUHys,
    final timPer=timPer,
    final timPer1=timPer1)
    "DX coil staging"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilEnable DXCoiEna(
    final nCoi=nCoi,
    final uThrCoi2=uThrCoi2,
    final uThrCoi3=uThrCoi3,
    final dUHys=dUHys,
    final timPer2=timPer2,
    final timPer3=timPer3)
    "DX coil enable and disable"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage ComSpeSta[nCoi](
    each final conCoiLow=conCoiLow,
    each final conCoiHig=conCoiHig,
    each final minComSpe=minComSpe,
    each final maxComSpe=maxComSpe)
    "Compressor speed stage"
    annotation (Placement(transformation(extent={{130,-130},{150,-110}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ZeroIndexCorrection zerStaIndCor
    "Pass the correct input details when index signal is zero"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{0,134},{22,154}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta1(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{130,92},{152,112}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCoi)
    "Real scalar replicator"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nCoi](k=1:nCoi)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-150,-132},{-130,-112}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCoi)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-150,-82},{-130,-62}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nCoi]
    "Output true Boolean signal if integer is greater than threshold"
    annotation (Placement(transformation(extent={{-50,-124},{-30,-104}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoi]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{130,-70},{150,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nCoi]
    "Calculate compressor speed based on product of two inputs"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));

  Subsequences.NextCoil nextCoil(nCoi=nCoi)
    annotation (Placement(transformation(extent={{-188,-32},{-160,-4}})));
protected
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of DX coil controller"
    annotation (Dialog(group="P controller"));

  parameter Real k = (maxComSpe - minComSpe) / (conCoiHig- conCoiLow)
    "Gain of DX coil controller"
    annotation (Dialog(group="P controller"));

equation
  connect(uCoiSeq, intToRea.u)
    annotation (Line(points={{-240,-40},{-200,-40},{-200,140},{-192,140}},
                                                     color={255,127,0}));
  connect(intToRea.y, extIndRea.u)
    annotation (Line(points={{-168,140},{-152,140}}, color={0,0,127}));
  connect(conInt.y, extIndRea.index) annotation (Line(points={{-168,100},{-140,100},
          {-140,128}},color={255,127,0}));
  connect(extIndRea.y, reaToInt.u)
    annotation (Line(points={{-128,140},{-102,140}},
                                                   color={0,0,127}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-128,-20},{-102,-20}},
                                                   color={255,127,0}));
  connect(conInt.y, addInt.u1) annotation (Line(points={{-168,100},{-110,100},{-110,
          26},{-102,26}},      color={255,127,0}));
  connect(mulSumInt.y, addInt.u2) annotation (Line(points={{-78,-20},{-74,-20},{
          -74,0},{-110,0},{-110,14},{-102,14}},
                                color={255,127,0}));
  connect(reaToInt.y, chaSta.uNexDXCoi) annotation (Line(points={{-78,140},{-2,140}},
                                                         color={255,127,0}));
  connect(reaToInt.y, chaSta.uLasDXCoi) annotation (Line(points={{-78,140},{-40,
          140},{-40,136},{-2,136}},  color={255,127,0}));
  connect(uDXCoi, chaSta.uDXCoil) annotation (Line(points={{-240,40},{-168,40},{
          -168,90},{-20,90},{-20,144},{-2,144}},                        color={255,
          0,255}));
  connect(uDXCoi, DXCoiEna.uDXCoi) annotation (Line(points={{-240,40},{-168,40},
          {-168,26},{-152,26}},
                              color={255,0,255}));
  connect(uCoi, DXCoiEna.uCoi) annotation (Line(points={{-240,-120},{-180,
          -120},{-180,14},{-152,14}}, color={0,0,127}));
  connect(DXCoiEna.yDXCoi, chaSta.uNexDXCoiSta) annotation (Line(points={{-128,20},
          {-120,20},{-120,126},{-60,126},{-60,152},{-2,152}},
        color={255,0,255}));
  connect(DXCoiEna.yDXCoi, chaSta.uLasDXCoiSta) annotation (Line(points={{-128,20},
          {-120,20},{-120,126},{-60,126},{-60,149},{-2,149}},
                                                            color={255,0,255}));
  connect(chaSta.yDXCoi, chaSta1.uDXCoil) annotation (Line(points={{24,144},{
          120,144},{120,102},{128,102}},
                                 color={255,0,255}));
  connect(DXCoiSta.uCoi, uCoi) annotation (Line(points={{-152,54},{-180,54},{
          -180,-120},{-240,-120}}, color={0,0,127}));
  connect(uDXCoi, DXCoiSta.uDXCoi) annotation (Line(points={{-240,40},{-168,40},
          {-168,66},{-152,66}}, color={255,0,255}));
  connect(mulSumInt.y, intGreEquThr.u) annotation (Line(points={{-78,-20},{-60,-20},
          {-60,20},{-52,20}},   color={255,127,0}));
  connect(mulSumInt.y, intLesEquThr.u) annotation (Line(points={{-78,-20},{-52,-20}},
                                color={255,127,0}));
  connect(DXCoiSta.yUp, and2.u1) annotation (Line(points={{-128,66},{-60,66},{-60,
          110},{38,110}},
                        color={255,0,255}));
  connect(intGreEquThr.y, and2.u2) annotation (Line(points={{-28,20},{30,20},{30,
          102},{38,102}},    color={255,0,255}));
  connect(intLesEquThr.y, or2.u2) annotation (Line(points={{-28,-20},{-20,-20},{
          -20,46},{38,46}},
                        color={255,0,255}));
  connect(or2.y, chaSta1.uLasDXCoiSta) annotation (Line(points={{62,54},{100,54},
          {100,107},{128,107}},
                            color={255,0,255}));
  connect(and2.y, chaSta1.uNexDXCoiSta)
    annotation (Line(points={{62,110},{128,110}},
                                               color={255,0,255}));
  connect(chaSta1.yDXCoi, logSwi.u1) annotation (Line(points={{154,102},{160,
          102},{160,88},{178,88}},
                                color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{152,60},{160,60},{160,72},
          {178,72}}, color={255,0,255}));
  connect(uDXCoiAva, logSwi.u2) annotation (Line(points={{-240,120},{20,120},{20,
          80},{178,80}},                              color={255,0,255}));
  connect(intToRea.y, nexDXCoi.u) annotation (Line(points={{-168,140},{-162,140},
          {-162,116},{-10,116},{-10,-20},{-2,-20}},
                                                color={0,0,127}));
  connect(intToRea.y, lasDXCoi.u) annotation (Line(points={{-168,140},{-162,140},
          {-162,116},{-10,116},{-10,-60},{-2,-60}},
                                                  color={0,0,127}));
  connect(addInt.y, nexDXCoi.index) annotation (Line(points={{-78,20},{-68,20},{
          -68,-36},{10,-36},{10,-32}},
                                   color={255,127,0}));
  connect(nexDXCoi.y, reaToInt1.u) annotation (Line(points={{22,-20},{50,-20},{50,
          20},{78,20}},
                      color={0,0,127}));
  connect(reaToInt2.y, chaSta1.uLasDXCoi) annotation (Line(points={{102,-20},{120,
          -20},{120,94},{128,94}}, color={255,127,0}));
  connect(logSwi.y, yDXCoi)
    annotation (Line(points={{202,80},{240,80}},   color={255,0,255}));
  connect(mulSumInt.y, zerStaIndCor.uInd) annotation (Line(points={{-78,-20},{
          -74,-20},{-74,-56},{-52,-56}},
                                     color={255,127,0}));
  connect(zerStaIndCor.yIndMod, lasDXCoi.index) annotation (Line(points={{-28,-56},
          {-14,-56},{-14,-76},{10,-76},{10,-72}}, color={255,127,0}));
  connect(lasDXCoi.y, zerStaIndCor.uRea) annotation (Line(points={{22,-60},{30,-60},
          {30,-80},{-60,-80},{-60,-64},{-52,-64}},   color={0,0,127}));
  connect(zerStaIndCor.yReaMod, reaToInt2.u) annotation (Line(points={{-28,-64},
          {-20,-64},{-20,-88},{60,-88},{60,-20},{78,-20}},
                                                         color={0,0,127}));
  connect(reaScaRep.y, ComSpeSta.uCoi) annotation (Line(points={{102,-150},{120,
          -150},{120,-126},{128,-126}}, color={0,0,127}));
  connect(uCoi, reaScaRep.u) annotation (Line(points={{-240,-120},{-180,-120},
          {-180,-150},{78,-150}},                        color={0,0,127}));
  connect(mulSumInt.y, intScaRep.u) annotation (Line(points={{-78,-20},{-74,-20},
          {-74,-48},{-168,-48},{-168,-72},{-152,-72}}, color={255,127,0}));
  connect(intGre.y, ComSpeSta.uPreDXCoi) annotation (Line(points={{-28,-114},{27,
          -114},{27,-114.2},{128,-114.2}}, color={255,0,255}));
  connect(intScaRep.y, intGre.u1) annotation (Line(points={{-128,-72},{-80,-72},
          {-80,-114},{-52,-114}}, color={255,127,0}));
  connect(conInt1.y, intGre.u2)
    annotation (Line(points={{-128,-122},{-52,-122}}, color={255,127,0}));
  connect(logSwi.y, booToRea.u) annotation (Line(points={{202,80},{210,80},{210,
          -30},{120,-30},{120,-60},{128,-60}}, color={255,0,255}));
  connect(mul.y, yComSpe)
    annotation (Line(points={{202,-120},{240,-120}}, color={0,0,127}));
  connect(ComSpeSta.yComSpe, mul.u2) annotation (Line(points={{152,-120},{160,-120},
          {160,-126},{178,-126}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{152,-60},{170,-60},{170,
          -114},{178,-114}}, color={0,0,127}));
  connect(DXCoiSta.yDow, not1.u)
    annotation (Line(points={{-128,54},{-52,54}}, color={255,0,255}));
  connect(not1.y, or2.u1)
    annotation (Line(points={{-28,54},{38,54}}, color={255,0,255}));

  connect(nextCoil.yDXCoiInt, booToInt.u) annotation (Line(points={{-158,-12},{
          -154,-12},{-154,-20},{-152,-20}}, color={255,0,255}));
  connect(uDXCoiAva, nextCoil.uDXCoiAva) annotation (Line(points={{-240,120},{
          -196,120},{-196,-22},{-190,-22}}, color={255,0,255}));
  connect(uDXCoi, nextCoil.uDXCoi) annotation (Line(points={{-240,40},{-206,40},
          {-206,-28},{-190,-28}}, color={255,0,255}));
  connect(reaToInt1.y, nextCoil.uNexCoi) annotation (Line(points={{102,20},{110,
          20},{110,86},{-192,86},{-192,-8},{-190,-8}}, color={255,127,0}));
  annotation (defaultComponentName="DXCoiCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Text(
            extent={{-100,140},{100,140}},
            textColor={0,0,255}),
          Text(
            extent={{-100,-74},{-66,-88}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{-96,-30},{-50,-44}},
            textColor={255,127,0},
            textString="uCoiSeq"),
          Text(
            extent={{-98,88},{-52,74}},
            textColor={255,0,255},
            textString="uDXCoi"),
          Text(
            extent={{-94,48},{-40,32}},
            textColor={255,0,255},
            textString="uDXCoiAva"),
          Text(
            extent={{52,48},{94,34}},
            textColor={255,0,255},
            textString="yDXCoi"),
          Text(
            extent={{44,-32},{94,-48}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{220,180}})),
  Documentation(info="<html>
  <p>
  This is a control module for staging DX coils and adjusting their corresponding compressor speeds. 
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
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilEnable\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilEnable</a>.
  </li>
  <li>
  Subsequences to control compressor speed 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage</a>.
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
