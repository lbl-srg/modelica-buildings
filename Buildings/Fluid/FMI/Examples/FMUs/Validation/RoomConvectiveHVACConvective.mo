within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block RoomConvectiveHVACConvective
  "Simple thermal zone with convective HVAC system."
  import Buildings;
 extends Modelica.Icons.Example;

  HVACCoolingOnlyConvective hvaCon
    annotation (Placement(transformation(extent={{-94,-8},{-62,24}})));
  Buildings.Fluid.FMI.Examples.FMUs.RoomConvective rooCon
    annotation (Placement(transformation(extent={{60,-10},{92,22}})));
equation

  connect(hvaCon.QGaiLat_flow, rooCon.QGaiLat_flow) annotation (Line(points={{-60,-6},
          {-12,-6},{-12,-10},{58,-10},{58,-8}},        color={0,0,127}));
  connect(hvaCon.QGaiCon_flow, rooCon.QGaiCon_flow) annotation (Line(points={{-60,-1},
          {-8,-1},{-8,-4},{58,-4}},         color={0,0,127}));
  connect(rooCon.QGaiRad_flow,hvaCon. QGaiRad_flow) annotation (Line(points={{58,0},{
          -8,0},{-8,4},{-60,4}},              color={0,0,127}));
  connect(hvaCon.TRadZon, rooCon.TRadZon) annotation (Line(points={{-60,8},{-24,
          8},{-24,6},{58,6},{58,4}},  color={0,0,127}));
  connect(hvaCon.X_wZon, rooCon.X_wZon)
    annotation (Line(points={{-60,15},{-5,15},{-5,12},{58,12}},
                                                            color={0,0,127}));
  connect(rooCon.TAirZon,hvaCon. TAirZon) annotation (Line(points={{58,16},{-6,16},
          {-6,18},{-60,18}},      color={0,0,127}));
  connect(hvaCon.CZon, rooCon.CZon) annotation (Line(points={{-60,12},{-6,12},{-6,
          8},{58,8}}, color={0,0,127}));
  connect(hvaCon.supAir, rooCon.supAir) annotation (Line(points={{-61,22},{-4,22},
          {-4,20},{59,20}}, color={0,0,255}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>This example demonstrates the coupling 
of a convective thermal zone with an air-based 
HVAC system. The example  zone is taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>. </p>
<p>The example is  from <a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">
Buildings.Fluid.FMI.RoomConvective</a> which 
provides the input and output signals that are 
needed to interface the acausal thermal zone model 
with causal connectors of FMI. The instance 
<code>theHvaAda</code> is the HVAC system adapter 
that contains on the right a fluid port, and on 
the left signal ports which are then used to 
connect at the top-level of the model to signal 
ports which are exposed at the FMU interface. </p>
</html>", revisions="<html>
<ul>
<li>May 02, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/RoomConvectiveHVACConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvectiveHVACConvective;
