within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart "Optimal start time of HVAC system before occupancy"
  extends Modelica.Blocks.Icons.Block;
  parameter Real temGraHeaIni = 1 "initial temperature gradient for heating, unit = K/h";
  parameter Real temGraCooIni = 1.5 "initial temperature gradient for cooling, unit = K/h";
  parameter Real nDay = 2 "Number of previous days used for averaging optimal time";
  parameter Modelica.SIunits.Time maxOptTim = 4*3600 "maximum optimal start time";

  Interfaces.RealInput tNexOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Time until next occupancy"
    annotation (Placement(transformation(extent={{-140,58},{-100,98}})));
  Interfaces.RealInput tNexNonOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Time until next non-occupancy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
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
  parameter Modelica.SIunits.Time period = 86400 "Duration of each iteration";
  parameter Integer iDay "Iterator";
  Modelica.SIunits.Time tStart;
  Modelica.SIunits.Time tStop;
  Real temGraHea[nDay,1] = temGraHeaIni.*ones(nDay,1) "temperature gradient for heating";
  Real temGraCoo[nDay,1] = temGraCooIni.*ones(nDay,1) "temperature gradient for cooling";
  Boolean compute;

initial algorithm
  //simulation start time can be negative or positive
  staTim := time;

  // no heating nor cooling
algorithm
  if TZon >= TSetZonHea and TZon <= TSetZonCoo then
    tOpt :=0;
  // heating mode
  elseif TZon <= TSetZonHea then

    tOpt :=(TSetZonHea - TZon)/(sum(temGraHea)/nDay)*3600;
  // cooling mode
  else
    tOpt :=(TZon - TSetZonCoo)/(sum(temGraHea)/nDay)*3600;
  end if;

  iDay := integer(time/period);

  compute := time > (iDay + 1)*period;
  // calculate Tg for the past day
  while compute loop

  end while;

    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
