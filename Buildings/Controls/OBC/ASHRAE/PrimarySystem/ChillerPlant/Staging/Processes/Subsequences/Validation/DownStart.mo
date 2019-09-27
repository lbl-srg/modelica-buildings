within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DownStart "Validate sequence of start staging down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staStaDow
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15, final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn[2](final k=true)
    "Operating chiller one"
    annotation (Placement(transformation(extent={{-260,90},{-240,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{-260,130},{-240,150}})));
  CDL.Integers.Sources.Constant nexEnaChi(final k=0) "Next enabling chiller"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR(
    final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-260,12},{-240,32}})));

  CDL.Continuous.Sources.Constant chiFlo(final k=2) "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  CDL.Logical.Sources.Constant chiHea[2](final k=true)
    "Chiller head pressure control"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
  CDL.Continuous.Sources.Constant chiIsoVal[2](final k=1)
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));
  CDL.Continuous.Sources.Constant nexDisChi(final k=2) "Next disable chiller"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  CDL.Continuous.Sources.Constant zer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-238,220},{-222,220}}, color={255,0,255}));

  connect(staDow.y, swi.u2) annotation (Line(points={{-198,220},{-190,220},{
          -190,-160},{-182,-160}}, color={255,0,255}));
  connect(nexDisChi.y, swi.u1) annotation (Line(points={{-238,-140},{-200,-140},
          {-200,-152},{-182,-152}}, color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-238,-180},{-200,-180},{-200,
          -168},{-182,-168}}, color={0,0,127}));
annotation (
 experiment(StopTime=600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DownStart.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-280,-260},{280,260}}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-260},{280,
            260}})));
end DownStart;
