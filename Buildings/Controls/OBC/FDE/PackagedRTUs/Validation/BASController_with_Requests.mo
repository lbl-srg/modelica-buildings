within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model BASController_with_Requests
  "This model simulates BASController using the terminal unit request simulator."
  Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller basCont(
    pBldgSPset=3,
    pTotalTU=3,
    minSATset=285.15,
    maxSATset=297.15,
    HeatSet=308.15,
    maxDDSPset=500,
    minDDSPset=150)
      annotation (Placement(transformation(extent={{74,-14},{94,12}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController
    SimPartCon
      annotation (Placement(transformation(extent={{-64,56},{-44,76}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController
    SimPartCon1
      annotation (Placement(transformation(extent={{-64,-6},{-44,14}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController
    SimPartCon2
      annotation (Placement(transformation(extent={{-62,-72},{-42,-52}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen(
    width=0.5,
    period=2880)
      annotation (Placement(transformation(extent={{38,74},{58,94}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine highSpaceTGen(
    amplitude=5,
    freqHz=1/3600,
    offset=27 + 273.15,
    startTime=1250)
      annotation (Placement(transformation(extent={{42,-64},{62,-44}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
    amplitude=0.15,
    freqHz=1/4120,
    offset=0.85)
      annotation (Placement(transformation(extent={{42,-96},{62,-76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine SpaceTGen(
    amplitude=3,
    freqHz=1/3600,
    offset=295.15,
    startTime=0)
      annotation (Placement(transformation(extent={{-96,70},{-76,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen1(
    width=0.25,
    period=2880)
      annotation (Placement(transformation(extent={{-96,38},{-76,58}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine SpaceTGen1(
    amplitude=4,
    freqHz=1/3600,
    offset=295.15,
    startTime=80)
      annotation (Placement(transformation(extent={{-96,8},{-76,28}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen2(
    width=0.5,
    period=2880)
      annotation (Placement(transformation(extent={{-96,-24},{-76,-4}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine SpaceTGen2(
    amplitude=5,
    freqHz=1/3600,
    offset=295.15,
    startTime=50)
      annotation (Placement(transformation(extent={{-94,-58},{-74,-38}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen3(
    width=0.75,
    period=2880)
      annotation (Placement(transformation(extent={{-94,-90},{-74,-70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum occReqTotal(
    nin=3)
    "Total of all occupancy requests"
      annotation (Placement(transformation(extent={{14,48},{34,68}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sbcReqTotal(
    nin=3)
    "Total setback cooling requests"
      annotation (Placement(transformation(extent={{14,16},{34,36}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sbhReqTotal(
    nin=3)
    "Total setback heating requests"
      annotation (Placement(transformation(extent={{14,-16},{34,4}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum coolReqTotal(
    nin=3)
    "Total cooling requests"
    annotation (Placement(transformation(extent={{14,-48},{34,-28}})));
equation
  connect(OccGen.y,basCont. occ)
    annotation (Line(points={{60,84},{66,84},{66,9.4},
          {72,9.4}},        color={255,0,255}));
  connect(highSpaceTGen.y,basCont. highSpaceT)
    annotation (Line(points={{64,-54},
          {66,-54},{66,-8.02},{72,-8.02}},    color={0,0,127}));
  connect(mostOpenDamGen.y,basCont. mostOpenDam)
    annotation (Line(points={{64,-86},
          {68,-86},{68,-11.4},{72,-11.4}},    color={0,0,127}));
  connect(SpaceTGen.y,SimPartCon. ZoneT)
    annotation (Line(points={{-74,80},{-70,
          80},{-70,69.6},{-66,69.6}},
                             color={0,0,127}));
  connect(OccGen1.y, SimPartCon.OccOvrd)
    annotation (Line(points={{-74,48},{-70,
          48},{-70,62.8},{-66,62.8}}, color={255,0,255}));
  connect(SpaceTGen1.y, SimPartCon1.ZoneT)
    annotation (Line(points={{-74,18},{-70,
          18},{-70,7.6},{-66,7.6}}, color={0,0,127}));
  connect(OccGen2.y, SimPartCon1.OccOvrd)
    annotation (Line(points={{-74,-14},{-70,
          -14},{-70,0.8},{-66,0.8}}, color={255,0,255}));
  connect(SpaceTGen2.y, SimPartCon2.ZoneT)
    annotation (Line(points={{-72,-48},{-68,
          -48},{-68,-58.4},{-64,-58.4}}, color={0,0,127}));
  connect(OccGen3.y, SimPartCon2.OccOvrd)
    annotation (Line(points={{-72,-80},{-68,
          -80},{-68,-65.2},{-64,-65.2}}, color={255,0,255}));
  connect(occReqTotal.y, basCont.occReq) annotation (Line(points={{36,58},{62,58},
          {62,6.02},{72,6.02}}, color={255,127,0}));
  connect(sbcReqTotal.y, basCont.sbcReq) annotation (Line(points={{36,26},{58,26},
          {58,2.64},{72,2.64}}, color={255,127,0}));
  connect(sbhReqTotal.y, basCont.sbhReq) annotation (Line(points={{36,-6},{58,-6},
          {58,-1},{72,-1}}, color={255,127,0}));
  connect(coolReqTotal.y, basCont.totCoolReqs) annotation (Line(points={{36,-38},
          {62,-38},{62,-4.64},{72,-4.64}}, color={255,127,0}));
  connect(SimPartCon.termOccReq, occReqTotal.u[1]) annotation (Line(points={{-41.8,
          59.8},{-11.9,59.8},{-11.9,62.6667},{12,62.6667}}, color={255,127,0}));
  connect(SimPartCon1.termOccReq, occReqTotal.u[2]) annotation (Line(points={{-41.8,
          -2.2},{-41.8,57.9},{12,57.9},{12,58}}, color={255,127,0}));
  connect(SimPartCon2.termOccReq, occReqTotal.u[3]) annotation (Line(points={{-39.8,
          -68.2},{-39.8,54.9},{12,54.9},{12,53.3333}}, color={255,127,0}));
  connect(SimPartCon.termSBC, sbcReqTotal.u[1]) annotation (Line(points={{-41.8,
          69.4},{-14.9,69.4},{-14.9,30.6667},{12,30.6667}}, color={255,127,0}));
  connect(SimPartCon1.termSBC, sbcReqTotal.u[2]) annotation (Line(points={{-41.8,
          7.4},{-14.9,7.4},{-14.9,26},{12,26}}, color={255,127,0}));
  connect(SimPartCon2.termSBC, sbcReqTotal.u[3]) annotation (Line(points={{-39.8,
          -58.6},{-39.8,19.7},{12,19.7},{12,21.3333}}, color={255,127,0}));
  connect(SimPartCon.termSBH, sbhReqTotal.u[1]) annotation (Line(points={{-41.8,
          63},{-41.8,-1.5},{12,-1.5},{12,-1.33333}}, color={255,127,0}));
  connect(SimPartCon1.termHeatReq, sbhReqTotal.u[2]) annotation (Line(points={{-41.8,
          4},{-14,4},{-14,-6},{12,-6}}, color={255,127,0}));
  connect(SimPartCon2.termSBH, sbhReqTotal.u[3]) annotation (Line(points={{-39.8,
          -65},{-39.8,-13.5},{12,-13.5},{12,-10.6667}}, color={255,127,0}));
  connect(SimPartCon.termCoolReq, coolReqTotal.u[1]) annotation (Line(points={{-41.8,
          72.2},{-41.8,17.1},{12,17.1},{12,-33.3333}}, color={255,127,0}));
  connect(SimPartCon1.termCoolReq, coolReqTotal.u[2]) annotation (Line(points={{
          -41.8,10.2},{-14.9,10.2},{-14.9,-38},{12,-38}}, color={255,127,0}));
  connect(SimPartCon2.termCoolReq, coolReqTotal.u[3]) annotation (Line(points={{-39.8,
          -55.8},{-13.9,-55.8},{-13.9,-42.6667},{12,-42.6667}},       color={255,
          127,0}));
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
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller\">
Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller</a> using the terminal unit request simulator 
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController\">
Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits.SimPartialController</a>.
</p>
</html>"),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"));
end BASController_with_Requests;
