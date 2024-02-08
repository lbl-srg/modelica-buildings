within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block StageUpDown
  "Sequence for staging up and down DX coils"

  parameter Integer nCoi(min=1)
    "Number of DX coils";

  parameter Real uThrCoiUp(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up";

  parameter Real uThrCoiDow(
    final min=0,
    final max=1)=0.2
    "Threshold of coil valve position signal below which DX coil staged down";

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real timPerUp(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil";

  parameter Real timPerDow(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coil valve position"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next DX coil status"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDow
    "Last DX coil status"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uComSpe[nCoi](
    displayUnit="1")
    "Compressor speed ratio"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nCoi)
    "Logical MultiOr"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThrCoiUp(
    final t=uThrCoiUp,
    final h=dUHys)
    "Check if coil valve position signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timUp(
    final t=timPerUp)
    "Check time for which stage-up conditions have been satisfied"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Logical.And andUp
    "Reset timer when coil status changes"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[nCoi]
    "Detect changes in DX coil status"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoi)
    "Check if any coil status changed"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Not notCoiSta
    "Generate Boolean False signal when any coil status changes"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDow(
    final t=timPerDow)
    "Check time for which stage-down conditions have been satisfied"
    annotation (Placement(transformation(extent={{60,-42},{80,-22}})));

  Buildings.Controls.OBC.CDL.Logical.And andDow
    "Reset timer when coil status changes"
    annotation (Placement(transformation(extent={{30,-42},{50,-22}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThrCoiDow[nCoi](
    final t=fill(uThrCoiDow, nCoi),
    final h=fill(dUHys, nCoi))
    "Check if compressor speed is less than a threshold of coil valve postition"
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoi](
    each final realTrue=0,
    each final realFalse=1)
    "Check DX coil signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Add add2[nCoi]
    "Product of DX coil signal and compressor speed"
    annotation (Placement(transformation(extent={{-80,-64},{-60,-44}})));

equation
  connect(uCoi, greThrCoiUp.u) annotation (Line(points={{-120,20},{-52,20}}, color={0,0,127}));
  connect(mulOr.y, notCoiSta.u)
    annotation (Line(points={{22,70},{38,70}}, color={255,0,255}));
  connect(uDXCoi, cha.u)
    annotation (Line(points={{-120,70},{-52,70}}, color={255,0,255}));
  connect(andUp.y, timUp.u)
    annotation (Line(points={{22,20},{38,20}}, color={255,0,255}));
  connect(andDow.y, timDow.u)
    annotation (Line(points={{52,-32},{58,-32}}, color={255,0,255}));
  connect(greThrCoiUp.y, andUp.u2) annotation (Line(points={{-28,20},{-20,20},{-20,
          12},{-2,12}},  color={255,0,255}));
  connect(notCoiSta.y, andUp.u1) annotation (Line(points={{62,70},{70,70},{70,48},
          {-10,48},{-10,20},{-2,20}},color={255,0,255}));
  connect(notCoiSta.y, andDow.u1) annotation (Line(points={{62,70},{70,70},{70,48},
          {-10,48},{-10,-32},{28,-32}},  color={255,0,255}));
  connect(cha.y, mulOr.u)
    annotation (Line(points={{-28,70},{-2,70}},  color={255,0,255}));
  connect(timUp.passed, yUp) annotation (Line(points={{62,12},{80,12},{80,20},{120,
          20}},                                                          color={255,0,255}));
  connect(lesThrCoiDow.y, mulOr1.u[1:nCoi])
    annotation (Line(points={{-18,-54},{-12,-54}}, color={255,0,255}));
  connect(mulOr1.y, andDow.u2) annotation (Line(points={{12,-54},{20,-54},{20,-40},
          {28,-40}},       color={255,0,255}));
  connect(timDow.passed, yDow) annotation (Line(points={{82,-40},{120,-40}}, color={255,0,255}));
  connect(uDXCoi, booToRea.u) annotation (Line(points={{-120,70},{-90,70},{-90,-20},
          {-82,-20}}, color={255,0,255}));
  connect(booToRea.y, add2.u1) annotation (Line(points={{-58,-20},{-50,-20},{-50,
          -36},{-90,-36},{-90,-48},{-82,-48}}, color={0,0,127}));
  connect(uComSpe, add2.u2)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));
  connect(add2.y, lesThrCoiDow.u) annotation (Line(points={{-58,-54},{-42,-54}},
                               color={0,0,127}));

  annotation (
    defaultComponentName="DXCoiSta",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
          Text(
            extent={{-96,68},{-50,54}},
            textColor={255,0,255},
            textString="uDXCoi"),
          Text(
            extent={{-100,6},{-64,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{62,66},{104,52}},
            textColor={255,0,255},
          textString="yUp"),
          Text(
            extent={{58,-54},{100,-68}},
            textColor={255,0,255},
            textString="yDow"),
          Text(
            extent={{-92,-50},{-44,-70}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="uComSpe"),        Text(
        extent={{-150,140},{150,100}},
        textString="%name",
        textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
  Documentation(info="<html>
  <p>
  This is a control module for staging the DX coil operation signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  Stage up <code>yUp = true</code> when coil valve position <code>uCoi</code> exceeds 
  its threshold <code>uThrCoiUp</code> for the duration of <code>timPerUp</code>, 
  and no changes in DX coil status <code>uDXCoi</code> are detected. 
  </li>
  <li>
  Stage down <code>yDow = true</code> when compressor speed ratio <code>uComSpe</code> 
  falls below a threshold of coil valve position <code>uThrCoiDow</code> for the 
  duration of <code>timPerDow</code>, and no changes in <code>uDXCoi</code> are detected. 
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 4, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end StageUpDown;
