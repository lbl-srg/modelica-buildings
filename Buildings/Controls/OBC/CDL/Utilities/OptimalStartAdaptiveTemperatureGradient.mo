within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStartAdaptiveTemperatureGradient
  "Optimal start time of HVAC system based on adaptive temperature gradient"
  extends Modelica.Blocks.Icons.Block;
  parameter Real temGraHeaIni = 2 "Temperature gradient for heating, unit = K/h";
  parameter Real temGraCooIni = 2.5 "Temperature gradient for cooling, unit = K/h";
  parameter Modelica.SIunits.Time occupancy[:]=3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Integer nPre = 2 "Number of previous days used for averaging optimal time";
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

//protected
  parameter Modelica.SIunits.Time staTim(fixed=false) "Simulation start time";
  Boolean sampleTrigger;
  Integer dayCounter = 0 "number of simulated days";
  Modelica.SIunits.Time tStaCal "Daily calculation start time";
  Modelica.SIunits.Time exitTime;
  parameter Real adjFac = 0.0125; // can be a variable
  Modelica.SIunits.Time tOpt_real "real optimal start time";
  Real temGraCoo[nPre,1] = ones(nPre, 1)*temGraCooIni;
  Real temGraCoo_real;
  Real temGraCooAda;
  //Real temGraHeaAda;
  Modelica.SIunits.Time tOptAda;
  Modelica.SIunits.Time tOptAdj;

initial equation
  //simulation start time can be negative or positive; placeholder
  staTim = time;
  TOut_last = pre(TOut);

algorithm
  tStaCal :=occupancy[1] - maxOptTim;
  sampleTrigger :=sample(tStaCal, 86400);

  // calculate the optimal start time for the initial day(s)
  when sampleTrigger then
    dayCounter :=dayCounter + 1;
    if TZon < TSetZonHeaOn then
      tOpt :=min((TSetZonHeaOn - TZon)/temGraHeaIni*3600, maxOptTim);
    elseif TZon > TSetZonCooOn then
      tOpt :=min((TZon - TSetZonCooOn)/temGraCooIni*3600, maxOptTim);
    else
      tOpt :=0;
    end if;
  end when;

  // get the real optimal start time
  when sampleTrigger and (abs(TSetZonHeaOn-TZon)<0.5 or abs(TZon-TSetZonCooOn)<0.5) then
    exitTime :=time;
  end when;
  tOpt_real :=mod(exitTime,86400) - tStaCal;

  // calculate the real temperature gradient
  when sampleTrigger then
    temGraCoo_real :=(TSetZonCooOn-TZon)/tOpt_real;
  end when;

  // update the temperature gradient vector and calculate its moving average
  when sampleTrigger then
    first :=false;
    uu :=u;

    //At the first sample u_last is filled with u (to initialize in steady state)
    u_buffer :=if previous(first) then fill(uu, n + 1) else
              cat(1,{uu},previous(u_buffer[1:n]));
    // moving average formula
    y :=if previous(first) then uu else previous(yy)+(u_buffer[1]-u_buffer[n+1])/n;
    yy :=y;
  end when;

  // recalculate tOpt based on adapted temperature gradient (moving average)
  when sampleTrigger then
    tOptAda :=(TSetZonCooOn - TZon)/temGraCooAda;
  end when;

  // adjust tOpt_ada based on outdoor temperature difference between the previous day and today
  when sampleTrigger then
    dT :=TOut - TOut_last;
    tOptAdj :=tOptAda*(1 + adjFac*dT);
    TOut_last :=TOut;
  end when
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end OptimalStartAdaptiveTemperatureGradient;
