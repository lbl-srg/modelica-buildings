within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStartConstantTemperatureGradient
    "Optimal start time of HVAC system before occupancy"
  extends Modelica.Blocks.Icons.Block;
  parameter Real temGraHea = 2 "Temperature gradient for heating, unit = K/h";
  parameter Real temGraCoo = 2.5 "Temperature gradient for cooling, unit = K/h";
  parameter Real occupancy[:]=3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
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
      tOpt = min((TSetZonHea-TZon)/temGraHea*3600, maxOptTim);
    elseif TZon > TSetZonCoo then
      tOpt = min((TZon-TSetZonCoo)/temGraCoo*3600, maxOptTim);
    else
      tOpt = 0;
    end if;
  end when
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStartConstantTemperatureGradient;
