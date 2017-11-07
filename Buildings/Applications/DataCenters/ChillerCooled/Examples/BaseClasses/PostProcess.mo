within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PostProcess "Post-processing"

  Buildings.Utilities.Math.IntegratorWithReset FCHou(k=1/3600)
    "Free cooling hours"
    annotation (Placement(transformation(extent={{380,80},{400,100}})));
  Modelica.Blocks.Sources.RealExpression freCooSig "Free cooling signal"
    annotation (Placement(transformation(extent={{320,80},{340,100}})));
  Modelica.Blocks.Sources.RealExpression parMecCooSig
    "Partial mechanic cooling signal"
    annotation (Placement(transformation(extent={{320,40},{340,60}})));
  Buildings.Utilities.Math.IntegratorWithReset PMCHou(k=1/3600)
    "Partial mechanic cooling hours"
    annotation (Placement(transformation(extent={{380,40},{400,60}})));
  Buildings.Utilities.Math.IntegratorWithReset FMCHou(k=1/3600)
    "Full mechanic cooling hours"
    annotation (Placement(transformation(extent={{380,0},{400,20}})));
  Modelica.Blocks.Sources.RealExpression fulMecCooSig
    "Full mechanic cooling signal"
    annotation (Placement(transformation(extent={{320,0},{340,20}})));
  Modelica.Blocks.Sources.RealExpression PHVAC
   "Power consumed by HVAC system"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={330,-50})));
  Modelica.Blocks.Sources.RealExpression PIT
    "Power consumed by IT"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={330,-90})));
  Modelica.Blocks.Continuous.Integrator EHVAC(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by HVAC"
    annotation (Placement(transformation(extent={{380,-60},{400,-40}})));
  Modelica.Blocks.Continuous.Integrator EIT(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{380,-100},{400,-80}})));
  Modelica.Blocks.Math.IntegerChange sigCha(u(start=0, fixed=true))
                                            "Signal changes"
    annotation (Placement(transformation(extent={{320,150},{340,170}})));
  Modelica.Blocks.MathInteger.TriggeredAdd swiTim "Triggered addition"
    annotation (Placement(transformation(extent={{380,186},{400,206}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1)
    "Unit signal"
    annotation (Placement(transformation(extent={{320,186},{340,206}})));
equation
  connect(freCooSig.y, FCHou.u)
    annotation (Line(points={{341,90},{378,90}},   color={0,0,127}));
  connect(parMecCooSig.y, PMCHou.u)
    annotation (Line(points={{341,50},{378,50}},   color={0,0,127}));
  connect(fulMecCooSig.y, FMCHou.u)
    annotation (Line(points={{341,10},{378,10}},   color={0,0,127}));
  connect(PHVAC.y,EHVAC. u) annotation (Line(
      points={{341,-50},{378,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y,EIT. u) annotation (Line(
      points={{341,-90},{378,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sigCha.y, swiTim.trigger) annotation (Line(points={{341,160},{384,160},
          {384,184}},  color={255,0,255}));
  connect(conInt.y, swiTim.u)
    annotation (Line(points={{341,196},{376,196}},   color={255,127,0}));
  annotation (Diagram(coordinateSystem(extent={{-100,-200},{300,220}}),
        graphics={Rectangle(
          extent={{300,220},{460,-200}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{314,-164},{422,-192}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing"),
        Text(
          extent={{464,146},{376,104}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=10,
          textString="Economizing Hours",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{370,0},{464,-44}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=10,
          textString="Energy Consumption",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{386,232},{474,190}},
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
