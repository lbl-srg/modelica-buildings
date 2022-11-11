within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Examples.BaseClasses.Validation;
model ZoneTemperatureSetpoint
  "Validation model for zone temperature setpoint controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Examples.BaseClasses.ZoneTemperatureSetpoint
    TZonSet "Zone temperature setpoint controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occ(
    final period=100)
    "Boolean pulse signal for zone occupancy"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(occ.y, TZonSet.uOcc)
    annotation (Line(points={{-18,0},{18,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Example/Baseclasses/Validation/ZoneTemperatureSetpoint.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Example.BaseClasses.ZoneTemperatureSetpoint\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Example.BaseClasses.ZoneTemperatureSetpoint</a>.
      
      The instance <code>TZonSet</code> is set-up with a time-varying Boolean input 
      signal for zone occupancy <code>TZonSet.uOcc</code> to check if the setpoint 
      output signals <code>TZonSet.TZonSetHea</code> and <code>TZonSet.TZonSetCoo</code>
      change accordingly.
      </p>
      ", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(StopTime=100,
    Tolerance=1e-06));
end ZoneTemperatureSetpoint;
