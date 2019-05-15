within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStartAdaptiveTemperatureGradient
  "Optimal start time of HVAC system based on adaptive temperature gradient"
  extends Modelica.Blocks.Icons.Block;
  parameter Real temGraHea = 2 "Temperature gradient for heating, unit = K/h";
  parameter Real temGraCoo = 2.5 "Temperature gradient for cooling, unit = K/h";
  parameter Real occupancy[:]=3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  //parameter Integer nDay = 2 "Number of previous days used for averaging optimal time";
  parameter Modelica.SIunits.Time maxOptTim = 3*3600 "maximum optimal start time";
  discrete Modelica.SIunits.Temperature TOut_last "Outdoor temperature of previous day";
  discrete Modelica.SIunits.TemperatureDifference dT;

  Interfaces.RealInput TOut(
    final quantity = "ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC") "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Interfaces.RealInput TZon(
    final quantity = "ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput TSetZonHeaOn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature for heating during occupied time"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Interfaces.RealInput TSetZonCooOn(
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

  Logical.Timer tim
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
protected
  parameter Modelica.SIunits.Time staTim(fixed=false) "Simulation start time";
  Boolean sampleTrigger;
  parameter Real adjFac = 0.0125;

initial equation
  //simulation start time can be negative or positive
  staTim = time;
  TOut_last = 273.15+12;

algorithm
  sampleTrigger :=sample(occupancy[1] - maxOptTim, 86400);

  when sampleTrigger then
    entryTime :=time;
    dT :=TOut - TOut_last;
    if TZon < TSetZonHeaOn then
      tOpt :=min((TSetZonHeaOn - TZon)/temGraHea*3600*(1 + dT*adjFac), maxOptTim);
    elseif TZon > TSetZonCooOn then
      tOpt :=min((TZon - TSetZonCooOn)/temGraCoo*3600*(1 + dT*adjFac), maxOptTim);
    else
      tOpt :=0;
    end if;
    TOut_last :=TOut;
  end when;

  when abs(TSetZonHeaOn-TZon)<0.5 or abs(TZon-TSetZonCooOn)<0.5 then
    exitTime :=time;
  end when
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end OptimalStartAdaptiveTemperatureGradient;
