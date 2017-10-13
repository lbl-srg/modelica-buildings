within Buildings.Fluid.Movers.BaseClasses.Validation;
model PowerInterface "Simple model to validate PowerInterface"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.PowerInterface powCoo(
    motorCooledByFluid=true,
    delta_V_flow=0.05) "Power interface model"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Sources.Constant WFlo(k=1*1000) "Flow work"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp V_flow(
    duration=1,
    height=1) "Volume flow rate"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant etaHyd(k=0.8) "Efficiency"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant PEle(k=1*1000*4) "Electrical work"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Movers.BaseClasses.PowerInterface powNonCoo(
    motorCooledByFluid=false,
    delta_V_flow=0.05) "Power interface model"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(powCoo.etaHyd, etaHyd.y) annotation (Line(points={{-12,30},{-26,30},{-26,
          70},{-39,70}}, color={0,0,127}));
  connect(V_flow.y, powCoo.V_flow) annotation (Line(points={{-39,30},{-30,30},{-30,
          24},{-12,24}}, color={0,0,127}));
  connect(powCoo.WFlo, WFlo.y) annotation (Line(points={{-12,16},{-26,16},{-26,-30},
          {-39,-30}}, color={0,0,127}));
  connect(PEle.y, powCoo.PEle) annotation (Line(points={{-39,-70},{-20,-70},{-20,
          10},{-12,10}}, color={0,0,127}));
  connect(powNonCoo.etaHyd, etaHyd.y) annotation (Line(points={{-12,-10},{-26,-10},
          {-26,70},{-39,70}}, color={0,0,127}));
  connect(V_flow.y, powNonCoo.V_flow) annotation (Line(points={{-39,30},{-30,30},
          {-30,-16},{-12,-16}}, color={0,0,127}));
  connect(powNonCoo.WFlo, WFlo.y) annotation (Line(points={{-12,-24},{-26,-24},{
          -26,-30},{-39,-30}}, color={0,0,127}));
  connect(PEle.y, powNonCoo.PEle) annotation (Line(points={{-39,-70},{-20,-70},{
          -20,-30},{-12,-30}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the power interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/PowerInterface.mos"
        "Simulate and plot"));
end PowerInterface;
