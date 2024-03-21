within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model EnableLead_dedicated
  "Validate sequence for enabling lead pump of plants with dedicated primary chilled water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaLeaChiPum
    "Enable lead chilled water pump when the lead chiller is enabled"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    disLeaChiPum
    "Disable lead pump due to that the lead chiller has been proven off"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay leaChiProOn(
    final delayTime=120)
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leaChiEna(
    final period=7200,
    final shift=400)
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPla(
    final period=7200,
    final shift=200)
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPla1(
    final width=0.75, final period=4000)
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(leaChiEna.y, enaLeaChiPum.uLeaChiEna) annotation (Line(points={{-58,40},
          {30,40},{30,83},{58,83}},     color={255,0,255}));
  connect(leaChiEna.y, leaChiProOn.u) annotation (Line(points={{-58,40},{-50,40},
          {-50,60},{-22,60}}, color={255,0,255}));
  connect(leaChiProOn.y, enaLeaChiPum.uLeaChiSta) annotation (Line(points={{2,60},{
          40,60},{40,77},{58,77}},      color={255,0,255}));
  connect(leaChiProOn.y, enaLeaChiPum.uLeaChiWatReq) annotation (Line(points={{2,60},{
          40,60},{40,72},{58,72}},          color={255,0,255}));
  connect(enaPla.y, enaLeaChiPum.uPla) annotation (Line(points={{-58,80},{20,80},
          {20,88},{58,88}}, color={255,0,255}));
  connect(enaPla1.y, disLeaChiPum.uPla) annotation (Line(points={{-58,-10},{20,-10},
          {20,-22},{58,-22}}, color={255,0,255}));
  connect(enaPla1.y, disLeaChiPum.uLeaChiEna) annotation (Line(points={{-58,-10},
          {20,-10},{20,-27},{58,-27}}, color={255,0,255}));
  connect(enaPla1.y, disLeaChiPum.uLeaChiSta) annotation (Line(points={{-58,-10},
          {20,-10},{20,-33},{58,-33}}, color={255,0,255}));
  connect(enaPla1.y, disLeaChiPum.uLeaChiWatReq) annotation (Line(points={{-58,-10},
          {20,-10},{20,-38},{58,-38}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Subsequences/Validation/EnableLead_dedicated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated</a>.
The instances <code>enaLeaChiPum</code> and <code>disLeaChiPum</code> shows how the
lead pump being enabled and disabled.
</p>
<ul>
<li>
For the instance <code>enaLeaChiPum</code>, the plant enabling input becomes
<code>true</code> at 200 second. At the meantime, the lead pump enabling output
becomes <code>true</code>.
</li>
<li>
For the instance <code>disLeaChiPum</code>, the plant and the lead chiller becomes
disabled at 3000 second. The lead pump thus becomes disabled.
</li>
</ul>
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
