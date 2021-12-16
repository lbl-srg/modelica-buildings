within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialBaseLine "Partial cable line dispersion model"
  parameter Modelica.Units.SI.Length l(min=0) "Length of the line";
  parameter Modelica.Units.SI.Power P_nominal(min=0)
    "Nominal power of the line";
  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=220)
    "Nominal voltage of the line";
  final parameter Modelica.Units.SI.Frequency f_n=50
    "Frequency considered in the definition of cables properties";

  parameter Boolean use_C = false
    "Set to true to add a capacitance in the center of the line"
    annotation(Evaluate=true, Dialog(tab="Model", group="Assumptions"));
  parameter Buildings.Electrical.Types.Load modelMode=Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Select between steady state and dynamic model"
    annotation(Evaluate=true, Dialog(tab="Model", group="Assumptions", enable = use_C), choices(choice=Buildings.Electrical.Types.Load.FixedZ_steady_state
        "Steady state", choice=Buildings.Electrical.Types.Load.FixedZ_dynamic "Dynamic"));
  parameter Boolean use_T = false
    "If true, enables the input for the temperature of the cable" annotation(Evaluate = true, Dialog(tab="Model", group="Thermal"));
  parameter Modelica.Units.SI.Temperature TCable=T_ref
    "Fixed temperature of the cable" annotation (Dialog(
      tab="Model",
      group="Thermal",
      enable=not use_T));

  parameter Buildings.Electrical.Types.CableMode mode=Buildings.Electrical.Types.CableMode.automatic
    "Select if choosing the cable automatically or between a list of commercial options"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Auto/Manual mode"), choicesAllMatching=true);

  replaceable parameter
    Buildings.Electrical.Transmission.LowVoltageCables.Generic
     commercialCable constrainedby
    Buildings.Electrical.Transmission.BaseClasses.BaseCable
    "Commercial cables options"
    annotation(Evaluate=true, Dialog(tab="Tech. specification", group="Manual mode",
    enable = mode == Buildings.Electrical.Types.CableMode.commercial),
               choicesAllMatching = true);

  final parameter Modelica.Units.SI.Temperature T_ref=commercialCable.T_ref
    "Reference temperature of the line" annotation (Evaluate=True);
  final parameter Modelica.Units.SI.Temperature M=commercialCable.M
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  final parameter Modelica.Units.SI.Resistance R=commercialCable.lineResistance(
      l,
      f_n,
      commercialCable) "Resistance of the cable" annotation (Evaluate=True);
  final parameter Modelica.Units.SI.Inductance L=commercialCable.lineInductance(
      l,
      f_n,
      commercialCable)
    "Inductance of the cable due to mutual and self inductance"
    annotation (Evaluate=True);
  final parameter Modelica.Units.SI.Capacitance C=
      commercialCable.lineCapacitance(
      l,
      f_n,
      commercialCable) "Capacitance of the cable" annotation (Evaluate=True);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature cableTemp
    "Temperature of the cable"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Interfaces.RealInput T if use_T "Temperature of the cable"
   annotation (
     Placement(transformation(extent={{-42,28},{-2,68}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
  Modelica.Blocks.Sources.RealExpression cableTemperature(y=T_in)
    "Temperature of the cable"
    annotation (Placement(transformation(extent={{-92,12},{-72,32}})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in
    "Internal variable for conditional temperature";
equation
  assert(L>=0 and R>=0 and C>=0, "The parameters R,L,C must be positive. Check cable properties and size.");
  connect(T_in, T);

  if not use_T then
    T_in = TCable;
  end if;

  connect(cableTemperature.y, cableTemp.T) annotation (Line(
      points={{-71,22},{-62,22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-150,-19},{150,-59}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
This partial model contains parameters and variables needed to parametrize a
generic cable. The resistance, inductance and capacitance
are computed by the functions associated to the type of cable selected.
The type of cable is specified using a record that inherits from
<a href=\"modelica://Buildings.Electrical.Transmission.BaseClasses.BaseCable\">
Buildings.Electrical.Transmission.BaseClasses.BaseCable</a> such as (
<a href=\"modelica://Buildings.Electrical.Transmission.LowVoltageCables.Generic\">
Buildings.Electrical.Transmission.LowVoltageCables.Generic</a> or
<a href=\"modelica://Buildings.Electrical.Transmission.MediumVoltageCables.Generic\">
Buildings.Electrical.Transmission.MediumVoltageCables.Generic</a>).
The record contains functions that depending on the properties of cable compute its
resistance, inductance or capacitance.
</p>
<p>
The model has two parameters <code>use_C</code> and <code>modelMode</code> that
change the behaviour of the model. It is possible to include the effects
of a capacity or select the model to be dynamic or steady state. More information
are available in the line models that extends this partial model.
</p>

<h4>Commercial cable mode</h4>
<p>
If <code>mode = commercial</code>, the user can select the type of cable from a list
of commercial cables. The cables are divided in three different categories:
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
If <code>mode = automatic</code>, the type of cable is automatically selected
depending on the value of the parameters <code>V_nominal</code> and
<code>P_nominal</code>.
</p>

<h4>Note:</h4>
<p>
More details about the functions that compute the type of cable and its
properties can be found in <a href=\"modelica://Buildings.Electrical.Transmission.Functions\">
Buildings.Electrical.Transmission.Functions</a>.
</p>
<p>
The parameter <code>commercialCable</code> is assumed to be
<a href=\"modelica://Buildings.Electrical.Transmission.LowVoltageCables.Generic\">
Buildings.Electrical.Transmission.LowVoltageCables.Generic</a>.
The parameter is replaceable so it can be redeclared using a different type, for example
<a href=\"modelica://Buildings.Electrical.Transmission.MediumVoltageCables.Generic\">
Buildings.Electrical.Transmission.MediumVoltageCables.Generic</a>.<br/>
The example models
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples.ACLineMedium\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples.ACLineMedium</a> and
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples.ACSimpleGridMedium\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples.ACSimpleGridMedium</a>
show how this can be done.
</p>

</html>", revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Revised model and documentation according to change in the structure of the cable record.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end PartialBaseLine;
