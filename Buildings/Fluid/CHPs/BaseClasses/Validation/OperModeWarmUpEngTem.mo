within Buildings.Fluid.CHPs.BaseClasses.Validation;
model OperModeWarmUpEngTem "Validate model OperModeWarmUpEngTem"

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem opeModWarUpEngTem(per=per)
    "Energy conversion during warm-up by engine temperature"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Ramp TEng(
    height=90,
    duration=360,
    offset=273.15 + 15,
    startTime=600) "Engine temperature"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mWat_flow(k=0.05)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TWatIn(k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TRoo(k=273.15 + 15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(TWatIn.y, opeModWarUpEngTem.TWatIn) annotation (Line(points={{-39,12},
          {39,12}},                color={0,0,127}));
  connect(mWat_flow.y, opeModWarUpEngTem.mWat_flow) annotation (Line(points={{-39,50},
          {0,50},{0,15.8},{39,15.8}},         color={0,0,127}));
  connect(TRoo.y, opeModWarUpEngTem.TRoo) annotation (Line(points={{-39,-30},{
          0,-30},{0,8},{39,8}}, color={0,0,127}));
  connect(TEng.y, opeModWarUpEngTem.TEng) annotation (Line(points={{-39,-70},{
          20,-70},{20,4},{39,4}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1500, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/OperModeWarmUpEngTem.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClassesOperModeWarmUpEngTem\">
Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem</a>
for defining energy conversion during the warm-up mode dependent on the engine temperature. 
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
end OperModeWarmUpEngTem;
