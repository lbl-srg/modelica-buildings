within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days)"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput simTim(final quantity="Time", final unit
      ="s") "Simulation time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput calTim(final quantity="Time", final unit
      =    "s") "Calendar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  calTim = simTim - integer(simTim/31536000)*31536000;
  annotation (
    defaultComponentName="conTim",
    Documentation(info="<HTML>
<p>
This component converts the simulation time to calendar time in a scale of 1 year (365 days).
</p>
</HTML>
", revisions="<html>
<ul>
<li>
February 27, 2011, by Wangda Zuo:<br>
Rename the componet.
</li>
<li>
July 08, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-98,6},{-74,-4}},
          lineColor={0,0,127},
          textString="simTim"),
        Text(
          extent={{74,6},{98,-4}},
          lineColor={0,0,127},
          textString="calTim"),
        Bitmap(extent={{-50,60},{52,-60}}, fileName=
              "modelica://Buildings/Images/Utilities/IO/WeatherData/BaseClasses/calendar.png")}));
end ConvertTime;
