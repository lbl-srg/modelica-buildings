within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days)"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput simTim(final quantity="Time", final unit=
       "s") "Simulation time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput calTim(final quantity="Time", final
      unit="s") "Calendar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.Time year=31536000 "Number of seconds in a year";
  discrete Modelica.SIunits.Time tStart "Start time of period";
  //Integer count "Period count";

initial algorithm
  tStart := integer(simTim/year)*year;
equation
  when simTim - pre(tStart) > year then
    tStart = integer(simTim/year)*year;
  end when;
  calTim = simTim - tStart;
  annotation (
    defaultComponentName="conTim",
    Documentation(info="<html>
<p>
This component converts the simulation time to calendar time in a scale of 1 year (365 days).
</p>
</html>
", revisions="<html>
<ul>
<li>
September 27, 2011, by Wangda Zuo, Michael Wetter:<br/>
Modify it to convert negative value of time. 
Use the when-then to allow dymola differentiating this model when conducting index reduction which is not allowed in previous implementation.
</li>
<li>
February 27, 2011, by Wangda Zuo:<br/>
Renamed the component.
</li>
<li>
July 08, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}})),
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
              "modelica://Buildings/Resources/Images/Utilities/IO/WeatherData/BaseClasses/calendar.png")}));
end ConvertTime;
