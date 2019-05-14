within Buildings.Controls.OBC.CDL;
package Utilities "Package with utility functions"

  block OptimalStartConstantTemperatureGradient "Optimal start time of HVAC system before occupancy"
    extends Modelica.Blocks.Icons.Block;
    parameter Real temGraHea = 2 "Temperature gradient for heating, unit = K/h";
    parameter Real temGraCoo = 2.5 "Temperature gradient for cooling, unit = K/h";
    parameter Real occupancy[:]=3600*{8, 18}
      "Occupancy table, each entry switching occupancy on or off";
    //parameter Integer nDay = 2 "Number of previous days used for averaging optimal time";
    parameter Modelica.SIunits.Time maxOptTim = 3*3600 "maximum optimal start time";

    Interfaces.RealInput TZon(
      final quantity = "ThermodynamicTemperature",
      final unit = "K",
      displayUnit = "degC",
      min=200) "Zone temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.RealInput TSetZonHea(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=200) "Zone setpoint temperature for heating during occupied time"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Interfaces.RealInput TSetZonCoo(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=200) "Zone setpoint temperature for cooling during occupied time"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Interfaces.RealOutput tOpt(
      final quantity="Time",
      final unit="s",
      displayUnit="h") "Optimal start time of HVAC system"
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                      iconTransformation(extent={{100,-10},{120,10}})));

protected
    parameter Modelica.SIunits.Time staTim(fixed=false) "Simulation start time";
    Boolean sampleTrigger;

  initial equation
    //simulation start time can be negative or positive
    staTim = time;

  equation
    sampleTrigger = sample(occupancy[1] - maxOptTim, 86400);
    when sampleTrigger then
      if TZon < TSetZonHea then
        tOpt = (TSetZonHea - TZon)/temGraHea * 3600;
      elseif TZon > TSetZonCoo then
        tOpt = (TZon - TSetZonCoo)/temGraCoo * 3600;
      else
        tOpt = 0;
      end if;
    end when
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end OptimalStartConstantTemperatureGradient;

annotation (
preferredView="info", Documentation(info="<html>
<p>
This package contains utility models
that are used throughout the library.
</p>
</html>"),
Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
    Polygon(
      origin={1.3835,-4.1418},
      rotation=45.0,
      fillColor={64,64,64},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
      points={{-15.0,93.333},{-15.0,68.333},{0.0,58.333},{15.0,68.333},{15.0,93.333},
      {20.0,93.333},{25.0,83.333},{25.0,58.333},{10.0,43.333},{10.0,-41.667},{25.0,-56.667},
      {25.0,-76.667},{10.0,-91.667},{0.0,-91.667},{0.0,-81.667},{5.0,-81.667},{15.0,-71.667},
      {15.0,-61.667},{5.0,-51.667},{-5.0,-51.667},{-15.0,-61.667},{-15.0,-71.667},{-5.0,-81.667},
      {0.0,-81.667},{0.0,-91.667},{-10.0,-91.667},{-25.0,-76.667},{-25.0,-56.667},{-10.0,-41.667},
      {-10.0,43.333},{-25.0,58.333},{-25.0,83.333},{-20.0,93.333}}),
    Polygon(
      origin={10.1018,5.218},
      rotation=-45.0,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-15.0,87.273},{15.0,87.273},{20.0,82.273},{20.0,27.273},{10.0,17.273},
      {10.0,7.273},{20.0,2.273},{20.0,-2.727},{5.0,-2.727},{5.0,-77.727},{10.0,-87.727},
      {5.0,-112.727},{-5.0,-112.727},{-10.0,-87.727},{-5.0,-77.727},{-5.0,-2.727},{-20.0,-2.727},
      {-20.0,2.273},{-10.0,7.273},{-10.0,17.273},{-20.0,27.273},{-20.0,82.273}})}));
end Utilities;
