within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.Validation;
model AirTemperatureLockout
  "Validation model for room air temperature lockouts"

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=1/7200,
    phase(displayUnit="rad"),
    offset=TZonHigLim) "Varying air temperature"
    annotation (Placement(transformation(extent={{-82,-80},{-62,-60}})));
  final parameter Real TZonHigLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
   final parameter Real TZonLowLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";

  Controls.OBC.CDL.Continuous.Sources.Constant THigRoo(k=TZonHigLim + 2)
    "Temperature above high limit"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TLowRoo(k=TZonLowLim - 2)
    "Temperature below high limit"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TMedRoo(k=TZonLowLim + 2)
    "Temperature between limits"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit airTemLim(
    final TZonHigSet=TZonHigLim,
    final TZonLowSet=TZonLowLim) "Air temperature limit"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit airTemLim1(
    final TZonHigSet=TZonHigLim,
    final TZonLowSet=TZonLowLim) "Air temperature limit"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit airTemLim2(
    final TZonHigSet=TZonHigLim,
    final TZonLowSet=TZonLowLim) "Air temperature limit"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit airTemLim3(
    final TZonHigSet=TZonHigLim,
    final TZonLowSet=TZonLowLim) "Air temperature limit"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(sin.y, airTemLim3.TRoo) annotation (Line(points={{-60,-70},{-40,-70},
          {-40,-62.8},{-22,-62.8}}, color={0,0,127}));
  connect(TLowRoo.y, airTemLim2.TRoo) annotation (Line(points={{-58,-30},{-40,-30},
          {-40,-22.8},{-22,-22.8}}, color={0,0,127}));
  connect(TMedRoo.y, airTemLim1.TRoo) annotation (Line(points={{-58,10},{-40,10},
          {-40,17.2},{-22,17.2}}, color={0,0,127}));
  connect(THigRoo.y, airTemLim.TRoo) annotation (Line(points={{-58,50},{-40,50},
          {-40,57.2},{-22,57.2}}, color={0,0,127}));
  annotation (Documentation(info="<html>
  <p>
  Validates the air temperature lockout model. 
  If room air temperature is above a specified temperature threshold, heating is locked out.
  If room air temperature is below a specified temperature threshold, cooling is locked out.
  Output is expressed as a heating or cooling signal. If the heating signal is true, heating is allowed (ie, it is not locked out).
  If the cooling signal is true, cooling is allowed (ie, it is not locked out).
  A true signal indicates only that heating or cooling is *permitted*- it does *not* indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint (see SlabTempSignal for more info).
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),experiment(StartTime=0, StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Lockouts/SubLockouts/Validation/AirTemperatureLockout.mos"
        "Simulate and plot"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirTemperatureLockout;
