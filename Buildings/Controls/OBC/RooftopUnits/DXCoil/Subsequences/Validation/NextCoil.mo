within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model NextCoil
"Validate sequence for finding and enabling next available DX coil"

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[4](
    k=coiInd)
    "Enable sequence for coils"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=true)
    "Coil availability signal"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    period=60,
    shift=10)
    "Periodically trigger stage up process"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold uStaUp(
    trueHoldDuration=10,
    falseHoldDuration=0)
    "Hold stage up signal from periodic trigger for visualization"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.NextCoil nexCoi(
    nCoi=nCoi)
    "Next coil calculator-1"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4]
    "Pre block for feeding back coil enable status"
    annotation (Placement(transformation(extent={{94,0},{114,20}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta1(
    nCoi=4)
    "Change enable status of coils"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    delayTime=10)
    "Delay coil availability signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    delayTime=10)
    "Delay coil availability signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.NextCoil nexCoi1(
    nCoi=nCoi)
    "Next coil calculator-2"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.ChangeStatus chaSta2(
    nCoi=4)
    "Change enable status of coils"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[4]
    "Pre block for feeding back coil enable status"
    annotation (Placement(transformation(extent={{94,-80},{114,-60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    delayTime=10)
    "Delay coil availability signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    delayTime=10)
    "Delay coil availability signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaUp(
    trueHoldDuration=10,
    falseHoldDuration=0)
    "Hold stage up signal from controller for visualization"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaUp1(
    trueHoldDuration=10,
    falseHoldDuration=0)
    "Hold stage up signal from controller for visualization"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

protected
  parameter Integer nCoi=4;

  parameter Integer coiInd[nCoi]={i for i in 1:nCoi}
    "DX coil index, {1,2,...,n}";

equation
  connect(samTri.y, uStaUp.u) annotation (Line(points={{-18,30},{4,30},{4,40},{
          18,40}}, color={255,0,255}));
  connect(conInt.y, nexCoi.uCoiSeq) annotation (Line(points={{-68,80},{10,80},{10,
          16},{18,16}}, color={255,127,0}));
  connect(samTri.y, nexCoi.uStaUp) annotation (Line(points={{-18,30},{4,30},{4,12},
          {18,12}}, color={255,0,255}));
  connect(chaSta1.yDXCoi, pre1.u)
    annotation (Line(points={{82,10},{92,10}},       color={255,0,255}));
  connect(pre1.y, nexCoi.uDXCoi) annotation (Line(points={{116,10},{130,10},{130,
          -12},{0,-12},{0,4},{18,4}}, color={255,0,255}));
  connect(con.y, nexCoi.uDXCoiAva[1]) annotation (Line(points={{-68,20},{-60,20},
          {-60,7.25},{18,7.25}},
                           color={255,0,255}));
  connect(truDel1.y, nexCoi.uDXCoiAva[2]) annotation (Line(points={{-18,-10},{-4,
          -10},{-4,6},{18,6},{18,7.75}},
                                      color={255,0,255}));
  connect(nexCoi.yStaUp, chaSta1.uNexDXCoiSta) annotation (Line(points={{42,14},
          {50,14},{50,18},{58,18}}, color={255,0,255}));
  connect(nexCoi.yNexCoi, chaSta1.uNexDXCoi)
    annotation (Line(points={{42,10},{50,10},{50,6},{58,6}},
                                                           color={255,127,0}));
  connect(nexCoi.yNexCoi, chaSta1.uLasDXCoi)
    annotation (Line(points={{42,10},{50,10},{50,2},{58,2}},
                                                           color={255,127,0}));
  connect(pre1.y, chaSta1.uDXCoil) annotation (Line(points={{116,10},{130,10},{
          130,-12},{54,-12},{54,10},{58,10}},        color={255,0,255}));
  connect(con.y, chaSta1.uLasDXCoiSta) annotation (Line(points={{-68,20},{-60,
          20},{-60,-40},{52,-40},{52,14},{58,14}},   color={255,0,255}));
  connect(truDel2.y, nexCoi.uDXCoiAva[3]) annotation (Line(points={{-68,-10},{-56,
          -10},{-56,10},{18,10},{18,8.25}},
                                         color={255,0,255}));
  connect(con.y, nexCoi.uDXCoiAva[4]) annotation (Line(points={{-68,20},{-60,20},
          {-60,8.75},{18,8.75}},
                           color={255,0,255}));
  connect(pre1[4].y, truDel2.u) annotation (Line(points={{116,10},{130,10},{130,
          -34},{-96,-34},{-96,-10},{-92,-10}},         color={255,0,255}));
  connect(chaSta2.yDXCoi,pre2. u)
    annotation (Line(points={{82,-70},{92,-70}},     color={255,0,255}));
  connect(nexCoi1.yStaUp, chaSta2.uNexDXCoiSta) annotation (Line(points={{42,-66},
          {50,-66},{50,-62},{58,-62}}, color={255,0,255}));
  connect(nexCoi1.yNexCoi, chaSta2.uNexDXCoi) annotation (Line(points={{42,-70},
          {50,-70},{50,-74},{58,-74}}, color={255,127,0}));
  connect(pre2.y, chaSta2.uDXCoil) annotation (Line(points={{116,-70},{120,-70},
          {120,-90},{54,-90},{54,-70},{58,-70}}, color={255,0,255}));
  connect(nexCoi1.yNexCoi, chaSta2.uLasDXCoi) annotation (Line(points={{42,-70},
          {50,-70},{50,-78},{58,-78}}, color={255,127,0}));
  connect(con.y, chaSta2.uLasDXCoiSta) annotation (Line(points={{-68,20},{-60,
          20},{-60,-40},{52,-40},{52,-66},{58,-66}}, color={255,0,255}));
  connect(pre2[3].y, truDel3.u) annotation (Line(points={{116,-70},{120,-70},{
          120,-100},{-50,-100},{-50,-80},{-42,-80}}, color={255,0,255}));
  connect(conInt.y, nexCoi1.uCoiSeq) annotation (Line(points={{-68,80},{10,80},{
          10,-64},{18,-64}}, color={255,127,0}));
  connect(truDel3.y, nexCoi1.uDXCoiAva[2]) annotation (Line(points={{-18,-80},{-14,
          -80},{-14,-72.25},{18,-72.25}},
                                    color={255,0,255}));
  connect(pre2[2].y, truDel4.u) annotation (Line(points={{116,-70},{120,-70},{
          120,-100},{-100,-100},{-100,-60},{-92,-60}}, color={255,0,255}));
  connect(truDel4.y, nexCoi1.uDXCoiAva[4]) annotation (Line(points={{-68,-60},{-10,
          -60},{-10,-76},{14,-76},{14,-71.25},{18,-71.25}},
                                                      color={255,0,255}));
  connect(con.y, nexCoi1.uDXCoiAva[1]) annotation (Line(points={{-68,20},{-60,20},
          {-60,-40},{0,-40},{0,-74},{18,-74},{18,-72.75}},
                                                        color={255,0,255}));
  connect(con.y, nexCoi1.uDXCoiAva[3]) annotation (Line(points={{-68,20},{-60,20},
          {-60,-40},{0,-40},{0,-70},{14,-70},{14,-71.75},{18,-71.75}},
                                                                 color={255,0,255}));
  connect(pre2.y, nexCoi1.uDXCoi) annotation (Line(points={{116,-70},{120,-70},{
          120,-90},{16,-90},{16,-76},{18,-76}}, color={255,0,255}));
  connect(samTri.y, nexCoi1.uStaUp) annotation (Line(points={{-18,30},{4,30},{4,
          -68},{18,-68}}, color={255,0,255}));
  connect(pre1[4].y, truDel1.u) annotation (Line(points={{116,10},{130,10},{130,
          -34},{-50,-34},{-50,-10},{-42,-10}}, color={255,0,255}));
  connect(nexCoi.yStaUp, yStaUp.u) annotation (Line(points={{42,14},{50,14},{50,
          40},{58,40}}, color={255,0,255}));
  connect(nexCoi1.yStaUp, yStaUp1.u) annotation (Line(points={{42,-66},{48,-66},
          {48,-120},{58,-120}}, color={255,0,255}));
  annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/NextCoil.mos"
    "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.NextCoil\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.NextCoil</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the Boolean input signal <code>uStaUp</code> is <code>true</code> 
    and an appropriate coil, e.g., <code>nexCoi.uDXCoiAva=false</code>, is found,  
    the controller ouputs the coil index through the output <code>nexCoi.yNexCoi</code> 
    and sends a Boolean stage up signal through the output <code>yStaUp.y</code>. 
    </li>
    <li>
    When <code>uStaUp</code> is <code>false</code> or an appropriate coil is not found,  
    the controller keeps the previous signal <code>nexCoi.yNexCoi</code> 
    and outputs <code>yStaUp.y=false</code>. 
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    August 7, 2023, by Junke Wang and Karthik Devaprasad:<br/>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{140,100}})));
end NextCoil;
