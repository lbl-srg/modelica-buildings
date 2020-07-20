within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.Validation;
model EnableBoiler
    "Validate sequence of enabling and disabling boiler"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.EnableBoiler
    enaDisBoi(
    final nBoi=3)
    "Enable larger boiler and disable smaller boiler"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.EnableBoiler
    enaOneBoi(
    final nBoi=3)
    "Enable additional boiler"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=10)
    "Hold pulse signal for visualization"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=10)
    "Hold pulse signal for visualization"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not staUp
    "Stage up command"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not boiIsoVal
    "Hot water isolation valve resetting status"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaBoi(
    final k=3)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiOne(
    final k=true)
    "Operating boiler one"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=true)
    "Requires one boiler on and another boiler off"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disBoi(
    final k=2)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre boiStaRet[2]
    "Boiler status return value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch boiTwo
    "Boiler two status"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre boiStaRet1
    "Boiler status return value"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(
    final k=false)
    "Does not requires one boiler on and another boiler off"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disBoi1(
    final k=1)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-178,60},{-162,60}}, color={255,0,255}));

  connect(booPul1.y,boiIsoVal. u)
    annotation (Line(points={{-178,20},{-162,20}}, color={255,0,255}));

  connect(staUp.y,enaDisBoi. uStaUp)
    annotation (Line(points={{-138,60},{-120,60},{-120,86},{-82,86}},
      color={255,0,255}));

  connect(boiIsoVal.y,boiTwo. u2)
    annotation (Line(points={{-138,20},{-116,20},{-116,-40},{-42,-40}},
      color={255,0,255}));

  connect(boiOne.y,boiTwo. u3)
    annotation (Line(points={{-138,-20},{-112,-20},{-112,-48},{-42,-48}},
      color={255,0,255}));

  connect(onOff.y,enaDisBoi. uOnOff)
    annotation (Line(points={{-138,-60},{-100,-60},{-100,74},{-82,74}},
      color={255,0,255}));

  connect(staUp.y,enaOneBoi. uStaUp)
    annotation (Line(points={{-138,60},{40,60},{40,86},{98,86}},
      color={255,0,255}));

  connect(noOnOff.y,enaOneBoi. uOnOff)
    annotation (Line(points={{42,-60},{56,-60},{56,74},{98,74}},
      color={255,0,255}));

  connect(enaBoi.y, enaDisBoi.nexEnaBoi) annotation (Line(points={{-138,100},{-120,
          100},{-120,89},{-82,89}}, color={255,127,0}));

  connect(boiIsoVal.y, enaDisBoi.uUpsDevSta) annotation (Line(points={{-138,20},
          {-116,20},{-116,82},{-82,82}}, color={255,0,255}));

  connect(boiOne.y, enaDisBoi.uBoi[1]) annotation (Line(points={{-138,-20},{
          -112,-20},{-112,76.6667},{-82,76.6667}},
                                              color={255,0,255}));

  connect(boiTwo.y, enaDisBoi.uBoi[2]) annotation (Line(points={{-18,-40},{-10,-40},
          {-10,40},{-108,40},{-108,78},{-82,78}}, color={255,0,255}));

  connect(enaDisBoi.yBoi[2], boiStaRet[1].u) annotation (Line(points={{-58,88},{
          -56,88},{-56,80},{-42,80}}, color={255,0,255}));

  connect(boiStaRet[1].y, boiTwo.u1) annotation (Line(points={{-18,80},{0,80},{0,
          0},{-60,0},{-60,-32},{-42,-32}}, color={255,0,255}));

  connect(enaDisBoi.yBoi[3], boiStaRet[2].u) annotation (Line(points={{-58,
          89.3333},{-52,89.3333},{-52,80},{-42,80}}, color={255,0,255}));

  connect(boiStaRet[2].y, enaDisBoi.uBoi[3]) annotation (Line(points={{-18,80},
          {0,80},{0,66},{-104,66},{-104,79.3333},{-82,79.3333}},color={255,0,255}));

  connect(disBoi.y, enaDisBoi.nexDisBoi) annotation (Line(points={{-138,-100},{-90,
          -100},{-90,71},{-82,71}}, color={255,127,0}));

  connect(enaBoi.y, enaOneBoi.nexEnaBoi) annotation (Line(points={{-138,100},{80,
          100},{80,89},{98,89}}, color={255,127,0}));

  connect(enaOneBoi.yBoi[3], boiStaRet1.u) annotation (Line(points={{122,
          89.3333},{130,89.3333},{130,80},{138,80}},
                                            color={255,0,255}));

  connect(boiOne.y, enaOneBoi.uBoi[1]) annotation (Line(points={{-138,-20},{50,
          -20},{50,76.6667},{98,76.6667}},
                                      color={255,0,255}));

  connect(boiOne.y, enaOneBoi.uBoi[2]) annotation (Line(points={{-138,-20},{50,-20},
          {50,78},{98,78}}, color={255,0,255}));

  connect(boiStaRet1.y, enaOneBoi.uBoi[3]) annotation (Line(points={{162,80},{
          180,80},{180,60},{80,60},{80,79.3333},{98,79.3333}},
                                                           color={255,0,255}));

  connect(boiIsoVal.y, enaOneBoi.uUpsDevSta) annotation (Line(points={{-138,20},
          {46,20},{46,82},{98,82}}, color={255,0,255}));

  connect(disBoi1.y, enaOneBoi.nexDisBoi) annotation (Line(points={{42,-100},{60,
          -100},{60,71},{98,71}}, color={255,127,0}));

  connect(enaDisBoi.yBoiEnaPro, truFalHol.u) annotation (Line(points={{-58,72},
          {-50,72},{-50,120},{-42,120}}, color={255,0,255}));

  connect(enaOneBoi.yBoiEnaPro, truFalHol1.u) annotation (Line(points={{122,72},
          {132,72},{132,120},{138,120}}, color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Subsequences/Validation/EnableBoiler.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.EnableBoiler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.EnableBoiler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 08, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,140}})));
end EnableBoiler;
