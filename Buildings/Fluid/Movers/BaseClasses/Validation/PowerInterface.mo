within Buildings.Fluid.Movers.BaseClasses.Validation;
model PowerInterface "Simple model to validate PowerInterface"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.PowerInterface powCoo(
    motorCooledByFluid=true,
    delta_V_flow=0.05) "Power interface model"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Sources.Constant WFlo(k=1*1000) "Flow work"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp V_flow(
    duration=1,
    height=1) "Volume flow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant WHyd(k=1250) "Hydraulic work"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant PEle(k=1*1000*4) "Electrical work"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Movers.BaseClasses.PowerInterface powNonCoo(
    motorCooledByFluid=false,
    delta_V_flow=0.05) "Power interface model"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(V_flow.y, powCoo.V_flow) annotation (Line(points={{-39,70},{-30,70},{
          -30,36},{-12,36},{-12,30}},
                         color={0,0,127}));
  connect(powCoo.WFlo, WFlo.y) annotation (Line(points={{-12,24},{-34,24},{-34,
          30},{-39,30}},
                      color={0,0,127}));
  connect(PEle.y, powCoo.PEle) annotation (Line(points={{-39,-70},{-20,-70},{-20,
          10},{-12,10}}, color={0,0,127}));
  connect(V_flow.y, powNonCoo.V_flow) annotation (Line(points={{-39,70},{-30,70},
          {-30,-10},{-12,-10}}, color={0,0,127}));
  connect(powNonCoo.WFlo, WFlo.y) annotation (Line(points={{-12,-16},{-34,-16},
          {-34,30},{-39,30}},  color={0,0,127}));
  connect(PEle.y, powNonCoo.PEle) annotation (Line(points={{-39,-70},{-20,-70},{
          -20,-30},{-12,-30}}, color={0,0,127}));
  connect(WHyd.y, powCoo.WHyd) annotation (Line(points={{-39,-30},{-24,-30},{
          -24,16},{-12,16}}, color={0,0,127}));
  connect(WHyd.y, powNonCoo.WHyd) annotation (Line(points={{-39,-30},{-24,-30},
          {-24,-24},{-12,-24}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the power interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2022, by Hongxiang Fu:<br/>
Changed the source for <code>etaHyd</code> to <code>WHyd</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
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
