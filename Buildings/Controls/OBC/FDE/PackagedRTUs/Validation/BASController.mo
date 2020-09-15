within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model BASController "This model simulates BASController"
  Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller basCont(
    pBldgSPset=3,
    pTotalTU=12,
    minSATset=285.15,
    maxSATset=297.15,
    HeatSet=308.15,
    maxDDSPset=500,
    minDDSPset=150)
    annotation (Placement(transformation(extent={{46,-2},{66,24}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  OccGen(
  width=0.5,
  period=2880)
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter
  OccReqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,44},{-48,56}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  booPul(
    width=0.0125,
    period=800,
    startTime=1220)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  booPul1(
    width=0.000875,
    period=150,
    startTime=1000)
    annotation (Placement(transformation(extent={{-90,6},{-70,26}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  booPul2(
    width=0.000275,
    period=150,
    startTime=2800)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter
  SBCreqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,10},{-48,22}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter
  SBHreqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,-22},{-48,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    width=0.25,
    period=680,
    startTime=1000)
    annotation (Placement(transformation(extent={{-90,-58},{-70,-38}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter
  totCoolReqsGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,-54},{-48,-42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine
  highSpaceTGen(
    amplitude=5,
    freqHz=1/3600,
    offset=27 + 273.15,
    startTime=1250)
    annotation (Placement(transformation(extent={{-90,-88},{-70,-68}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine
  mostOpenDamGen(
    amplitude=10,
    freqHz=1/4120,
    offset=90)
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant
  con(k=false)
    annotation (Placement(transformation(extent={{-128,-72},{-108,-52}})));
equation
  connect(OccReqGen.trigger, booPul.y)
    annotation (Line(points={{-61.2,50},{-68,50}}, color={255,0,255}));
  connect(booPul1.y, SBCreqGen.trigger)
    annotation (Line(points={{-68,16},{-61.2,16}}, color={255,0,255}));
  connect(booPul2.y, SBHreqGen.trigger)
    annotation (Line(points={{-68,-16},{-61.2,-16}}, color={255,0,255}));
  connect(booPul3.y, totCoolReqsGen.trigger)
    annotation (Line(points={{-68,-48},{-61.2,-48}}, color={255,0,255}));
  connect(OccReqGen.reset, OccGen.y) annotation (Line(points={{-54,42.8},
          {-42,42.8},{-42,82},{-68,82}}, color={255,0,255}));
  connect(SBHreqGen.reset, SBCreqGen.reset) annotation (Line(points={{-54,
          -23.2},{-54,-28},{-42,-28},{-42,4},{-54,4},{-54,8.8}}, color={
          255,0,255}));
  connect(SBHreqGen.reset, OccGen.y) annotation (Line(points={{-54,-23.2},
          {-54,-28},{-42,-28},{-42,82},{-68,82}}, color={255,0,255}));
  connect(con.y, totCoolReqsGen.reset) annotation (Line(points={{-106,-62},
          {-54,-62},{-54,-55.2}}, color={255,0,255}));
  connect(OccGen.y, basCont.occ) annotation (Line(points={{-68,82},{-4,82},{-4,
          21.4},{44,21.4}}, color={255,0,255}));
  connect(OccReqGen.y, basCont.occReq) annotation (Line(points={{-46.8,50},{-8,
          50},{-8,18.02},{44,18.02}}, color={255,127,0}));
  connect(SBCreqGen.y, basCont.sbcReq) annotation (Line(points={{-46.8,16},{-12,
          16},{-12,14},{16,14},{16,14.64},{44,14.64}}, color={255,127,0}));
  connect(SBHreqGen.y, basCont.sbhReq) annotation (Line(points={{-46.8,-16},{
          -16,-16},{-16,11},{44,11}}, color={255,127,0}));
  connect(totCoolReqsGen.y, basCont.totCoolReqs) annotation (Line(points={{
          -46.8,-48},{-12,-48},{-12,7.36},{44,7.36}}, color={255,127,0}));
  connect(highSpaceTGen.y, basCont.highSpaceT) annotation (Line(points={{-68,
          -78},{-8,-78},{-8,3.98},{44,3.98}}, color={0,0,127}));
  connect(mostOpenDamGen.y, basCont.mostOpenDam) annotation (Line(points={{-68,
          -110},{-4,-110},{-4,0.6},{44,0.6}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=5760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/Validation/BASController.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller\">
Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>August 21, 2020, by Henry Nickels:<br/>
Built simulation script.</li>
<li>August 16, 2020, by Henry Nickels:<br/>
Added 'experiment' annotation.</li>
<li>July 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>
"));
end BASController;
