within Buildings.Fluid.FMI.Examples.Validation;
block RoomConvectiveHVACConvective
  "Simple thermal zone with convective HVAC system."
 extends Modelica.Icons.Example;

  Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective hvaCon
    annotation (Placement(transformation(extent={{-94,-8},{-62,24}})));
  Buildings.Fluid.FMI.Examples.FMUs.RoomConvective rooCon
    annotation (Placement(transformation(extent={{60,-10},{92,22}})));
    model BaseCase "Base model used for the validation of the FMI interfaces"
      extends Buildings.Examples.Tutorial.SpaceCooling.System3(vol(
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
    annotation (Documentation(info="<html>
<p>
This example is the base model which is used to validate 
the coupling of a convective thermal zone with an air-based HVAC system. 
</p>
<p>
The model which is validated is in 
<a href=\"modelica://Buildings.Fluid.FMI.Examples.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Examples.Validation.RoomConvectiveHVACConvective
</a>. 
</p>
</html>"), Icon(graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-62,44},{52,-26}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="RefMod")}));
    end BaseCase;
  BaseCase baseCase
    annotation (Placement(transformation(extent={{-98,60},{-78,80}})));
equation

  connect(hvaCon.QGaiLat_flow, rooCon.QGaiLat_flow) annotation (Line(points={{-60,-6},
          {-12,-6},{-12,-10},{58,-10},{58,-8}},        color={0,0,127}));
  connect(hvaCon.QGaiCon_flow, rooCon.QGaiCon_flow) annotation (Line(points={{-60,-1},
          {-8,-1},{-8,-4},{58,-4}},         color={0,0,127}));
  connect(rooCon.QGaiRad_flow,hvaCon. QGaiRad_flow) annotation (Line(points={{58,0},{
          -8,0},{-8,4},{-60,4}},              color={0,0,127}));
  connect(hvaCon.TRadZon, rooCon.TRadZon) annotation (Line(points={{-60,8},{-32,
          8},{-32,6},{-4,6},{-4,4},{58,4}},
                                      color={0,0,127}));
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
<p>
This example validates the coupling of a convective 
thermal zone with an air-based HVAC system. 
The <code>hvaCoo</code> wraps the Modelica models of the air-based system.
The <code>rooCoo</code> wraps the Modelica models of the thermal zone.
The Modelica models of the thermal zone and the air-based system are taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3
</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>May 02, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/Validation/RoomConvectiveHVACConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvectiveHVACConvective;
