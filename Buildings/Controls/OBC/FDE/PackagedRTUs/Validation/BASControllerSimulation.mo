within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model BASControllerSimulation "Simulates operation of packaged RTU controller."
  BAScontroller bAScontroller(
    pBldgSPset=0.005,
    pTotalTU=30,
    minSATset=285.15,
    maxSATset=297.15,
    HeatSet=308.15,
    maxDDSPset=0.012056,
    minDDSPset=0.003014)
    annotation (Placement(transformation(extent={{46,-2},{66,24}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen(width=0.5,
      period=2880)
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter OccReqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,44},{-48,56}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.125,
    period=1440,
    startTime=1220)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.875,
    period=1440,
    startTime=2160)
    annotation (Placement(transformation(extent={{-90,6},{-70,26}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.275,
    period=1440,
    startTime=440)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter SBCreqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,10},{-48,22}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter SBHreqGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,-22},{-48,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    width=0.25,
    period=680,
    startTime=1000) annotation (Placement(transformation(extent={{-90,-58},
            {-70,-38}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter totCoolReqsGen(y_start=0)
    annotation (Placement(transformation(extent={{-60,-54},{-48,-42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine highSpaceTGen(
    amplitude=5,
    freqHz=1/3600,
    offset=27 + 273.15) annotation (Placement(transformation(extent={{-90,
            -88},{-70,-68}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
    amplitude=10,
    freqHz=1/4120,
    offset=90) annotation (Placement(transformation(extent={{-90,-120},
            {-70,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
    annotation (Placement(transformation(extent={{-128,-72},{-108,-52}})));
equation
  connect(bAScontroller.Occ, OccGen.y) annotation (Line(points={{44,22},{
          -12,22},{-12,82},{-68,82}}, color={255,0,255}));
  connect(OccReqGen.trigger, booPul.y)
    annotation (Line(points={{-61.2,50},{-68,50}}, color={255,0,255}));
  connect(bAScontroller.OccReq, OccReqGen.y) annotation (Line(points={{44,
          19},{-16,19},{-16,50},{-46.8,50}}, color={255,127,0}));
  connect(booPul1.y, SBCreqGen.trigger)
    annotation (Line(points={{-68,16},{-61.2,16}}, color={255,0,255}));
  connect(booPul2.y, SBHreqGen.trigger)
    annotation (Line(points={{-68,-16},{-61.2,-16}}, color={255,0,255}));
  connect(SBCreqGen.y, bAScontroller.SBCreq) annotation (Line(points={{
          -46.8,16},{-12,16},{-12,13.2},{44,13.2}}, color={255,127,0}));
  connect(SBHreqGen.y, bAScontroller.SBHreq) annotation (Line(points={{
          -46.8,-16},{-16,-16},{-16,10.2},{44,10.2}}, color={255,127,0}));
  connect(booPul3.y, totCoolReqsGen.trigger)
    annotation (Line(points={{-68,-48},{-61.2,-48}}, color={255,0,255}));
  connect(bAScontroller.totCoolReqs, totCoolReqsGen.y) annotation (Line(
        points={{44,7.2},{-12,7.2},{-12,-48},{-46.8,-48}}, color={255,127,
          0}));
  connect(bAScontroller.highSpaceT, highSpaceTGen.y) annotation (Line(
        points={{44,3.6},{-8,3.6},{-8,-78},{-68,-78}}, color={0,0,127}));
  connect(bAScontroller.mostOpenDam, mostOpenDamGen.y) annotation (Line(
        points={{44,0.4},{-4,0.4},{-4,-110},{-68,-110}}, color={0,0,127}));
  connect(OccReqGen.reset, OccGen.y) annotation (Line(points={{-54,42.8},
          {-42,42.8},{-42,82},{-68,82}}, color={255,0,255}));
  connect(SBHreqGen.reset, SBCreqGen.reset) annotation (Line(points={{-54,
          -23.2},{-54,-28},{-42,-28},{-42,4},{-54,4},{-54,8.8}}, color={
          255,0,255}));
  connect(SBHreqGen.reset, OccGen.y) annotation (Line(points={{-54,-23.2},
          {-54,-28},{-42,-28},{-42,82},{-68,82}}, color={255,0,255}));
  connect(con.y, totCoolReqsGen.reset) annotation (Line(points={{-106,-62},
          {-54,-62},{-54,-55.2}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
</html>"));
end BASControllerSimulation;
