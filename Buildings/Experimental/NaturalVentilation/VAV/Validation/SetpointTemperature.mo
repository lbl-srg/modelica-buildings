within Buildings.Experimental.NaturalVentilation.VAV.Validation;
model SetpointTemperature
  "Validation model for VAV temperature setpoint during natural ventilation"

  Controls.OBC.CDL.Continuous.Sources.Constant con(k=294.25) "Heating setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.25, period=86400)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  SetpointTemperatureReset setTemRes
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con1(k=297) "Cooling Setpoint"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(booPul.y, setTemRes.uNatVen) annotation (Line(points={{-38,30},{-20,30},
          {-20,10},{-2,10}}, color={255,0,255}));
  connect(con.y, setTemRes.THeaSet) annotation (Line(points={{-38,70},{-16,70},{
          -16,14},{-2,14}}, color={0,0,127}));
  connect(con1.y, setTemRes.TCooSet) annotation (Line(points={{-38,-10},{-20,-10},
          {-20,6},{-2.2,6}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the VAV temperature setpoint model during the natural ventilation sequence.   
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/VAV/Validation/SetpointTemperature.mos"
        "Simulate and plot"), Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointTemperature;
