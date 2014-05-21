within Buildings.Controls.DemandResponse.BaseClasses;
block BaselineComputation "Computes the baseline consumption"
  extends Buildings.Controls.DemandResponse.BaseClasses.PartialDemandResponse;

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay
    "If true, this day remains an event day until midnight" annotation (
      Placement(transformation(extent={{-120,90},{-100,70}}),
        iconTransformation(extent={{-120,90},{-100,70}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-120,50},{-100,30}}),
        iconTransformation(extent={{-120,50},{-100,30}})));
  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";
  discrete Modelica.SIunits.Power P[Types.nDayTypes, nSam, nHis]
    "Baseline power consumption";
  Modelica.SIunits.Energy E "Consumed energy since last sample";

protected
  Modelica.SIunits.Time tLast "Time at which last sample occured";
  Integer iSam "Index for power of the current sampling interval";
  Integer iHis[Types.nDayTypes, nSam]
    "Index for power of the current sampling history, for the currrent time interval";
  Boolean historyComplete[Types.nDayTypes, nSam]
    "Flage, set to true when all history terms are built up for the given day type and given time interval";
  Boolean firstCall "Set to true after first call";

  discrete Boolean _isEventDay
    "Flag, switched to true when block gets an isEvenDay=true signal, and remaining true until midnight";
  function baseline
    input Modelica.SIunits.Power P[:]
      "Vector of power consumed in each interval of the current time of day";
    input Integer k "Number of history terms that have already been stored";
    output Modelica.SIunits.Power y "Baseline power consumption";
  algorithm
    if k == 0 then
      y := 0;
    else
      y :=sum(P[i] for i in 1:k)/k;
    end if;
  end baseline;

initial equation
   P = zeros(Types.nDayTypes, nSam, nHis);
   iSam = 1;
   iHis = ones(Types.nDayTypes, nSam);
   for i in 1:Types.nDayTypes loop
     for k in 1:nSam loop
       historyComplete[i,k] = false;
     end for;
   end for;
   firstCall = true;
   _isEventDay = false;
equation
  der(E) = PCon;
algorithm
  when localActive then
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
    PPre :=baseline(P={P[typeOfDay, iSam, i] for i in 1:nHis},
                    k=if pre(historyComplete[typeOfDay, iSam]) then nHis else pre(iHis[typeOfDay, iSam])-1);

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
This implementation computes the 10/10 average baseline.
This baseline is the average of the consumed power of the previous
10 days for the same time interval. For example, if the base line is
computed every 1 hour, then there are 24 baseline values for each day.
Separate baselines are computed for any types of days.
The type of day is an input signal received from the connector
<code>typeOfDay</code>, and must be equal to any value defined
in
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>.
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end BaselineComputation;
