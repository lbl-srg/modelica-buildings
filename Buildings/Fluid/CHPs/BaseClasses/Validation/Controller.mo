within Buildings.Fluid.CHPs.BaseClasses.Validation;
model Controller "Validate model Controller"
  parameter Buildings.Fluid.CHPs.Data.ValidationData3 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=false, table={900,960,1200,
        2200})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(per=per) "Main controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=false, table={300,600,900})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    mWat_flow(table=[0,0; 900,0.4; 1320,0; 1500,
        0.4; 1900,0; 1960,0.4; 2200,0; 3000,0], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));
  Modelica.Blocks.Sources.Constant TEng(k=273.15 + 100) "Engine temperature"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-19,70},{0,70},{0,16},
          {19,16}}, color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-19,30},{-10,30},{-10,
          12},{19,12}}, color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-19,-70},{0,-70},{0,4},{
          19,4}}, color={0,0,127}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-19,-30},{
          -10,-30},{-10,8},{19,8}}, color={0,0,127}));
  annotation (
    experiment(StopTime=3000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/Controller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.Controller\">
Buildings.Fluid.CHPs.BaseClasses.Controller</a>
for switching between six operating modes. 
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
end Controller;
