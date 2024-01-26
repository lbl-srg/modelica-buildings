within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model DisableChillers
  "Validation sequence for disabling chillers and the associated devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers
    disPlaFroEco(have_WSE=true)
    "Disable plant from the economizer mode"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers
    disPlaFroChi(have_WSE=false)
    "Disable plant from chiller mode"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staPro(final k=false)
    "Staging change process"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(final width=0.7,
      final period=3600) "Waterside economizer"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiIsoVal[2](
    final k={1,0})
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conIsoVal1[2](
    final k={1,0})
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe[2](
    final k={0.75,0}) "Pumps speed"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta[2](
    final width={0.5,0.01},
    final period={3600,7200},
    shift={0,-100})
    "Chiller status"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

equation
  connect(wseSta.y, disPlaFroEco.uWSE) annotation (Line(points={{-58,80},{48,80},
          {48,59},{58,59}}, color={255,0,255}));
  connect(chiSta.y, disPlaFroEco.uChi) annotation (Line(points={{-38,50},{44,50},
          {44,57},{58,57}}, color={255,0,255}));
  connect(chiSta.y, disPlaFroEco.uChiWatReq) annotation (Line(points={{-38,50},{
          40,50},{40,55},{58,55}}, color={255,0,255}));
  connect(chiIsoVal.y, disPlaFroEco.uChiWatIsoVal) annotation (Line(points={{-58,
          20},{20,20},{20,53},{58,53}}, color={0,0,127}));
  connect(chiSta.y, disPlaFroEco.uConWatReq)
    annotation (Line(points={{-38,50},{58,50}}, color={255,0,255}));
  connect(pumSpe.y, disPlaFroEco.uConWatPumSpe) annotation (Line(points={{-58,-40},
          {32,-40},{32,43},{58,43}}, color={0,0,127}));
  connect(staPro.y, disPlaFroEco.chaPro) annotation (Line(points={{-18,-70},{36,
          -70},{36,41},{58,41}}, color={255,0,255}));
  connect(conIsoVal1.y, disPlaFroEco.uConWatIsoVal) annotation (Line(points={{-38,
          -10},{24,-10},{24,47},{58,47}}, color={0,0,127}));
  connect(pumSpe.y, disPlaFroEco.uChiWatPumSpe) annotation (Line(points={{-58,-40},
          {28,-40},{28,45},{58,45}}, color={0,0,127}));
  connect(chiSta.y, disPlaFroChi.uChi) annotation (Line(points={{-38,50},{44,50},
          {44,-43},{58,-43}}, color={255,0,255}));
  connect(chiSta.y, disPlaFroChi.uChiWatReq) annotation (Line(points={{-38,50},{
          40,50},{40,-45},{58,-45}}, color={255,0,255}));
  connect(chiSta.y, disPlaFroChi.uConWatReq) annotation (Line(points={{-38,50},{
          48,50},{48,-50},{58,-50}}, color={255,0,255}));
  connect(chiIsoVal.y, disPlaFroChi.uChiWatIsoVal) annotation (Line(points={{-58,
          20},{20,20},{20,-47},{58,-47}}, color={0,0,127}));
  connect(conIsoVal1.y, disPlaFroChi.uConWatIsoVal) annotation (Line(points={{-38,
          -10},{24,-10},{24,-53},{58,-53}}, color={0,0,127}));
  connect(pumSpe.y, disPlaFroChi.uChiWatPumSpe) annotation (Line(points={{-58,-40},
          {28,-40},{28,-55},{58,-55}}, color={0,0,127}));
  connect(pumSpe.y, disPlaFroChi.uConWatPumSpe) annotation (Line(points={{-58,-40},
          {32,-40},{32,-57},{58,-57}}, color={0,0,127}));
  connect(staPro.y, disPlaFroChi.chaPro) annotation (Line(points={{-18,-70},{36,
          -70},{36,-59},{58,-59}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/PlantEnable/Validation/DisableChillers.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DisableChillers;
