within Buildings.Controls.DemandResponse.BaseClasses;
block BaselineComputation "Computes the baseline consumption"
  extends Modelica.StateGraph.Step;
  parameter Integer nSam = 24
    "Number of intervals for which baseline is computed";

  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for current hour"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  discrete Modelica.SIunits.Power P[nSam] "Baseline power consumption";
  Modelica.SIunits.Energy E "Consumed energy since last sample";
protected
  Modelica.SIunits.Time tLast "Time at which last sample occured";

initial equation
   P = zeros(nSam);
equation
  der(E) = PCon;
  PPre = P[1];
algorithm
  when localActive then
    // Shift power consumption by one time unit
    for i in 1:nSam-1 loop
      P[i] :=pre(P[i + 1]);
    end for;
    // Update the last entry with the consumption
    // over the last time interval.
    P[nSam] := if (time-pre(tLast)) < 1E-5 then 0 else pre(E)/(time - pre(tLast));
    // Initialized the energy consumed since the last sampling
    reinit(E, 0);
    tLast :=time;
  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-70,64},{74,-54}},
          lineColor={0,0,255},
          textString="BL")}));
end BaselineComputation;
