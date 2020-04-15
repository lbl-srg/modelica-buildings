within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change
  "Validates chiller stage status setpoint signal generation for plants with WSE"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Modelica.SIunits.Time minStaRuntime = 900
    "Minimum stage runtime";

  parameter Modelica.SIunits.VolumeFlowRate aveVChiWat_flow = 0.05
    "Average measured chilled water flow rate";

  .Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha "Controls for stage up signal variations"
        annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  CDL.Logical.Sources.Constant                        plaSta(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  CDL.Logical.TrueDelay truDel(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  CDL.Continuous.Sources.TimeTable timeTable
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  CDL.Continuous.Sources.TimeTable timeTable1
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Continuous.GreaterThreshold greThr1(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  CDL.Conversions.IntegerToReal                        intToRea
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  CDL.Conversions.RealToInteger                        reaToInt
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  CDL.Integers.Add addInt(k1=+1)
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  CDL.Integers.Add addInt1(k2=-1)
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha1 "Controls for stage down signal variations"
         annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Logical.Sources.Constant                        plaSta1(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  CDL.Logical.TrueDelay truDel1(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Conversions.IntegerToReal                        intToRea1
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol1(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  CDL.Conversions.RealToInteger                        reaToInt1
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  CDL.Integers.Add addInt2(k1=+1)
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  CDL.Integers.Add addInt3(k2=-1)
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  CDL.Continuous.Sources.TimeTable timeTable2
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  CDL.Continuous.GreaterThreshold greThr2(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha2 "Controls for stage up/stage down signal interaction"
         annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  CDL.Logical.Sources.Constant                        plaSta2(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  CDL.Logical.TrueDelay truDel2(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,-240},{-100,-220}})));
  CDL.Conversions.IntegerToReal                        intToRea2
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol2(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));
  CDL.Conversions.RealToInteger                        reaToInt2
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  CDL.Integers.Add addInt4(k1=+1)
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));
  CDL.Integers.Add addInt5(k2=-1)
    annotation (Placement(transformation(extent={{140,-220},{160,-200}})));
  CDL.Continuous.Sources.TimeTable timeTable3
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  CDL.Continuous.GreaterThreshold greThr3(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));
  CDL.Logical.Sources.Constant noStaChaSig(final k=false)
    "No stage change signal"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
protected
  CDL.Integers.Sources.Constant                        u(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
protected
  CDL.Integers.Sources.Constant step(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));
