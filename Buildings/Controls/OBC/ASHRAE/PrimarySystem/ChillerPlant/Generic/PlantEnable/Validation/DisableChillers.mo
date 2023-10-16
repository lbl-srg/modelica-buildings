within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model DisableChillers
  "Validation sequence for disabling chillers and the associated devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers disDev(
    have_WSE=true)
    "Disable chillers and the associated devices"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staPro(final k=false)
    "Staging change process"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
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
    annotation (Placement(transformation(extent={{-62,40},{-42,60}})));

equation
  connect(wseSta.y, disDev.uWSE) annotation (Line(points={{-58,80},{40,80},{40,19},
          {58,19}}, color={255,0,255}));
  connect(chiSta.y, disDev.uChi) annotation (Line(points={{-40,50},{36,50},{36,
          17},{58,17}},
                    color={255,0,255}));
  connect(chiSta.y, disDev.uChiWatReq) annotation (Line(points={{-40,50},{32,50},
          {32,15},{58,15}}, color={255,0,255}));
  connect(chiIsoVal.y, disDev.uChiWatIsoVal) annotation (Line(points={{-58,20},{
          24,20},{24,13},{58,13}}, color={0,0,127}));
  connect(chiSta.y, disDev.uConWatReq) annotation (Line(points={{-40,50},{28,50},
          {28,10},{58,10}}, color={255,0,255}));
  connect(pumSpe.y, disDev.uConWatPumSpe) annotation (Line(points={{-58,-40},{
          36,-40},{36,3},{58,3}},
                               color={0,0,127}));
  connect(staPro.y, disDev.chaPro) annotation (Line(points={{-18,-60},{40,-60},
          {40,1},{58,1}},color={255,0,255}));
  connect(conIsoVal1.y, disDev.uConWatIsoVal) annotation (Line(points={{-38,-10},
          {24,-10},{24,7},{58,7}}, color={0,0,127}));
  connect(pumSpe.y, disDev.uChiWatPumSpe) annotation (Line(points={{-58,-40},{
          32,-40},{32,5},{58,5}},
                               color={0,0,127}));
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
