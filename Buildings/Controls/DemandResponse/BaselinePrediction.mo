within Buildings.Controls.DemandResponse;
block BaselinePrediction "Block that computes the baseline consumption"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  parameter Integer nSam = 24
    "Number of intervals in a day for which baseline is computed";

  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";

  parameter Buildings.Controls.DemandResponse.Types.PredictionModel
    predictionModel = Types.PredictionModel.WeatherRegression
    "Load prediction model";

  parameter Boolean use_dayOfAdj=true "if true, use the day of adjustment"
    annotation (Dialog(group="Day of adjustment"));

  parameter Modelica.SIunits.Time dayOfAdj_start(
    max=0,
    displayUnit="h") = -14400
    "Number of hours prior to current time when day of adjustment starts"
    annotation (Evaluate=true, Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  parameter Modelica.SIunits.Time dayOfAdj_end(
    max=0,
    displayUnit="h") = -3600
    "Number of hours prior to current time when day of adjustment ends"
    annotation (Evaluate=true, Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  parameter Real minAdjFac(min=0) = 0.8 "Minimum adjustment factor"
    annotation (Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  parameter Real maxAdjFac(min=0) = 1.2 "Maximum adjustment factor"
    annotation (Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K") "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput ECon(unit="J", nominal=1E5)
    "Consumed electrical energy"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for the current time interval"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay(
    fixed=true,start=Buildings.Controls.Types.Day.WorkingDay)
    "If true, this day remains an event day until midnight" annotation (
      Placement(transformation(extent={{-140,120},{-100,80}}),
        iconTransformation(extent={{-140,120},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-140,70},{-100,30}})));

  Real adj(unit="1") "Load adjustment factor";
protected
  parameter Modelica.SIunits.Time samplePeriod=86400/nSam
    "Sample period of the component";
  parameter Modelica.SIunits.Time simStart(fixed=false)
    "Time when the simulation started";
  parameter Integer iDayOf_start = integer((nSam*dayOfAdj_start/86400+1E-8))
    "Counter where day of look up begins";
  parameter Integer iDayOf_end = integer((nSam*dayOfAdj_end  /86400+1E-8))
    "Counter where day of look up ends";

  parameter Integer nDayOf = iDayOf_end-iDayOf_start
    "Number of samples used for the day of adjustment";
  parameter Modelica.SIunits.Time dt = 86400/nSam
    "Length of one sampling interval";
  Modelica.SIunits.Power PAve "Average power over the past interval";
  Boolean sampleTrigger "True, if sample time instant";

  output Modelica.SIunits.Energy ELast "Energy at the last sample";
  output Modelica.SIunits.Time tLast "Time at which last sample occured";
  output Integer iSam "Index for power of the current sampling interval";
  output Integer iDayOf "Index for power of the current day of interval";

  discrete output Modelica.SIunits.Power P[Buildings.Controls.Types.nDayTypes,nSam,nHis]
    "Baseline power consumption";
  // The temperature history is set to a zero array if it is not needed.
  // This significantly reduces the size of the code that needs to be compiled.

  discrete output Modelica.SIunits.Temperature T[
   if predictionModel == Types.PredictionModel.WeatherRegression then Buildings.Controls.Types.nDayTypes else 0,
   if predictionModel == Types.PredictionModel.WeatherRegression then nSam else 0,
   if predictionModel == Types.PredictionModel.WeatherRegression then nHis else 0]
    "Temperature history";

  Integer iHis[Buildings.Controls.Types.nDayTypes,nSam]
    "Index for power of the current sampling history, for the currrent time interval";
  Boolean historyComplete[Buildings.Controls.Types.nDayTypes,nSam]
    "Flage, set to true when all history terms are built up for the given day type and given time interval";

  Boolean _isEventDay
    "Flag, switched to true when block gets an isEvenDay=true signal, and remaining true until midnight";

  Modelica.SIunits.Energy EActAve "Actual energy over the day off period";

  Modelica.SIunits.Energy EHisAve
    "Actual load over the day off period, summed over all time intervals";

  Modelica.SIunits.Power PPreHis[Buildings.Controls.Types.nDayTypes, -iDayOf_start+1]
    "Predicted power consumptions for all day off time intervals";
  Boolean PPreHisSet[Buildings.Controls.Types.nDayTypes, -iDayOf_start+1](each start=false, each fixed=true)
    "Flag, true if a value in PPreHis has been set for that element";

  Real intTOut(unit="K.s", start=0, fixed=true)
    "Time integral of outside temperature";
  Real intTOutLast(unit="K.s")
    "Last sampled value of time integral of outside temperature";

  Integer idxSam "Index to access iSam";

  function incrementIndex
    input Integer i "Counter";
    input Integer n "Maximum value of counter";
    output Integer iNew "New value of counter";
  algorithm
    iNew :=if i == n then 1 else i + 1;
    annotation(LateInline = true);
  end incrementIndex;

  function getIndex
    input Integer i "Counter";
    input Integer n "Maximum value of counter";
    output Integer iNew "New value of counter";
  algorithm
    iNew := mod(i, n);
    if iNew == 0 then
      iNew := n;
    end if;
    annotation(LateInline = true);
  end getIndex;

initial equation
  iSam = 1;
  iDayOf = 1;

  P = zeros(
    Buildings.Controls.Types.nDayTypes,
    nSam,
    nHis);
  T = zeros(size(T,1), size(T,2), size(T,3));

  EActAve    = 0;
  EHisAve    = 0;
  PPreHis    = zeros(Buildings.Controls.Types.nDayTypes, -iDayOf_start+1);

  ELast = 0;
  intTOutLast = 0;
  tLast = time;
  iHis = zeros(Buildings.Controls.Types.nDayTypes, nSam);
  //typeOfDay = Buildings.Controls.Types.Day.WorkingDay;
  for i in 1:Buildings.Controls.Types.nDayTypes loop
     for k in 1:nSam loop
       historyComplete[i,k] = false;
     end for;
   end for;

   _isEventDay = false;
   simStart = time;// fixme: this should be a multiple of samplePeriod

   // Compute the offset of the index that is used to look up the data for
   // the dayOfAdj
   if use_dayOfAdj then
     assert(iDayOf_start < iDayOf_end, "
Wrong values for parameters.
  Require dayOfAdjustement_start < dayOfAdjustement_end + 86400/nSam.
  Received dayOfAdj_start = " + String(dayOfAdj_start) + "
           dayOfAdj_end   = " + String(dayOfAdj_end));
   end if;

equation
  sampleTrigger = sample(simStart, samplePeriod);
  if predictionModel == Buildings.Controls.DemandResponse.Types.PredictionModel.WeatherRegression then
    der(intTOut) = TOut;
  else
    intTOut = 0;
  end if;
algorithm
  when sampleTrigger then
    // Set flag for event day.
    _isEventDay :=if pre(_isEventDay) and (not iSam == 1) then true else isEventDay;

    // fixme: accessing an array element with an enumeration
    //        is not valid Modelica.

    // Update the history terms with the average power of the time interval,
    // unless we have an event day.
    idxSam :=getIndex(iSam - 1, nSam);
    if not _isEventDay then
      if (time - tLast) > 1E-5 then
        // Update iHis, which points to where the last interval's power
        // consumption will be stored.
        iHis[pre(typeOfDay), idxSam] := incrementIndex(iHis[pre(typeOfDay), idxSam], nHis);
        if iHis[pre(typeOfDay), idxSam] == nHis then
          historyComplete[pre(typeOfDay), idxSam] :=true;
        end if;
        PAve :=(ECon - ELast)/(time - tLast);
        P[pre(typeOfDay), idxSam, iHis[pre(typeOfDay), idxSam]] := PAve;
        if predictionModel == Types.PredictionModel.WeatherRegression then
          T[pre(typeOfDay), idxSam, iHis[pre(typeOfDay), idxSam]] := (intTOut-intTOutLast)/(time - tLast);
        end if;
      end if;
    end if;
    // Initialized the energy consumed since the last sampling
    ELast := ECon;
    intTOutLast :=intTOut;
    tLast := time;

    // Compute the baseline prediction for the current hour,
    // with k being equal to the number of stored history terms.
    // If in a later implementation, we want more terms into the future, then
    // a loop should be added over for i = iSam...upper_bound, whereas
    // the loop needs to wrap around nSam.
     Modelica.Utilities.Streams.print("time = " + String(time/3600) + " historyComplete = " + String(historyComplete[pre(typeOfDay), iSam]) + " iHis=" + String(iHis[pre(typeOfDay), iSam]));

    if predictionModel == Buildings.Controls.DemandResponse.Types.PredictionModel.Average then
      PPre :=Buildings.Controls.DemandResponse.BaseClasses.average(
          P={P[typeOfDay, iSam, i] for i in 1:nHis},
          k=if historyComplete[typeOfDay, iSam] then nHis else iHis[typeOfDay, iSam]);
    elseif predictionModel == Buildings.Controls.DemandResponse.Types.PredictionModel.WeatherRegression then
      PPre :=Buildings.Controls.DemandResponse.BaseClasses.weatherRegression(
          TCur=TOut,
          T={T[typeOfDay, iSam, i] for i in 1:nHis},
          P={P[typeOfDay, iSam, i] for i in 1:nHis},
          k=if historyComplete[typeOfDay, iSam] then nHis else iHis[typeOfDay, iSam]);
    else
      PPre:= 0;
      assert(false, "Wrong value for prediction model.");
    end if;

    if use_dayOfAdj then

      // Store the predicted power consumption. This variable is stored
      // to avoid having to compute the average or weather regression multiple times.
      PPreHis[typeOfDay,    getIndex(iDayOf, -iDayOf_start+1)] :=  PPre;

      // If iHis == 0, then there is no history yet and hence PPre is 0.
      PPreHisSet[typeOfDay, getIndex(iDayOf, -iDayOf_start+1)] :=  (iHis[typeOfDay, iSam] > 0);
      Modelica.Utilities.Streams.print("Setting PPre[" + String(getIndex(iDayOf, -iDayOf_start+1)) +"] = " + String(PPre) + " with iHis = " + String(iHis[typeOfDay, iSam]));

      // Compute average historical load.
      // This is a running sum over the past nHis days for the time window from iDayOf_start to iDayOf_end.
      // Fixme: check in SineInput whether EHisAve is offset by 1 time unit compared to EActAve
      EHisAve := 0;
      EActAve := 0;
      for i in iDayOf_start:iDayOf_end-1 loop
        if PPreHisSet[typeOfDay, getIndex(iDayOf+i, -iDayOf_start+1)] then
           EHisAve := EHisAve + dt*PPreHis[typeOfDay, getIndex(iDayOf+i, -iDayOf_start+1)];
           EActAve := EActAve + dt*P[typeOfDay,
                         getIndex(idxSam+i+1, nSam),
                         iHis[typeOfDay, getIndex(idxSam+i+1, nSam)]];
         Modelica.Utilities.Streams.print(" Adding for i=" + String(i) + " and getIndex()="+ String(getIndex(iDayOf+i, -iDayOf_start+1))
                                                        + "  PPreHis="  + String(PPreHis[typeOfDay, getIndex(iDayOf+i, -iDayOf_start+1)]) + "  P=" + String(P[typeOfDay,
                         getIndex(idxSam+i+1, nSam),
                         iHis[typeOfDay, getIndex(idxSam+i+1, nSam)]]));
        end if;
      end for;

      // Compute the load adjustment factor.
      if (EHisAve > Modelica.Constants.eps or
          EHisAve < -Modelica.Constants.eps) and
          Modelica.Math.BooleanVectors.allTrue({PPreHisSet[typeOfDay, getIndex(iDayOf+i, -iDayOf_start+1)] for i in iDayOf_start:iDayOf_end-1}) then
        adj := EActAve/EHisAve + 0*min(maxAdjFac, max(minAdjFac, EActAve/EHisAve)); // fixme
      else
        adj := 1;
      end if;
      PPre :=PPre*adj;
    else
      EActAve := 0;
      EHisAve := 0;
      PPreHis[typeOfDay, getIndex(iDayOf, -iDayOf_start+1)] := 0;
      PPreHisSet[typeOfDay, getIndex(iDayOf, -iDayOf_start+1)] :=  false;
      adj := 1;
    end if;

    // Update iSam and iDayOf
    iSam   := incrementIndex(iSam, nSam);
    iDayOf := incrementIndex(iDayOf, -iDayOf_start+1);

  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100}, {100,100}}),
                   graphics={Text(
          extent={{-70,64},{74,-54}},
          lineColor={0,0,255},
          textString="BL")}),
    Documentation(info="<html>
<p>
Block that computes the baseline for a demand response client.
This implementation computes either an average baseline or
a linear regression, optionally with a day-of adjustment.
</p>
<h4>Computation of baseline</h4>
<p>
Separate baselines are computed for any types of days.
The type of day is an input signal received from the connector
<code>typeOfDay</code>, and must be equal to any value defined
in
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>.
</p>
<p>
The average baseline is the average of the consumed power of the previous
<i>n<sub>his</sub></i> days for the same time interval. The default value is
<i>n<sub>his</sub>=10</i> days.
For example, if the baseline is
computed every 1 hour, then there are 24 baseline values for each day,
each being the average power consumed in the past 10 days that have the same
<code>typeOfDay</code>.
</p>
<p>
The linear regression model computes the predicted power as a linear function of the
current outside temperature. The two coefficients for the linear function are
obtained using a regression of the past <i>n<sub>his</sub></i> days.
</p>
<p>
If a day is an event day, then any hour of this day after the event signal
is received is excluded from the baseline computation.
Storing history terms for the base line resumes at midnight.
</p>
<p>
If no history term is present for the current time interval and
the current type of day, then the predicted power consumption
<code>PPre</code> will be zero.
</p>
<h4>Day-of adjustment</h4>
<p>
If the parameter <code>use_dayOfAdj = true</code>, then the
day-of adjustment is computed. (Some literature call this
morning-of adjustment, but we call it day-of adjustment because
the adjustment can also be in the afternoon if the peak is
in the late afternoon hours).
The day-of adjustment can be used with any of the above baseline computations.
The parameters <code>dayOfAdj_start</code> and <code>dayOfAdj_end</code>
determine the time window during which the day-of adjustment is computed.
Both need to be negative times, measured in seconds prior to the time
at which the power consumption is predicted.
For example, to use a day-of adjustment for the window of <i>4</i> to <i>1</i>
hours prior to the event time, set
<code>dayOfAdj_start=-4*3600</code> and <code>dayOfAdj_end=-3600</code>.
</p>
<p>
The day-of adjustment is computed as follows: First,
the average power <i>P<sub>ave</sub></i> consumed
over the day-of time window is computed. Next, the average power
<i>P<sub>his</sub></i>
is computed for the past <i>n<sub>his</sub></i> days.
Then, the adjustment factor is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
a = min(a<sub>max</sub>, max(a<sub>min</sub>, P<sub>ave</sub> &frasl; P<sub>his</sub>),
</p>
<p>
where <i>a<sub>min</sub></i> and <i>a<sub>max</sub></i> are the minimum
and maximum adjustment factors as defined by the parameters
<code>adjFacMin</code> and <code>adjFacMax</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2014 by Michael Wetter:<br/>
First implementation.
</li><li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end BaselinePrediction;
