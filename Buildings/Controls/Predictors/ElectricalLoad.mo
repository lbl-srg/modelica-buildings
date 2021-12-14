within Buildings.Controls.Predictors;
block ElectricalLoad "Block that predicts an electrical load"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  parameter Integer nSam(min=1) = 24
    "Number of intervals in a day for which baseline is computed";

  parameter Integer nPre(min=1) = 1
    "Number of intervals for which future load need to be predicted (set to one to only predict current time, or to nSam to predict one day)";

  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";

  parameter Buildings.Controls.Predictors.Types.PredictionModel
    predictionModel = Types.PredictionModel.WeatherRegression
    "Load prediction model";

  parameter Boolean use_dayOfAdj=true "if true, use the day of adjustment"
    annotation (Dialog(group="Day of adjustment"));

  parameter Modelica.Units.SI.Time dayOfAdj_start(
    max=0,
    displayUnit="h") = -14400
    "Number of hours prior to current time when day of adjustment starts"
    annotation (Evaluate=true, Dialog(enable=use_dayOfAdj, group=
          "Day of adjustment"));

  parameter Modelica.Units.SI.Time dayOfAdj_end(
    max=0,
    displayUnit="h") = -3600
    "Number of hours prior to current time when day of adjustment ends"
    annotation (Evaluate=true, Dialog(enable=use_dayOfAdj, group=
          "Day of adjustment"));

  parameter Real minAdjFac(min=0) = 0.8 "Minimum adjustment factor"
    annotation (Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  parameter Real maxAdjFac(min=0) = 1.2 "Maximum adjustment factor"
    annotation (Dialog(enable=use_dayOfAdj,
                group="Day of adjustment"));

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K")
  if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput TOutFut[nPre-1](each unit="K")
    if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Future outside air temperatures"
    annotation (Placement(
       transformation(extent={{-140,-120},{-100,-80}}),
       iconTransformation(extent={{-140,-120},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealInput ECon(unit="J", nominal=1E5)
    "Consumed electrical energy"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  discrete Modelica.Blocks.Interfaces.RealOutput PPre[nPre](each unit="W")
    "Predicted power consumptions (first element is for current time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay[integer((nPre-1)/nSam)+2] "Type of day for the current and the future days for which a prediction is to be made.
    Typically, this has dimension 2 for predictions up to and including 24 hours, and 2+n for any additional day"
    annotation (
      Placement(transformation(extent={{-140,120},{-100,80}}),
        iconTransformation(extent={{-140,120},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanInput storeHistory
    "If false, history terms are no longer stored for the remainder of the day"
    annotation (Placement(transformation(extent={{-140,70},{-100,30}})));

  discrete Real adj(unit="1") "Load adjustment factor";
protected
  parameter Modelica.Units.SI.Time samplePeriod=86400/nSam
    "Sample period of the component";
  parameter Modelica.Units.SI.Time samStart(fixed=false)
    "Time when the first sampling starts";
  parameter Integer iDayOf_start = integer((nSam*dayOfAdj_start/86400+1E-8))
    "Counter where day of look up begins";
  parameter Integer iDayOf_end = integer((nSam*dayOfAdj_end  /86400+1E-8))
    "Counter where day of look up ends";

  parameter Integer nDayOf = iDayOf_end-iDayOf_start
    "Number of samples used for the day of adjustment";
  parameter Modelica.Units.SI.Time dt=86400/nSam
    "Length of one sampling interval";
  discrete Modelica.Units.SI.Power PAve "Average power over the past interval";
  Boolean sampleTrigger "True, if sample time instant";

  discrete output Modelica.Units.SI.Energy ELast "Energy at the last sample";
  discrete output Modelica.Units.SI.Time tLast
    "Time at which last sample occurred";
  output Integer[nPre] iSam "Index for power of the current sampling interval";

  discrete output Modelica.Units.SI.Power P[Buildings.Controls.Types.nDayTypes,
    nSam,nHis] "Baseline power consumption";
  // The temperature history is set to a zero array if it is not needed.
  // This significantly reduces the size of the code that needs to be compiled.

  discrete output Modelica.Units.SI.Temperature T[if predictionModel == Types.PredictionModel.WeatherRegression
     then Buildings.Controls.Types.nDayTypes else 0,if predictionModel == Types.PredictionModel.WeatherRegression
     then nSam else 0,if predictionModel == Types.PredictionModel.WeatherRegression
     then nHis else 0] "Temperature history";

  Integer _typeOfDay[nPre]
    "Type of day for each time interval for which prediction is to be made";

  Integer iHis[Buildings.Controls.Types.nDayTypes,nSam]
    "Index for power of the current sampling history, for the currrent time interval";
  Boolean historyComplete[Buildings.Controls.Types.nDayTypes,nSam](each start=false, each fixed=true)
    "Flage, set to true when all history terms are built up for the given day type and given time interval";

  Boolean _storeHistory
    "Flag, switched to false when block gets an storeHistory=false signal, and remaining false until midnight";

  discrete Modelica.Units.SI.Energy EActAve
    "Actual energy over the day off period";
  discrete Modelica.Units.SI.Energy EHisAve
    "Actual load over the day off period, summed over all time intervals";

  discrete Modelica.Units.SI.Power PPreHis[Buildings.Controls.Types.nDayTypes,
    nSam] "Predicted power consumptions for all day off time intervals";
  Boolean PPreHisSet[Buildings.Controls.Types.nDayTypes, nSam](each start=false, each fixed=true)
    "Flag, true if a value in PPreHis has been set for that element";

  // If predictionModel <> Types.PredictionModel.WeatherRegression,
  // then intTOut = 0 and hence we set fixed=false.
  // This is required to avoid a warning if model is translated in pedantic mode
  // in Dymola 2016.
  Real intTOut(unit="K.s",
               start=0,
               fixed = (predictionModel == Types.PredictionModel.WeatherRegression))
    "Time integral of outside temperature";
  discrete Real intTOutLast(unit="K.s")
    "Last sampled value of time integral of outside temperature";

  Integer idxSam "Index to access iSam[1]";

  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput TOut_in_internal(unit="K")
    "Needed to connect to conditional connector";

  Modelica.Blocks.Interfaces.RealInput TOutFut_in_internal[nPre-1](each unit="K")
    "Needed to connect to conditional connector";

  // Functions
  function isMidNight
    input Modelica.Units.SI.Time t "Simulation time";
    output Boolean r "True if time is midnight, false otherwise";
  algorithm
    r := rem(t, 86400.0) < 1;
  end isMidNight;

  function getTypeOfDays
    input Modelica.Units.SI.Time t "Simulation time";
    input Buildings.Controls.Types.Day[:] typeOfDay
      "Type of day as received from input connector";
    input Modelica.Units.SI.Time dt "Length of one sampling interval";
    input Integer nPre "Number of predictions to be made";
    output Integer[nPre] tod "Type of day for each prediction interval";
  protected
    Integer itod "Pointer to the type of day";
  algorithm
    tod[1] :=Integer(typeOfDay[1]);
    if nPre > 1 then
      itod :=1;
      for i in 2:nPre loop
        // We reached mid-night. Hence, we need to take the next type of day.
        if isMidNight(t + (i-1)*dt) then
          itod := itod + 1;
        end if;
        tod[i] :=Integer(typeOfDay[itod]);
      end for;
    end if;
    annotation(LateInline=true);
  end getTypeOfDays;

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
  for i in 1:nPre loop
    iSam[i] = i;
  end for;

  P = zeros(
    Buildings.Controls.Types.nDayTypes,
    nSam,
    nHis);
  PPre = zeros(nPre);

  T = zeros(size(T,1), size(T,2), size(T,3));

  EActAve    = 0;
  EHisAve    = 0;
  PPreHis    = zeros(Buildings.Controls.Types.nDayTypes, nSam);

  ELast = 0;
  intTOutLast = 0;
  tLast = time;
  iHis = zeros(Buildings.Controls.Types.nDayTypes, nSam);

   _storeHistory = true;
   samStart = Buildings.Controls.Predictors.BaseClasses.sampleStart(
     t=time,
     samplePeriod=samplePeriod);

   for i in 1:nPre loop
      _typeOfDay[i] =  Integer(Buildings.Controls.Types.Day.WorkingDay);
   end for;

   // Compute the offset of the index that is used to look up the data for
   // the dayOfAdj
   if use_dayOfAdj then
     assert(iDayOf_start < iDayOf_end, "
Wrong values for parameters.
  Require dayOfAdjustement_start < dayOfAdjustement_end + 86400/nSam.
  Received dayOfAdj_start = " + String(dayOfAdj_start) + "
           dayOfAdj_end   = " + String(dayOfAdj_end));
   end if;
   idxSam = 0;
   adj = 1;
   PAve = 0;
equation
  // Conditional connector
  connect(TOut,    TOut_in_internal);
  connect(TOutFut, TOutFut_in_internal);
  if predictionModel <> Types.PredictionModel.WeatherRegression then
    TOutFut_in_internal = zeros(nPre-1);
    TOut_in_internal = 0;
  end if;

  // Sample trigger
  sampleTrigger = sample(samStart, samplePeriod);

  // Averaging of outside temperature
  if predictionModel == Types.PredictionModel.WeatherRegression then
    der(intTOut) = TOut_in_internal;
  else
    intTOut = 0;
  end if;

algorithm

  when sampleTrigger then
    // Set flag for event day.
    // isMidnight is true if time is within 1 second of midnight.
    _storeHistory :=if not pre(_storeHistory) and (not isMidNight(t=time)) then false else storeHistory;

    _typeOfDay := getTypeOfDays(t=time, typeOfDay=typeOfDay, dt=dt, nPre=nPre);

    // Index to access iSam[1]
    idxSam :=getIndex(iSam[1] - 1, nSam);

    // Update the history terms with the average power of the time interval,
    // unless we have an event day.
    if (_storeHistory) or (pre(_storeHistory)) then
      if (time - tLast) > 1E-5 then
        // Update iHis, which points to where the last interval's power
        // consumption will be stored.
        iHis[pre(_typeOfDay[1]), idxSam] :=
          incrementIndex(iHis[pre(_typeOfDay[1]), idxSam], nHis);
        if iHis[pre(_typeOfDay[1]), idxSam] == nHis then
          historyComplete[pre(_typeOfDay[1]), idxSam] :=true;
        end if;
        PAve :=(ECon - ELast)/(time - tLast);
        P[pre(_typeOfDay[1]), idxSam, iHis[pre(_typeOfDay[1]), idxSam]] := PAve;
        if predictionModel == Types.PredictionModel.WeatherRegression then
          T[pre(_typeOfDay[1]), idxSam, iHis[pre(_typeOfDay[1]), idxSam]] := (intTOut-intTOutLast)/(time - tLast);
        end if;
      end if;
    end if;
    // Initialize the energy consumed since the last sampling.
    ELast := ECon;
    intTOutLast :=intTOut;
    tLast := time;

    // Compute the baseline prediction for the current hour,
    // with k being equal to the number of stored history terms.
    // If in a later implementation, we want more terms into the future, then
    // a loop should be added over for i = iSam[1]...upper_bound, whereas
    // the loop needs to wrap around nSam.
    if predictionModel == Types.PredictionModel.Average then
      for m in 1:nPre loop
        // Note that as this branch does not use TOutFut, at every time step, computations
        // are repeated because PPre[m] = pre(PPre[m+1]). This could be improved
        // in future versions.
        PPre[m] :=Buildings.Controls.Predictors.BaseClasses.average(
                    P={P[_typeOfDay[m], iSam[m], i] for i in 1:nHis},
                    k=if historyComplete[_typeOfDay[m], iSam[m]] then nHis else iHis[_typeOfDay[m], iSam[m]]);
      end for;
    elseif predictionModel == Types.PredictionModel.WeatherRegression then
      for m in 1:nPre loop
        PPre[m] :=Buildings.Controls.Predictors.BaseClasses.weatherRegression(
                    TCur=if m == 1 then TOut_in_internal else TOutFut_in_internal[m-1],
                    T={T[_typeOfDay[m], iSam[m], i] for i in 1:nHis},
                    P={P[_typeOfDay[m], iSam[m], i] for i in 1:nHis},
                    k=if historyComplete[_typeOfDay[m], iSam[m]] then nHis else iHis[_typeOfDay[m], iSam[m]]);
      end for;
    else
      PPre:= zeros(nPre);
      assert(false, "Wrong value for prediction model.");
    end if;

    if use_dayOfAdj then
      if _storeHistory or pre(_storeHistory) then

        // Store the predicted power consumption. This variable is stored
        // to avoid having to compute the average or weather regression multiple times.
        PPreHis[_typeOfDay[1],    getIndex(idxSam+1, nSam)] :=  PPre[1];

        // If iHis == 0, then there is no history yet and hence PPre[1] is 0.
        PPreHisSet[_typeOfDay[1], getIndex(idxSam+1, nSam)] :=  (iHis[_typeOfDay[1], iSam[1]] > 0);
      end if;
      // Compute average historical load.
      // This is a running sum over the past nHis days for the time window from iDayOf_start to iDayOf_end.
      EHisAve := 0;
      EActAve := 0;
      for i in iDayOf_start:iDayOf_end-1 loop
        if Modelica.Math.BooleanVectors.allTrue(
           {PPreHisSet[_typeOfDay[1], getIndex(iSam[1]+i, nSam)] for i in iDayOf_start:iDayOf_end-1}) then
           EHisAve := EHisAve + dt*PPreHis[_typeOfDay[1],
                        getIndex(idxSam+i+1, nSam)];
           EActAve := EActAve + dt*P[_typeOfDay[1],
                        getIndex(idxSam+i+1, nSam), iHis[_typeOfDay[1], getIndex(idxSam+i+1, nSam)]];
        else
          EHisAve := 0;
          EActAve := 0;
        end if;
      end for;

      // Compute the load adjustment factor.
      if (EHisAve > Modelica.Constants.eps or EHisAve < -Modelica.Constants.eps) then
        adj := min(maxAdjFac, max(minAdjFac, EActAve/EHisAve));
      else
        adj := 1;
      end if;
      // Apply the load adjustment factor to all predicted loads, not only to the
      // predicted load of the current time step.
      PPre[:] :=PPre[:]*adj;
    else
      EActAve := 0;
      EHisAve := 0;
      PPreHis[_typeOfDay[1], getIndex(iSam[1], nSam)] := 0;
      PPreHisSet[_typeOfDay[1], getIndex(iSam[1], nSam)] :=  false;
      adj := 1;
    end if;

    // Update iSam
    for i in 1:nPre loop
      iSam[i]   := incrementIndex(iSam[i], nSam);
    end for;

  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100}, {100,100}}),
                   graphics={Text(
          extent={{-70,64},{74,-54}},
          textColor={0,0,255},
          textString="BL")}),
    Documentation(info="<html>
<p>
Data-driven model that predicts the electrical load.
This load prediction can for example be used in a demand response client.
</p>
<p>
The model computes either an average baseline or
a linear regression with respect to outside temperature.
For both, optionally a day-of adjustment can be made.
</p>
<h4>Computation of baseline</h4>
<p>
Separate loads are computed for any types of days.
The type of day is an input signal received from the connector
<code>typeOfDay</code>, and must be equal to any value defined
in
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>.
This input is a vector where the first element corresponds to the
current day, the next element to tomorrow, and so on.
The dimension of this input vector is typically <i>2</i> if
the demand is to be predicted for the next <i>24</i> hours.
If it is for the next <i>48</i> hours, then the dimension is <i>3</i>.
Using a vector is required as the prediction could be
from noon of a workday to noon of a holiday or week-end day.
</p>
<p>
The average baseline is the average of the consumed power of the previous
<i>n<sub>his</sub></i> days for the same time interval. The default value is
<i>n<sub>his</sub>=10</i> days.
For example, if the prediction is mode for 1 hour time windows,
then there are 24 baseline values for each day,
each being the average power consumed in the past 10 days that have the same
<code>typeOfDay</code>.
</p>
<p>
The linear regression model computes the predicted power as a linear function of the
current outside temperature. The two coefficients for the linear function are
obtained using a regression of the past <i>n<sub>his</sub></i> days.
</p>
<p>
If the input signal <code>storeHistory</code> is <code>true</code>, then
the prediction is no longer carried out for this day until midnight.
For example, if used for a demand respond client, on an event day,
one may want to set <code>storeHistory=true</code> when the building operates
in demand respond mode. Then any time interval after this signal
is received is excluded from the baseline computation.
Storing history terms for the baseline resumes automatically at midnight.
</p>
<p>
If no history term is present for the current time interval and
the current type of day, then the predicted power consumption
<code>PPre[:]</code> will be zero.
</p>
<h4>Day-of adjustment</h4>
<p>
If the parameter <code>use_dayOfAdj = true</code>, then the
day-of adjustment is computed. (Some literature call this
morning-of adjustment, but we call it day-of adjustment because
the adjustment can also be in the afternoon if the peak is
in the late afternoon hours.)
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
a = min(a<sub>max</sub>, max(a<sub>min</sub>, P<sub>ave</sub> &frasl; P<sub>his</sub>)),
</p>
<p>
where <i>a<sub>min</sub></i> and <i>a<sub>max</sub></i> are the minimum
and maximum adjustment factors as defined by the parameters
<code>adjFacMin</code> and <code>adjFacMax</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2015 by Michael Wetter:<br/>
Updated model to allow translation
using pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
October 29, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
October 25, 2014, by Michael Wetter:<br/>
Implemented new assignment of the start of the sampling.
</li>
<li>
September 6, 2014 by Michael Wetter:<br/>
Moved to package <code>Buildings.Controls.Predictors</code>.
</li>
<li>
July 10, 2014 by Michael Wetter:<br/>
First implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricalLoad;
