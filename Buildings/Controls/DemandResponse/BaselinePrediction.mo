within Buildings.Controls.DemandResponse;
block BaselinePrediction "Block that computes the baseline consumption"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer nSam = 24
    "Number of intervals in a day for which baseline is computed";

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K") "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Currently consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for the current time interval"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay
    "If true, this day remains an event day until midnight" annotation (
      Placement(transformation(extent={{-140,120},{-100,80}}),
        iconTransformation(extent={{-140,120},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-140,70},{-100,30}})));
  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";

  parameter Buildings.Controls.DemandResponse.Types.PredictionModel
    predictionModel = Types.WeatherRegression "Load prediction model";

  discrete Modelica.SIunits.Power P[Buildings.Controls.Types.nDayTypes,nSam,nHis]
    "Baseline power consumption";
  discrete Modelica.SIunits.Temperature T[Buildings.Controls.Types.nDayTypes,nSam,nHis]
    "Temperature history";

  Modelica.SIunits.Energy E "Consumed energy since last sample";

protected
  parameter Modelica.SIunits.Time samplePeriod=86400/nSam
    "Sample period of the component";
  parameter Modelica.SIunits.Time simStart(fixed=false)
    "Time when the simulation started";
  output Boolean sampleTrigger "True, if sample time instant";

  Modelica.SIunits.Time tLast "Time at which last sample occured";
  Integer iSam "Index for power of the current sampling interval";
  Integer iHis[Buildings.Controls.Types.nDayTypes,nSam]
    "Index for power of the current sampling history, for the currrent time interval";
  Boolean historyComplete[Buildings.Controls.Types.nDayTypes,nSam]
    "Flage, set to true when all history terms are built up for the given day type and given time interval";
  output Boolean firstCall "Set to true after first call";

  discrete Boolean _isEventDay
    "Flag, switched to true when block gets an isEvenDay=true signal, and remaining true until midnight";

initial equation
  P = zeros(
    Buildings.Controls.Types.nDayTypes,
    nSam,
    nHis);
   iSam = 1;
  iHis = ones(Buildings.Controls.Types.nDayTypes, nSam);
  for i in 1:Buildings.Controls.Types.nDayTypes loop
     for k in 1:nSam loop
       historyComplete[i,k] = false;
     end for;
   end for;
   firstCall = true;
   _isEventDay = false;
   simStart = time;// fixme: this should be a multiple of samplePeriod
equation
  der(E) = PCon;
  sampleTrigger = sample(simStart, samplePeriod);

algorithm
  when sampleTrigger then
    // Set flag for event day.
    _isEventDay :=if pre(_isEventDay) and (not iSam == nSam) then true else isEventDay;
    // Update iHis, which points to where the last interval's power
    // consumption will be stored.
    if pre(iHis[pre(typeOfDay), pre(iSam)]) == nHis then
      historyComplete[pre(typeOfDay), pre(iSam)] :=true;
      iHis[pre(typeOfDay), pre(iSam)] :=1;
    end if;

    // Update iSam
    if pre(iSam) == nSam then
      // We reached midnight. Reset iSam so that it points to the first sampling interval.
      iSam :=1;
    else
      // Increment iSam
      iSam :=if pre(firstCall) then pre(iSam) else pre(iSam) + 1;
    end if;
    // Set flag for first call to false.
    if pre(firstCall) then
      firstCall :=false;
    end if;
    // Update the history terms with the average power of the time interval,
    // unless we have an event day.
    // If we received a signal that there is an event day, then
    // store the power consumption during the interval immediately before the signal,
    // and then don't store any more results until the first interval after midnight past.
    // We use the pre() operator because the past sampling interval can still be
    // stored if we switch right now to an event day.
    if not pre(_isEventDay) then
      if (time - pre(tLast)) > 1E-5 then
        P[pre(typeOfDay), pre(iSam), pre(iHis[pre(typeOfDay), pre(iSam)])] := pre(E)/(time - pre(tLast));
        T[pre(typeOfDay), pre(iSam), pre(iHis[pre(typeOfDay), pre(iSam)])] := pre(TOut);
        iHis[pre(typeOfDay), pre(iSam)] := mod(pre(iHis[pre(typeOfDay), pre(iSam)]), nHis)+1;
      end if;
    end if;
    if not _isEventDay then
      // Initialized the energy consumed since the last sampling
      reinit(E, 0);
      tLast :=time;
    end if;

    // Compute the baseline prediction for the current hour,
    // with k being equal to the number of stored history terms.
    // If in a later implementation, we want more terms into the future, then
    // a loop should be added over for i = iSam...upper_bound, whereas
    // the loop needs to wrap around nSam.
    if predictionModel == Buildings.Controls.DemandResponse.Types.PredictionModel.Average then
      PPre :=Buildings.Controls.DemandResponse.BaseClasses.average(
          P={P[typeOfDay, iSam, i] for i in 1:nHis},
          k=if pre(historyComplete[typeOfDay, iSam]) then nHis else pre(iHis[typeOfDay, iSam])-1);
    elseif predictionModel == Buildings.Controls.DemandResponse.Types.PredictionModel.WeatherRegression then
      PPre :=Buildings.Controls.DemandResponse.BaseClasses.weatherRegression(
          TCur=TOut,
          T={T[typeOfDay, iSam, i] for i in 1:nHis},
          P={P[typeOfDay, iSam, i] for i in 1:nHis},
          k=if pre(historyComplete[typeOfDay, iSam]) then nHis else pre(iHis[typeOfDay, iSam])-1);
    else
      PPre:= 0;
      assert(false, "Wrong value for prediction model.");
    end if;

  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Text(
          extent={{-70,64},{74,-54}},
          lineColor={0,0,255},
          textString="BL")}),
    Documentation(info="<html>
<p>
Block that computes the baseline for a demand response client.
This implementation computes either an average baseline or 
a linear regression.
</p>
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
For example, if the base line is
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
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end BaselinePrediction;
