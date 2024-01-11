within Buildings.Controls.OBC.RooftopUnits.DXCoil;
block Controller
  "Sequences to enable and stage DX coils"

  parameter Integer nCoi(min=1)
    "Number of DX coils"
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

  parameter Real uThrCoiEna(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is enabled"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real uThrCoiDis(
    final min=0,
    final max=1)=0.1
    "Threshold of coil valve position signal below which DX coil is disabled"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPerUp(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPerDow(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPerEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real timPerDis(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil"
    annotation (Dialog(group="DX coil parameters"));

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

  Subsequences.NextCoil nexCoi(nCoi=nCoi)
    annotation (Placement(transformation(extent={{74,66},{94,86}})));
protected
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
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown DXCoiSta(
    final nCoi=nCoi,
    final uThrCoiUp=uThrCoiUp,
    final uThrCoiDow=uThrCoiDow,
    final dUHys=dUHys,
    final timPerUp=timPerUp,
    final timPerDow=timPerDow)
    "DX coil staging"
    annotation (Placement(transformation(extent={{-150,24},{-130,44}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable DXCoiEna(
    final nCoi=nCoi,
    final uThrCoiEna=uThrCoiEna,
    final uThrCoiDis=uThrCoiDis,
    final timPerEna=timPerEna,
    final timPerDis=timPerDis,
    final dUHys=dUHys)
    "DX coil enable and disable"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta1(
    final nCoi=nCoi)
    "Change DX coil status"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));

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
  connect(reaToInt.y, chaSta.uNexDXCoi)
    annotation (Line(points={{-78,120},{-40,120},{-40,126},{-2,126}},
                                                  color={255,127,0}));
  connect(reaToInt.y, chaSta.uLasDXCoi) annotation (Line(points={{-78,120},{-40,
          120},{-40,122},{-2,122}},  color={255,127,0}));
  connect(uDXCoi, chaSta.uDXCoil) annotation (Line(points={{-240,40},{-160,40},
          {-160,70},{-20,70},{-20,130},{-2,130}},color={255, 0,255}));
  connect(uDXCoi, DXCoiEna.uDXCoi) annotation (Line(points={{-240,40},{-160,40},
          {-160,6},{-152,6}}, color={255,0,255}));
  connect(uCoi, DXCoiEna.uCoi) annotation (Line(points={{-240,-60},{-180,-60},{-180,
          -6},{-152,-6}}, color={0,0,127}));
  connect(DXCoiEna.yDXCoi, chaSta.uNexDXCoiSta) annotation (Line(points={{-128,0},
          {-120,0},{-120,106},{-60,106},{-60,138},{-2,138}}, color={255,0,255}));
  connect(DXCoiEna.yDXCoi, chaSta.uLasDXCoiSta) annotation (Line(points={{-128,0},
          {-120,0},{-120,106},{-60,106},{-60,134},{-2,134}},color={255,0,255}));
  connect(chaSta.yDXCoi, chaSta1.uDXCoil) annotation (Line(points={{22,130},{
          134,130},{134,60},{138,60}},
                                   color={255,0,255}));
  connect(DXCoiSta.uCoi, uCoi) annotation (Line(points={{-152,34},{-180,34},{-180,
          -60},{-240,-60}}, color={0,0,127}));
  connect(uDXCoi, DXCoiSta.uDXCoi) annotation (Line(points={{-240,40},{-152,40}},
                                color={255,0,255}));
  connect(mulSumInt.y, intGreEquThr.u) annotation (Line(points={{-88,-40},{-60,-40},
          {-60,0},{-52,0}}, color={255,127,0}));
  connect(mulSumInt.y, intLesEquThr.u)
    annotation (Line(points={{-88,-40},{-52,-40}}, color={255,127,0}));
  connect(DXCoiSta.yUp, and2.u1) annotation (Line(points={{-128,40},{38,40}},
                        color={255,0,255}));
  connect(intGreEquThr.y, and2.u2) annotation (Line(points={{-28,0},{0,0},{0,32},
          {38,32}}, color={255,0,255}));
  connect(intLesEquThr.y, or2.u2) annotation (Line(points={{-28,-40},{-20,-40},
          {-20,-8},{38,-8}},color={255,0,255}));
  connect(or2.y, chaSta1.uLasDXCoiSta) annotation (Line(points={{62,0},{100,0},
          {100,64},{138,64}}, color={255,0,255}));
  connect(DXCoiSta.yDow, not1.u)
    annotation (Line(points={{-128,28},{-90,28},{-90,20},{-82,20}},
                                                  color={255,0,255}));
  connect(not1.y, or2.u1)
    annotation (Line(points={{-58,20},{6,20},{6,0},{38,0}},
                                                color={255,0,255}));
  connect(uDXCoi, booToInt.u) annotation (Line(points={{-240,40},{-190,40},{-190,
          -40},{-150,-40}}, color={255,0,255}));
  connect(uComSpe, DXCoiSta.uComSpe) annotation (Line(points={{-240,-100},{-170,
          -100},{-170,28},{-152,28}}, color={0,0,127}));

  connect(and2.y, nexCoi.uStaUp) annotation (Line(points={{62,40},{64,40},{64,
          78},{72,78}}, color={255,0,255}));
  connect(nexCoi.yNexCoi, chaSta1.uNexDXCoi) annotation (Line(points={{96,76},{
          120,76},{120,56},{138,56}}, color={255,127,0}));
  connect(nexCoi.yStaUp, chaSta1.uNexDXCoiSta) annotation (Line(points={{96,80},
          {128,80},{128,68},{138,68}}, color={255,0,255}));
  connect(uDXCoiAva, nexCoi.uDXCoiAva) annotation (Line(points={{-240,100},{20,
          100},{20,74},{72,74}}, color={255,0,255}));
  connect(uDXCoi, nexCoi.uDXCoi) annotation (Line(points={{-240,40},{-160,40},{
          -160,70},{72,70}}, color={255,0,255}));
  connect(uCoiSeq, nexCoi.uCoiSeq) annotation (Line(points={{-240,0},{-200,0},{
          -200,104},{68,104},{68,82},{72,82}}, color={255,127,0}));
  connect(nexCoi.yLasCoi, chaSta1.uLasDXCoi) annotation (Line(points={{96,72},{
          106,72},{106,52},{138,52}}, color={255,127,0}));
  connect(chaSta1.yDXCoi, yDXCoi)
    annotation (Line(points={{162,60},{240,60}}, color={255,0,255}));
  annotation (defaultComponentName="DXCoiCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
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
          textString="uComSpe"),        Text(
        extent={{-150,140},{150,100}},
        textString="%name",
        textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,160}})),
  Documentation(info="<html>
  <p>
  This is a control module for enabling and disabling DX coil arrays, as well as 
  enabling and disabling different coils in each stage.
  The control module consists of: 
  </p>
  <ul>
  <li>
  Subsequences to stage up and down DX coils 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown</a>.
  </li>
  <li>
  Subsequences to enable and disable DX coils 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable</a>.
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
