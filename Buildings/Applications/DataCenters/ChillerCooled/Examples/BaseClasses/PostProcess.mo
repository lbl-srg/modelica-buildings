within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PostProcess "Post-processing"

  Buildings.Utilities.Math.IntegratorWithReset FCHou(k=1/3600)
    "Free cooling hours"
    annotation (Placement(transformation(extent={{-300,80},{-320,100}})));
  Modelica.Blocks.Sources.RealExpression freCooSig "Free cooling signal"
    annotation (Placement(transformation(extent={{-260,80},{-280,100}})));
  Modelica.Blocks.Sources.RealExpression parMecCooSig
    "Partial mechanic cooling signal"
    annotation (Placement(transformation(extent={{-260,40},{-280,60}})));
  Buildings.Utilities.Math.IntegratorWithReset PMCHou(k=1/3600)
    "Partial mechanic cooling hours"
    annotation (Placement(transformation(extent={{-300,40},{-320,60}})));
  Buildings.Utilities.Math.IntegratorWithReset FMCHou(k=1/3600)
    "Full mechanic cooling hours"
    annotation (Placement(transformation(extent={{-300,0},{-320,20}})));
  Modelica.Blocks.Sources.RealExpression fulMecCooSig
    "Full mechanic cooling signal"
    annotation (Placement(transformation(extent={{-260,0},{-280,20}})));
  Modelica.Blocks.Sources.RealExpression PHVAC
   "Power consumed by HVAC system"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-270,-50})));
  Modelica.Blocks.Sources.RealExpression PIT
    "Power consumed by IT"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-270,-90})));
  Modelica.Blocks.Continuous.Integrator EHVAC(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by HVAC"
    annotation (Placement(transformation(extent={{-300,-60},{-320,-40}})));
  Modelica.Blocks.Continuous.Integrator EIT(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{-300,-100},{-320,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain HVAC_kWh(k=1/3600000)
    "Energy consumed by HVAC in kWh"
    annotation (Placement(transformation(extent={{-340,-60},{-360,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain IT_kWh(k=1/3600000)
    "Energy consumed by IT in kWh"
    annotation (Placement(transformation(extent={{-340,-100},{-360,-80}})));
  Modelica.Blocks.Math.IntegerChange sigCha "Signal changes"
    annotation (Placement(transformation(extent={{-258,150},{-278,170}})));
  Modelica.Blocks.MathInteger.TriggeredAdd swiTim "Triggered addition"
    annotation (Placement(transformation(extent={{-300,186},{-320,206}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1)
    "Unit signal"
    annotation (Placement(transformation(extent={{-260,186},{-280,206}})));
equation
  connect(freCooSig.y, FCHou.u)
    annotation (Line(points={{-281,90},{-298,90}}, color={0,0,127}));
  connect(parMecCooSig.y, PMCHou.u)
    annotation (Line(points={{-281,50},{-298,50}}, color={0,0,127}));
  connect(fulMecCooSig.y, FMCHou.u)
    annotation (Line(points={{-281,10},{-298,10}}, color={0,0,127}));
  connect(PHVAC.y,EHVAC. u) annotation (Line(
      points={{-281,-50},{-298,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y,EIT. u) annotation (Line(
      points={{-281,-90},{-298,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EHVAC.y,HVAC_kWh. u)
    annotation (Line(points={{-321,-50},{-338,-50}},
                                                   color={0,0,127}));
  connect(IT_kWh.u,EIT. y)
    annotation (Line(points={{-338,-90},{-321,-90}},
                                                   color={0,0,127}));
  connect(sigCha.y, swiTim.trigger) annotation (Line(points={{-279,160},{-304,160},
          {-304,184}}, color={255,0,255}));
  connect(conInt.y, swiTim.u)
    annotation (Line(points={{-281,196},{-296,196}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-420,-200},
            {100,220}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-420,-200},{100,220}}),
        graphics={Rectangle(
          extent={{-420,220},{-248,-200}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{-406,-164},{-298,-192}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing"),
        Text(
          extent={{-418,132},{-330,90}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textString="Economizing Hours",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{-416,4},{-322,-40}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textString="Energy Consumption",
          textStyle={TextStyle.Bold,TextStyle.Italic}),
        Text(
          extent={{-430,232},{-342,190}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textString="Switch Times",
          textStyle={TextStyle.Bold,TextStyle.Italic})}));
end PostProcess;
