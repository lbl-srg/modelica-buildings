within Buildings.Rooms;
model FFD
  "Model of a room in which the air is computed using fast fluid flow dynamics"
  extends Buildings.Rooms.MixedAir(
  redeclare BaseClasses.AirHeatMassBalanceFFD air(
    final useFFD=useFFD,
    final samplePeriod=samplePeriod,
    final startTime=startTime));

  parameter Boolean useFFD = true
    "Set to false to deactivate the FFD computation and use instead yFixed as output"
    annotation(Evaluate = true);

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Modelica.SIunits.Time startTime
    "First sample time instant. fixme: this should be at first step."
    annotation(Dialog(group = "Sampling"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={Rectangle(
          extent={{-140,138},{140,78}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end FFD;
