within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model ModificationFactor
  import Buildings;
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant const1(k=20)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp ramp(height=0.0792, duration=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp ramp1(height=0.094, duration=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=27.8,
    duration=1,
    offset=20)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor mod(
      airFlo_nom(k=1/0.0792),
      watFlo_nom(k=1/0.094),
      temDif_nom(k=1/27.8))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(ramp.y, mod.airFlo) annotation (Line(points={{-59,70},{-46,70},{-20,
          70},{-20,9},{-12,9}}, color={0,0,127}));
  connect(ramp1.y, mod.watFlo) annotation (Line(points={{-59,30},{-40,30},{-40,
          3},{-12,3}}, color={0,0,127}));
  connect(ramp2.y, mod.watTem) annotation (Line(points={{-59,-30},{-40,-30},{
          -40,-3},{-12,-3}}, color={0,0,127}));
  connect(const1.y, mod.rooTem) annotation (Line(points={{-59,-70},{-20,-70},{
          -20,-8.8},{-12,-8.8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),experiment(StopTime=1),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/ModificationFactor.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
The example tests the implementation of <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor</a>. 



 <p>

</html>"));
end ModificationFactor;
