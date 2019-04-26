within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart "Optimal start time of HVAC system before occupancy"

  extends Modelica.Blocks.Icons.Block;
  parameter Real temGraHea = 2 "initial temperature gradient for heating, unit = K/h";
  parameter Real temGraCoo = 2.5 "initial temperature gradient for cooling, unit = K/h";
  parameter Real occupancy[:] = {8,18}*3600 "Number of previous days used for averaging optimal time";
  parameter Modelica.SIunits.Time maxOptTim = 3*3600 "maximum optimal start time";

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

//protected
  parameter Modelica.SIunits.Time staTim(fixed=false) "Simulation start time";
  parameter Modelica.SIunits.Time period = 86400 "Duration of each iteration";
  parameter Modelica.SIunits.Time samplePeriod = 3600;
  Modelica.SIunits.Time tOptHea;
  Modelica.SIunits.Time tOptCoo;
  //Real temGraHea "temperature gradient for heating";
  //Real temGraCoo "temperature gradient for cooling";
  Integer iDay "Iterator";
  Boolean compute;
  parameter Modelica.SIunits.Time samStart(fixed=false)
    "Time when the first sampling starts";
  Boolean sampleTrigger "True, if sample time instant";

function sampleStart "Start time for sampling"
  input Modelica.SIunits.Time t "Simulation time";
  input Modelica.SIunits.Time samplePeriod "Sample Period";
  output Modelica.SIunits.Time sampleStart "Time at which first sample happens";
algorithm
  sampleStart :=ceil(t/samplePeriod)*samplePeriod;
end sampleStart;

initial equation
  //simulation start time can be negative or positive
  staTim = time;
  samStart = sampleStart(time,samplePeriod);
equation

  sampleTrigger = sample(samStart, samplePeriod);

algorithm
  //when sampleTrigger then
    iDay :=0;
    compute :=samStart - iDay*period >= occupancy[1] - maxOptTim;
    while compute loop
      tOptHea :=(TSetZonHea - TZon)/temGraHea*3600;
      tOptCoo :=(TZon - TSetZonCoo)/temGraCoo*3600;
      tOpt :=min(maxOptTim, max(max(tOptHea, tOptCoo), 0));
      iDay :=iDay + 1;
    end while;
  //end when
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
