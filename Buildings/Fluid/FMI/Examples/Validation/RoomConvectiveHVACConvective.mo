within Buildings.Fluid.FMI.Examples.Validation;
model RoomConvectiveHVACConvective
  "Simple thermal zone with convective HVAC system."
 extends Modelica.Icons.Example;

  Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective hvaCon
    annotation (Placement(transformation(extent={{-98,-14},{-66,18}})));
  Buildings.Fluid.FMI.Examples.FMUs.RoomConvective rooCon
    annotation (Placement(transformation(extent={{66,-14},{98,18}})));
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
            textString="refMod")}));
    end BaseCase;
  BaseCase baseCase
    annotation (Placement(transformation(extent={{-98,48},{-66,80}})));
equation

  connect(hvaCon.QGaiLat_flow, rooCon.QGaiLat_flow) annotation (Line(points={{-64,-12},
          {-64,-12},{64,-12}},                         color={0,0,127}));
  connect(hvaCon.QGaiCon_flow, rooCon.QGaiCon_flow) annotation (Line(points={{-64,-7},
          {-8,-7},{-8,-8},{64,-8}},         color={0,0,127}));
  connect(rooCon.QGaiRad_flow,hvaCon. QGaiRad_flow) annotation (Line(points={{64,-4},
          {-2,-4},{-2,-2},{-64,-2}},          color={0,0,127}));
  connect(hvaCon.X_wZon, rooCon.X_wZon)
    annotation (Line(points={{-64,9},{-5,9},{-5,8},{64,8}}, color={0,0,127}));
  connect(rooCon.TAirZon,hvaCon. TAirZon) annotation (Line(points={{64,12},{-64,
          12}},                   color={0,0,127}));
  connect(hvaCon.fluPor, rooCon.fluPor) annotation (Line(points={{-65,16},{-65,
          16},{65,16}},     color={0,0,255}));
  connect(hvaCon.TRadZon, rooCon.TRadZon) annotation (Line(points={{-64,2},{-64,
          2},{4,2},{4,0},{64,0}}, color={0,0,127}));
  connect(hvaCon.CZon, rooCon.CZon) annotation (Line(points={{-64,6},{-64,6},{
          -6,6},{-6,4},{64,4}}, color={0,0,127}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example validates the coupling of a convective thermal zone with an air-based HVAC system. 
</p>
<ul>
<li>
The <code>hvaCoo</code> block wraps the Modelica models of the air-based system.
</li>
<li>
The <code>rooCoo</code> wraps the Modelica models of the thermal zone. 
</li>
</ul>
<p>The Modelica models of the thermal zone and the HVAC air-based system are taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3
</a>.
</p>
<p>
The coupling is validated against the <code>refMod</code> 
block which encapsulates the base case model 
<a href=\"modelica://Buildings.Fluid.FMI.Examples.Validation.RoomConvectiveHVACConvective.BaseCase\">
Buildings.Fluid.FMI.Examples.Validation.RoomConvectiveHVACConvective.BaseCase 
</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/Validation/RoomConvectiveHVACConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvectiveHVACConvective;
