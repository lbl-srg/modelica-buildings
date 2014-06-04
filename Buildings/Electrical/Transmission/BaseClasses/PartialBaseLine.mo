within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialBaseLine
  "Partial cable line dispersion parametrization model"
  parameter Modelica.SIunits.Length l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage of the line";

  parameter Boolean use_C = false
    "Set to true to add a capacitance in the center of the line"
    annotation(Evaluate=true, Dialog(tab="Model", group="Assumptions"));
  parameter Buildings.Electrical.Types.Assumption modelMode=Types.Assumption.FixedZ_steady_state
    "Select between steady state and dynamic model"
    annotation(Evaluate=true, Dialog(tab="Model", group="Assumptions", enable = use_C), choices(choice=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
        "Steady state", choice=Buildings.Electrical.Types.Assumption.FixedZ_dynamic "Dynamic"));
  parameter Boolean use_T = false
    "If true, enables the input for the temperature of the cable" annotation(Evaluate = true, Dialog(tab="Model", group="Thermal"));
  parameter Modelica.SIunits.Temperature TCable = T_ref
    "Fixed temperature of the cable" annotation(Evaluate=true, Dialog(tab="Model", group="Thermal", enable = not use_T));

  parameter Buildings.Electrical.Types.CableMode mode=Types.CableMode.automatic
    "Select if choosing the cable automatically or between a list of commercial options"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Auto/Manual mode"), choicesAllMatching=true);

  parameter Buildings.Electrical.Types.VoltageLevel voltageLevel=
      Functions.selectVoltageLevel(V_nominal) "Select the voltage level"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Buildings.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  parameter Buildings.Electrical.Transmission.LowVoltageCables.Cable commercialCable_low=
      Functions.selectCable_low(P_nominal, V_nominal)
    "List of Low voltage commercial cables"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Buildings.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  parameter Buildings.Electrical.Transmission.MediumVoltageCables.Cable commercialCable_med=
      Functions.selectCable_med(P_nominal, V_nominal)
    "List of Medium Voltage commercial cables"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Manual mode", enable = mode == Buildings.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  final parameter Modelica.SIunits.Temperature T_ref = if voltageLevel==Types.VoltageLevel.Low                      then commercialCable_low.Tref else commercialCable_med.Tref
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Temperature M = Functions.temperatureConstant(                                  voltageLevel, commercialCable_low, commercialCable_med)
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  final parameter Modelica.SIunits.Resistance R=
  Functions.lineResistance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Resistance of the cable" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Inductance L=
  Functions.lineInductance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);
  final parameter Modelica.SIunits.Capacitance C=
  Functions.lineCapacitance(                                  l, voltageLevel, commercialCable_low, commercialCable_med)
    "Capacitance of the cable" annotation(Evaluate = True);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature cableTemp
    "Temperature of the cable"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Interfaces.RealInput T if use_T "Temperature of the cable"      annotation (
     Placement(transformation(extent={{-42,28},{-2,68}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
public
  Modelica.Blocks.Sources.RealExpression cableTemperature(y=T_in)
    annotation (Placement(transformation(extent={{-92,12},{-72,32}})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in
    "Internal variable for conditional temperature";
equation
  assert(L>=0 and R>=0 and C>=0, "The parameters R,L,C must be positive! check cable properties and size");
  connect(T_in, T);

  if not use_T then
    T_in = TCable;
  end if;

  connect(cableTemperature.y, cableTemp.T) annotation (Line(
      points={{-71,22},{-62,22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-150,-19},{150,-59}},
            lineColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
This partial model contains the parameters and variable needed to parametrized 
generic cable. The parameters of the cable (resistance, inductance and capacitance)
are computed in two different ways depending on the <code>mode</code>.
</p>
<p>
The model has two parameters <code>use_C</code> and <code>modelMode</code> that can
be used to change the behaviour of the model. It is possible to include the effects
of a capacity or select if the model should be dynamic or steady state. More information
are available in the line models that extends this partial model.
</p>

<h4>Commercial cable mode</h4>
<p>
When <code>mode = commercial</code> the user can select the type of cable from a list
of commercially available cables. The cables are divided in two different categories:
</p>
<ul>
<li>Low voltage,</li>
<li>Medium voltage, and</li>
<li>High voltage.</li>
</ul>
<p>
The details and type of cables can be found in
<a href=\"modelica://Buildings.Electrical.Transmission.LowVoltageCables\">
Buildings.Electrical.Transmission.LowVoltageCables</a> and 
<a href=\"modelica://Buildings.Electrical.Transmission.MediumVoltageCables\">
Buildings.Electrical.Transmission.MediumVoltageCables</a>.
</p>

<h4>Automatic cable mode</h4>
<p>
When <code>mode = automatic</code> the type of cable is automatically selected
depending on the value of the following parameters: <code>V_nominal</code>, and
<code>P_nominal</code>.
</p>

<h4>Note:</h4>
<p>
More details about the functions that compute the type of cable and its  
properties can be found in <a href=\"modelica://Buildings.Electrical.Transmission.Functions\">
Buildings.Electrical.Transmission.Functions</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end PartialBaseLine;
