within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model EnableLead_dedicated
  "Validate sequence for enabling lead pump of plants with dedicated primary chilled water pumps"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaLeaChiPum
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  CDL.Logical.Sources.Pulse booPul(period=1, startTime=0.1)
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
equation
  connect(booPul.y, enaLeaChiPum.uLeaChiEna) annotation (Line(points={{-119,190},
          {-100,190},{-100,168},{-82,168}}, color={255,0,255}));
  connect(booPul.y, enaLeaChiPum.uLeaChiOn) annotation (Line(points={{-119,190},
          {-100,190},{-100,160},{-82,160}}, color={255,0,255}));
  connect(booPul.y, enaLeaChiPum.uLeaChiWatReq) annotation (Line(points={{-119,
          190},{-100,190},{-100,152},{-82,152}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}})));
end EnableLead_dedicated;
