within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses;
model HeatFlow "Water to air heat flow operation"

  extends Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialHeatFlow(
  dxCoo(wetCoi(redeclare final
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity
                                                                                    cooCap),
  dryCoi(redeclare final
          Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity
                                                                                    cooCap),
      calRecoverableWasteHeat=calRecoverableWasteHeat), dxHea(calRecoverableWasteHeat=calRecoverableWasteHeat));
  constant Boolean calRecoverableWasteHeat
    "Flag, set to true if recoverable waste heat is calculated";
equation
  connect(add.y, Q2_flow) annotation (Line(
      points={{6.6,-1.88738e-16},{20,-1.88738e-16},{20,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="heaFlo", Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                     graphics), Documentation(info="<html>
<p>
This block combines the models for the dry coil and the wet coil.
Output of the block is the coil performance which, depending on the
mass fraction at the apparatus dew point temperature and 
the mass fraction of the coil inlet air,
may be from the dry coil, the wet coil, or a weighted average of the two.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2012 by Michael Wetter:<br>
Revised implementation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br>
Renamed connector to follow naming convention.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end HeatFlow;
