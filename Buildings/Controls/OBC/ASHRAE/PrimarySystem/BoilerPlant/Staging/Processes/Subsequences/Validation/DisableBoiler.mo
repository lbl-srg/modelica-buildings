within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.Validation;
model DisableBoiler
    "Validate sequence of disabling boiler during stage-down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler
    boiOnOff(
    final nBoi=3,
    final proOnTim=300)
    "Disable a boiler and enable another boiler"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler
    boiOff(
    final nBoi=3,
    final proOnTim=300)
    "Disable boiler"
    annotation (Placement(transformation(extent={{102,70},{122,90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=10)
    "Hold boolean pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=10)
    "Hold boolean pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{170,90},{190,110}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not staCha
    "Stage change command"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta
    "Upstream device status"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiOne(
    final k=true)
    "Operating boiler one"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaBoi(
    final k=3)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch boiTwo
    "Boiler two status"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=true)
    "Requires one boiler on and another boiler off"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disBoi(
    final k=2)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaBoi1(
    final k=1)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(
    final k=false)
    "Does not requires one boiler on and another boiler off"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch boiTwo1
    "Boiler two status"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre boiStaRet[2]
    "Boiler status return value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre boiStaRet1[2]
    "Boiler status return value"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,60},{-162,60}}, color={255,0,255}));

  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,20},{-162,20}}, color={255,0,255}));

  connect(enaBoi.y, boiOnOff.nexEnaBoi) annotation (Line(points={{-138,100},{-100,
          100},{-100,89},{-82,89}}, color={255,127,0}));

  connect(staCha.y,boiOnOff. uStaDow)
    annotation (Line(points={{-138,60},{-124,60},{-124,86},{-82,86}},
      color={255,0,255}));

  connect(upsDevSta.y,boiOnOff. uUpsDevSta) annotation (Line(points={{-138,20},
          {-116,20},{-116,82},{-82,82}}, color={255,0,255}));

  connect(boiOne.y,boiOnOff. uBoi[1]) annotation (Line(points={{-138,-20},{-108,
          -20},{-108,76.6667},{-82,76.6667}}, color={255,0,255}));

  connect(upsDevSta.y,boiTwo. u2)
    annotation (Line(points={{-138,20},{-116,20},{-116,-40},{-42,-40}},
      color={255,0,255}));

  connect(boiOne.y,boiTwo. u3)
    annotation (Line(points={{-138,-20},{-108,-20},{-108,-48},{-42,-48}},
      color={255,0,255}));

  connect(boiStaRet[1].y,boiTwo. u1) annotation (Line(points={{-18,80},{-10,80},
          {-10,0},{-50,0},{-50,-32},{-42,-32}}, color={255,0,255}));

  connect(boiStaRet[2].y,boiOnOff. uBoi[3]) annotation (Line(points={{-18,80},{
          -10,80},{-10,40},{-112,40},{-112,79.3333},{-82,79.3333}}, color={255,
          0,255}));

  connect(boiTwo.y,boiOnOff. uBoi[2]) annotation (Line(points={{-18,-40},{-10,-40},
          {-10,-70},{-120,-70},{-120,78},{-82,78}}, color={255,0,255}));

  connect(disBoi.y,boiOnOff.nexDisBoi)
    annotation (Line(points={{-138,-60},{-104,-60},{-104,75},{-82,75}},
      color={255,127,0}));

  connect(onOff.y,boiOnOff. uOnOff)
    annotation (Line(points={{-138,-100},{-100,-100},{-100,71},{-82,71}},
      color={255,0,255}));

  connect(enaBoi1.y,boiOff.nexEnaBoi)
    annotation (Line(points={{42,100},{80,100},{80,89},{100,89}},
      color={255,127,0}));

  connect(staCha.y,boiOff. uStaDow)
    annotation (Line(points={{-138,60},{56,60},{56,86},{100,86}},
      color={255,0,255}));

  connect(boiOne.y,boiOff. uBoi[1]) annotation (Line(points={{-138,-20},{64,-20},
          {64,76.6667},{100,76.6667}}, color={255,0,255}));

  connect(disBoi.y,boiOff.nexDisBoi)
    annotation (Line(points={{-138,-60},{76,-60},{76,75},{100,75}},
      color={255,127,0}));

  connect(noOnOff.y,boiOff. uOnOff)
    annotation (Line(points={{42,-100},{80,-100},{80,71},{100,71}},
      color={255,0,255}));

  connect(staCha.y,boiTwo1. u2)
    annotation (Line(points={{-138,60},{56,60},{56,-40},{138,-40}},
      color={255,0,255}));

  connect(boiOne.y,boiTwo1. u3)
    annotation (Line(points={{-138,-20},{64,-20},{64,-48},{138,-48}},
      color={255,0,255}));

  connect(boiStaRet1[1].y,boiTwo1. u1) annotation (Line(points={{162,80},{170,
          80},{170,-20},{130,-20},{130,-32},{138,-32}}, color={255,0,255}));

  connect(boiTwo1.y,boiOff. uBoi[2]) annotation (Line(points={{162,-40},{170,-40},
          {170,-70},{68,-70},{68,78},{100,78}}, color={255,0,255}));

  connect(boiStaRet1[2].y,boiOff. uBoi[3]) annotation (Line(points={{162,80},{
          170,80},{170,40},{72,40},{72,79.3333},{100,79.3333}}, color={255,0,
          255}));


  connect(boiOnOff.yBoi[2], boiStaRet[1].u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));

  connect(boiOnOff.yBoi[3], boiStaRet[2].u) annotation (Line(points={{-58,
          81.3333},{-52,81.3333},{-52,80},{-42,80}},
                                            color={255,0,255}));

  connect(boiOff.yBoi[2], boiStaRet1[1].u)
    annotation (Line(points={{124,80},{138,80}}, color={255,0,255}));

  connect(boiOff.yBoi[3], boiStaRet1[2].u) annotation (Line(points={{124,
          81.3333},{130,81.3333},{130,80},{138,80}},
                                            color={255,0,255}));

  connect(boiOnOff.yBoiDisPro, truFalHol.u) annotation (Line(points={{-58,72},{-48,
          72},{-48,100},{-12,100}}, color={255,0,255}));

  connect(boiOff.yBoiDisPro, truFalHol1.u) annotation (Line(points={{124,72},{134,
          72},{134,100},{168,100}}, color={255,0,255}));

  connect(upsDevSta.y, boiOff.uUpsDevSta) annotation (Line(points={{-138,20},{
          60,20},{60,82},{100,82}}, color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Subsequences/Validation/DisableBoiler.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, by Karthik Devaprasad:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{220,120}})));
end DisableBoiler;
