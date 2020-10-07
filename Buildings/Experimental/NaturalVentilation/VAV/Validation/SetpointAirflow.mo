within Buildings.Experimental.NaturalVentilation.VAV.Validation;
model SetpointAirflow
  "Validation model for VAV airflow setpoint during natural ventilation"

  Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.5)
    "Constant room setpoint temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.5,  period=86400)
    "Varying natural ventilation signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  SetpointAirflowReset setAirRes
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=0.25, period=43200)
    "Varying occupancy signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(con.y, setAirRes.floVAV) annotation (Line(points={{-38,-10},{-22,-10},
          {-22,-9},{-2,-9}}, color={0,0,127}));
  connect(booPul.y, setAirRes.natVenSig) annotation (Line(points={{-38,30},{-20,
          30},{-20,-5},{-2,-5}}, color={255,0,255}));
  connect(booPul1.y, setAirRes.rooPop) annotation (Line(points={{-38,-50},{-20,
          -50},{-20,-13},{-2,-13}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model validates the airflow setpoint reset module. 
  <p>If the building is in natural ventilation mode and people are present,
  VAV airflow setpoint is set to the ventilation minimum (VentMinFlo).
  <p> If the building is in natural ventilation mode and no people are present,
  the VAV airflow setpoint is set to the area minimum (AreaMinFlo).
  <p> If the building is not in natural ventilation mode, the VAV airflow setpoint is left as-is.    
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/VAV/Validation/SetpointAirflow.mos"
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
end SetpointAirflow;