protected
  CDL.Integers.Sources.Constant                        u1(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
protected
  CDL.Integers.Sources.Constant step1(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
protected
  CDL.Integers.Sources.Constant                        u2(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
protected
  CDL.Integers.Sources.Constant step2(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
equation
  connect(plaSta.y, truDel.u)
    annotation (Line(points={{-138,130},{-122,130}}, color={255,0,255}));
  connect(cha.uIni, u.y) annotation (Line(points={{-42,180},{-60,180},{-60,250},
          {-98,250}}, color={255,127,0}));
  connect(timeTable.y[1], greThr.u)
    annotation (Line(points={{-138,210},{-122,210}}, color={0,0,127}));
  connect(timeTable1.y[1], greThr1.u)
    annotation (Line(points={{-138,10},{-122,10}}, color={0,0,127}));
  connect(cha.ySta, intToRea.u) annotation (Line(points={{-18,174},{0,174},{0,170},
          {18,170}}, color={255,127,0}));
  connect(intToRea.y, zerOrdHol.u)
    annotation (Line(points={{42,170},{58,170}}, color={0,0,127}));
  connect(zerOrdHol.y, reaToInt.u)
    annotation (Line(points={{82,170},{98,170}}, color={0,0,127}));
  connect(reaToInt.y, addInt.u2) annotation (Line(points={{122,170},{130,170},{130,
          184},{138,184}}, color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{122,170},{130,170},{
          130,156},{138,156}}, color={255,127,0}));
  connect(step.y, addInt.u1) annotation (Line(points={{122,210},{130,210},{130,196},
          {138,196}}, color={255,127,0}));
  connect(step.y, addInt1.u2) annotation (Line(points={{122,210},{126,210},{126,
          144},{138,144}}, color={255,127,0}));
  connect(addInt.y, cha.uAvaUp) annotation (Line(points={{162,190},{170,190},{170,
          230},{-50,230},{-50,176},{-42,176}}, color={255,127,0}));
  connect(addInt1.y, cha.uAvaDow) annotation (Line(points={{162,150},{170,150},{
          170,130},{-50,130},{-50,172},{-42,172}}, color={255,127,0}));
  connect(truDel.y, cha.uPla) annotation (Line(points={{-98,130},{-70,130},{-70,
          160},{-42,160}}, color={255,0,255}));
  connect(plaSta1.y, truDel1.u)
    annotation (Line(points={{-138,-50},{-122,-50}}, color={255,0,255}));
  connect(cha1.uIni, u1.y) annotation (Line(points={{-42,0},{-60,0},{-60,70},{-98,
          70}}, color={255,127,0}));
  connect(cha1.ySta, intToRea1.u) annotation (Line(points={{-18,-6},{0,-6},{0,-10},
          {18,-10}}, color={255,127,0}));
  connect(intToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{42,-10},{58,-10}}, color={0,0,127}));
  connect(zerOrdHol1.y, reaToInt1.u)
    annotation (Line(points={{82,-10},{98,-10}}, color={0,0,127}));
  connect(reaToInt1.y, addInt2.u2) annotation (Line(points={{122,-10},{130,-10},
          {130,4},{138,4}}, color={255,127,0}));
  connect(reaToInt1.y, addInt3.u1) annotation (Line(points={{122,-10},{130,-10},
          {130,-24},{138,-24}}, color={255,127,0}));
  connect(step1.y, addInt2.u1) annotation (Line(points={{122,30},{130,30},{130,16},
          {138,16}}, color={255,127,0}));
  connect(step1.y, addInt3.u2) annotation (Line(points={{122,30},{126,30},{126,-36},
          {138,-36}}, color={255,127,0}));
  connect(addInt2.y, cha1.uAvaUp) annotation (Line(points={{162,10},{170,10},{170,
          50},{-50,50},{-50,-4},{-42,-4}}, color={255,127,0}));
  connect(addInt3.y, cha1.uAvaDow) annotation (Line(points={{162,-30},{170,-30},
          {170,-50},{-50,-50},{-50,-8},{-42,-8}}, color={255,127,0}));
  connect(truDel1.y, cha1.uPla) annotation (Line(points={{-98,-50},{-70,-50},{-70,
          -20},{-42,-20}}, color={255,0,255}));
  connect(timeTable2.y[1], greThr2.u)
    annotation (Line(points={{-138,-150},{-122,-150}}, color={0,0,127}));
  connect(plaSta2.y, truDel2.u)
    annotation (Line(points={{-138,-230},{-122,-230}}, color={255,0,255}));
  connect(cha2.uIni, u2.y) annotation (Line(points={{-42,-180},{-60,-180},{-60,-110},
          {-98,-110}}, color={255,127,0}));
  connect(cha2.ySta, intToRea2.u) annotation (Line(points={{-18,-186},{0,-186},{
          0,-190},{18,-190}}, color={255,127,0}));
  connect(intToRea2.y, zerOrdHol2.u)
    annotation (Line(points={{42,-190},{58,-190}}, color={0,0,127}));
  connect(zerOrdHol2.y, reaToInt2.u)
    annotation (Line(points={{82,-190},{98,-190}}, color={0,0,127}));
  connect(reaToInt2.y, addInt4.u2) annotation (Line(points={{122,-190},{130,-190},
          {130,-176},{138,-176}}, color={255,127,0}));
  connect(reaToInt2.y, addInt5.u1) annotation (Line(points={{122,-190},{130,-190},
          {130,-204},{138,-204}}, color={255,127,0}));
  connect(step2.y, addInt4.u1) annotation (Line(points={{122,-150},{130,-150},{130,
          -164},{138,-164}}, color={255,127,0}));
  connect(step2.y, addInt5.u2) annotation (Line(points={{122,-150},{126,-150},{126,
          -216},{138,-216}}, color={255,127,0}));
  connect(addInt4.y, cha2.uAvaUp) annotation (Line(points={{162,-170},{170,-170},
          {170,-130},{-50,-130},{-50,-184},{-42,-184}}, color={255,127,0}));
  connect(addInt5.y, cha2.uAvaDow) annotation (Line(points={{162,-210},{170,-210},
          {170,-230},{-50,-230},{-50,-188},{-42,-188}}, color={255,127,0}));
  connect(truDel2.y, cha2.uPla) annotation (Line(points={{-98,-230},{-70,-230},{
          -70,-200},{-42,-200}}, color={255,0,255}));
  connect(timeTable3.y[1], greThr3.u)
    annotation (Line(points={{-138,-190},{-122,-190}}, color={0,0,127}));
  connect(noStaChaSig.y, cha.uDow) annotation (Line(points={{-178,90},{-170,90},
          {-170,164},{-42,164}}, color={255,0,255}));
  connect(noStaChaSig.y, cha1.uUp) annotation (Line(points={{-178,90},{-170,90},
          {-170,40},{-80,40},{-80,-12},{-42,-12}}, color={255,0,255}));
  connect(greThr1.y, cha1.uDow) annotation (Line(points={{-98,10},{-90,10},{-90,
          -16},{-42,-16}}, color={255,0,255}));
  connect(greThr.y, cha.uUp) annotation (Line(points={{-98,210},{-70,210},{-70,168},
          {-42,168}}, color={255,0,255}));
  connect(greThr2.y, cha2.uUp) annotation (Line(points={{-98,-150},{-80,-150},{-80,
          -192},{-42,-192}}, color={255,0,255}));
  connect(greThr3.y, cha2.uDow) annotation (Line(points={{-98,-190},{-90,-190},{
          -90,-196},{-42,-196}}, color={255,0,255}));
annotation (
 experiment(StopTime=20000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Change_WSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,280}})));
end Change;
