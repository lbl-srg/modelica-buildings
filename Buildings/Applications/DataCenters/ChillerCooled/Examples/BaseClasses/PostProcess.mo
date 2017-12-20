within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PostProcess "Post-processing"

  Buildings.Utilities.Math.IntegratorWithReset FCTim "Free cooling time"
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Modelica.Blocks.Sources.RealExpression freCooSig "Free cooling signal"
    annotation (Placement(transformation(extent={{180,80},{200,100}})));
  Modelica.Blocks.Sources.RealExpression parMecCooSig
    "Partial mechanic cooling signal"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Buildings.Utilities.Math.IntegratorWithReset PMCTim
    "Partial mechanic cooling time"
    annotation (Placement(transformation(extent={{240,40},{260,60}})));
  Buildings.Utilities.Math.IntegratorWithReset FMCHou
    "Full mechanic cooling time"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));
  Modelica.Blocks.Sources.RealExpression fulMecCooSig
    "Full mechanic cooling signal"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));
  Modelica.Blocks.Sources.RealExpression PHVAC
   "Power consumed by HVAC system"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={190,-50})));
  Modelica.Blocks.Sources.RealExpression PIT
    "Power consumed by IT"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={190,-90})));
  Modelica.Blocks.Continuous.Integrator EHVAC(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0)
    "Energy consumed by HVAC"
    annotation (Placement(transformation(extent={{240,-60},{260,-40}})));
  Modelica.Blocks.Continuous.Integrator EIT(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0)
    "Energy consumed by IT"
    annotation (Placement(transformation(extent={{240,-100},{260,-80}})));
  Modelica.Blocks.Math.IntegerChange sigCha(
    u(start=0, fixed=true))
    "Signal changes"
    annotation (Placement(transformation(extent={{180,150},{200,170}})));
  Modelica.Blocks.MathInteger.TriggeredAdd swiTim "Triggered addition"
    annotation (Placement(transformation(extent={{240,186},{260,206}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1)
    "Unit signal"
    annotation (Placement(transformation(extent={{180,186},{200,206}})));
equation
  connect(freCooSig.y,FCTim. u)
    annotation (Line(points={{201,90},{238,90}},   color={0,0,127}));
  connect(parMecCooSig.y,PMCTim. u)
    annotation (Line(points={{201,50},{238,50}},   color={0,0,127}));
  connect(fulMecCooSig.y, FMCHou.u)
    annotation (Line(points={{201,10},{238,10}},   color={0,0,127}));
  connect(PHVAC.y,EHVAC. u) annotation (Line(
      points={{201,-50},{238,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y,EIT. u) annotation (Line(
      points={{201,-90},{238,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sigCha.y, swiTim.trigger) annotation (Line(points={{201,160},{244,160},
          {244,184}},  color={255,0,255}));
  connect(conInt.y, swiTim.u)
    annotation (Line(points={{201,196},{236,196}},   color={255,127,0}));
  annotation (Diagram(coordinateSystem(extent={{-100,-200},{160,220}}),
        graphics={Rectangle(
          extent={{160,220},{320,-200}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{174,-164},{282,-192}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing"),
        Text(
          extent={{324,146},{236,104}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=10,
          textString="Economizing Hours",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{230,0},{324,-44}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=10,
          textString="Energy Consumption",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{246,232},{334,190}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=10,
          textString="Switch Times",
          textStyle={TextStyle.Bold,TextStyle.Italic})}),
    Documentation(info="<html>
<p>
This partial model calculate performance metrics for a data center system.
The performance metrics include cooling mode signal switch times, economizing hours, and total
energy consumption.
</p>
</html>"));
end PostProcess;
