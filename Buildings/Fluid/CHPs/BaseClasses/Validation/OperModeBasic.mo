within Buildings.Fluid.CHPs.BaseClasses.Validation;
model OperModeBasic "Validate model OperModeBasic"
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Buildings.Fluid.CHPs.BaseClasses.OperModeBasic opeModBas(per=per)
    "Energy conversion for a typical CHP operation"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Ramp PEle(
    height=5000,
    duration=360,
    offset=0,
    startTime=600) "Electric power"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mWat_flow(k=0.05)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TWatIn(k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(TWatIn.y, opeModBas.TWatIn) annotation (Line(points={{-39,-30},{0,-30},
          {0,4},{39,4}}, color={0,0,127}));
  connect(mWat_flow.y, opeModBas.mWat_flow)
    annotation (Line(points={{-39,10},{39,10}}, color={0,0,127}));
  connect(PEle.y, opeModBas.PEle) annotation (Line(points={{-39,50},{0,50},{0,16},
          {39,16}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1500, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/OperModeBasic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.OperModeBasic\">
Buildings.Fluid.CHPs.BaseClasses.OperModeBasic</a>
for defining energy conversion for a typical CHP operation. 
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end OperModeBasic;
