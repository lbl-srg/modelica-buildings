within Buildings.Examples.HydronicSystems.BaseClasses;
package FanCoilUnit
  "Package with fan coil unit system model"

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}),
  Documentation(info="<html>
  This package contains the system model for the four-pipe fan coil unit
  <a href=\"modelica://Buildings.Examples.HydronicSystems.BaseClasses.FanCoilUnit.FourPipe\">
  Buildings.Examples.HydronicSystems.BaseClasses.FanCoilUnit.FourPipe</a> and the package of type definitions
  <a href=\"modelica://Buildings.Examples.HydronicSystems.BaseClasses.FanCoilUnit.Types\">
  Buildings.Examples.HydronicSystems.BaseClasses.FanCoilUnit.Types</a>.
  
    </html>"));
end FanCoilUnit;
