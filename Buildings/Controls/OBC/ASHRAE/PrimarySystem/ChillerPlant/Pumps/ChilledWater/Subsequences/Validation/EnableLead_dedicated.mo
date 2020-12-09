within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model EnableLead_dedicated
  "Validate sequence for enabling lead pump of plants with dedicated primary chilled water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaLeaChiPum
    "Enable lead chilled water pump when the lead chiller is enabled"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    disLeaChiPum
    "Disable lead pump due to that the lead chiller has been proven off"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset leaChiProOn(
    final duration=2000) "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leaChiEna(
    final period=3600,
    final shift=300) "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintains a true signal until conditions changes"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) "Constant false"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPla(
    final period=7200,
    final shift=200)
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(leaChiEna.y, enaLeaChiPum.uLeaChiEna) annotation (Line(points={{-58,
          40},{20,40},{20,23},{38,23}}, color={255,0,255}));
  connect(leaChiEna.y, disLeaChiPum.uLeaChiEna) annotation (Line(points={{-58,
          40},{20,40},{20,-17},{38,-17}}, color={255,0,255}));
  connect(leaChiEna.y, lat.u) annotation (Line(points={{-58,40},{20,40},{20,-20},
          {-40,-20},{-40,-40},{-22,-40}}, color={255,0,255}));
  connect(lat.y, disLeaChiPum.uLeaChiWatReq)
    annotation (Line(points={{2,-40},{20,-40},{20,-28},{38,-28}},
      color={255,0,255}));
  connect(con.y, lat.clr)
    annotation (Line(points={{-38,-60},{-30,-60},{-30,-46},{-22,-46}},
      color={255,0,255}));
  connect(leaChiEna.y, leaChiProOn.u) annotation (Line(points={{-58,40},{-50,40},
          {-50,10},{-42,10}}, color={255,0,255}));
  connect(leaChiProOn.y, enaLeaChiPum.uLeaChiSta) annotation (Line(points={{-18,
          10},{10,10},{10,17},{38,17}}, color={255,0,255}));
  connect(leaChiProOn.y, disLeaChiPum.uLeaChiSta) annotation (Line(points={{-18,
          10},{10,10},{10,-23},{38,-23}}, color={255,0,255}));
  connect(leaChiProOn.y, enaLeaChiPum.uLeaChiWatReq) annotation (Line(points={{
          -18,10},{10,10},{10,12},{38,12}}, color={255,0,255}));
  connect(enaPla.y, enaLeaChiPum.uPla) annotation (Line(points={{-58,80},{28,80},
          {28,28},{38,28}}, color={255,0,255}));
  connect(enaPla.y, disLeaChiPum.uPla) annotation (Line(points={{-58,80},{28,80},
          {28,-12},{38,-12}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Subsequences/Validation/EnableLead_dedicated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end EnableLead_dedicated;
