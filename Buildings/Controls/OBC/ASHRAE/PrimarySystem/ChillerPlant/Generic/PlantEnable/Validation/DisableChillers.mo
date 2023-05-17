within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model DisableChillers
  "Validation sequence for disabling chillers and the associated devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.DisableChillers disDev
    "Disable chillers and the associated devices"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.6,
    final period=3600)
    "Enabled plant"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k={true,false})
    "Enabled chiller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.7,
    final period=3600)
    "Chilled water request"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiIsoVal[2](
    final k={1,0})
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.7,
    final period=3600)
    "Condenser water request"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conIsoVal1[2](
    final k={1,0})
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe[2](
    final k={0.75,0}) "Pumps speed"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation
  connect(booPul.y, disDev.uPla) annotation (Line(points={{-18,50},{-5,50},{-5,37},
          {58,37}}, color={255,0,255}));
  connect(con.y, disDev.uChi) annotation (Line(points={{-58,80},{40,80},{40,39},
          {58,39}}, color={255,0,255}));
  connect(booPul2.y, disDev.uChiWatReq[1]) annotation (Line(points={{-58,20},{2,
          20},{2,34},{58,34}}, color={255,0,255}));
  connect(con[2].y, disDev.uChiWatReq[2]) annotation (Line(points={{-58,80},{2,80},
          {2,34},{58,34}}, color={255,0,255}));
  connect(chiIsoVal.y, disDev.uChiWatIsoVal) annotation (Line(points={{-18,0},{12,
          0},{12,32},{58,32}}, color={0,0,127}));
  connect(booPul3.y, disDev.uConWatReq[1]) annotation (Line(points={{-58,-20},{22,
          -20},{22,28},{58,28}}, color={255,0,255}));
  connect(con[2].y, disDev.uConWatReq[2]) annotation (Line(points={{-58,80},{40,
          80},{40,28},{58,28}}, color={255,0,255}));
  connect(conIsoVal1.y, disDev.uConWatIsoVal) annotation (Line(points={{-18,-50},
          {32,-50},{32,26},{58,26}}, color={0,0,127}));
  connect(pumSpe.y, disDev.uChiWatPumSpe) annotation (Line(points={{-58,-80},{40,
          -80},{40,23},{58,23}}, color={0,0,127}));
  connect(pumSpe.y, disDev.uConWatPumSpe) annotation (Line(points={{-58,-80},{40,
          -80},{40,21},{58,21}}, color={0,0,127}));
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
